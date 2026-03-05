# Performance Fix Plan — Safari CPU/GPU Issue

## Problem

The game runs at 85% CPU in Safari after some play time. The root cause is
**Vue's deep `reactive()` proxy wrapping the entire game state**, combined with
**~60 fps mutations** from `requestAnimationFrame`. Safari's `Proxy`
implementation is 2-5x slower than V8 (Chrome/Edge), so every property
read/write through the proxy is expensive.

There are no traditional memory leaks (all listeners/intervals/rAF are cleaned
up properly, all `v-for` have keys). The issue is sustained high CPU from proxy
overhead, compounded by GC pressure from frequent object allocation and
unbounded growth of the past events array.

---

## Fix 3 — Throttle UI sync to animation frame budget

**File:** `src/components/screens/game_screen.vue`

**Problem:** Even with Fix 1, syncing the UI view model every rAF frame (~60fps)
means Vue processes reactive updates 60 times per second. Most visual changes
(season bar, construction progress, event countdowns) don't need pixel-perfect
60fps updates — 15-20fps is perceptually smooth for progress bars.

**Fix:** Throttle `syncUI()` in the rAF loop to ~20fps (every 50ms), while
keeping the engine's `advanceSeason/Construction/Research/Events` at full rAF
rate for accurate timekeeping:

```js
const UI_SYNC_INTERVAL = 50 // ms (~20fps visual updates)
let lastUISyncTime = 0

function progressTick() {
  if (paused.value) return
  const now = performance.now()
  const delta = (now - lastProgressTickTime) / 1000
  lastProgressTickTime = now

  // Engine advances at full rAF rate (accurate timekeeping)
  state.advanceSeason(delta)
  state.advanceConstruction(delta)
  state.advanceResearch(delta)
  state.advanceEvents(delta)

  // UI syncs at throttled rate (saves rendering cost)
  if (now - lastUISyncTime >= UI_SYNC_INTERVAL) {
    lastUISyncTime = now
    syncUI()
  }

  progressAnimFrame = requestAnimationFrame(progressTick)
}
```

**Impact:** Reduces Vue reactive processing from ~60fps to ~20fps. Major
reduction in Safari proxy + rendering overhead. Progress bars still animate
smoothly because CSS `transition: width 1s ease` handles interpolation.

---

## Fix 4 — Avoid `Object.entries()` in `totalLevels` and `pendingTerritory`

**File:** `src/js/models/buildings.js` (lines 58-100)

**Problem:** `totalLevels` and `pendingTerritory` use `Object.entries(this)` to
iterate all 20 buildings. These are called from `state.update()` (1Hz) which is
acceptable, but `totalLevels` enumerates every key through the proxy.

**Fix:** Use explicit property access like `totalAssignedWorkers` already does:

```js
get totalLevels() {
  return this.house.level + this.academy.level + this.storehouse.level
    + this.market.level + this.altar.level + this.temple.level
    + this.monument.level + this.farm.level + this.woodcutter.level
    + this.quarry.level + this.copperMine.level + this.ironMine.level
    + this.goldMine.level + this.barracks.level + this.archery.level
    + this.stable.level + this.workshop.level + this.wall.level
    + this.tower.level
}

get pendingTerritory() {
  let count = 0
  if (this.house.isConstructing) count++
  if (this.academy.isConstructing) count++
  if (this.storehouse.isConstructing) count++
  // ... all 19 non-HQ buildings
  return count
}
```

**Impact:** Eliminates `Object.entries()` overhead (proxy key enumeration +
temporary array allocation). Small but consistent improvement on every 1s tick.

---

## Fix 5 — Reduce GC pressure from `Cost.entries` and `levelUpCost`

**File:** `src/js/models/cost.js` (lines 36-63)

**Problem:** The `Cost.entries` getter creates a new `Map` on every call:

```js
get entries() {
  const map = new Map()
  if (this.food > 0) map.set(RESOURCE_FOOD, this.food)
  // ... 7 more checks
  return map
}
```

This getter is used in template `v-for` loops (`actionCostEntries` computed in
`base_card.vue`, `levelUpCostEntries` and `upgradeCostEntries` in
`headquarters_card.vue`, research modal cost display). Every re-render creates
a new `Map`.

Additionally, `levelUpCost` getters on building classes create new `Cost`
objects via `multiply().floor()` on every access. Combined with `entries`, each
re-render produces 2+ `Cost` objects and 1+ `Map` per visible building card —
creating frequent small allocations that increase GC pressure.

**Fix after Fix 1:** With the `ui` view model, cost snapshots for display can be
computed once in `syncUI()` and stored as plain objects, avoiding per-render
allocation entirely. If implemented before Fix 1, consider caching the `entries`
Map on the `Cost` instance (since `Cost` values are immutable after creation by
`floor()`).

**Impact:** Reduces garbage collection pressure. Moderate — most noticeable when
many building cards are visible.

---

## Fix 6 — Cache `completedBonuses()` invalidation cascade

**File:** `src/js/models/buildings/academy.js` (lines 96-120)

**Problem:** `completedBonuses(researchTree)` has a cache (`_bonusCache`), but
when a research completes, `complete()` sets `_bonusCache = null`. Because the
entire state is reactive, writing `null` to `_bonusCache` triggers a reactive
notification, which means every computed property or template binding that ever
read `_bonusCache` will re-evaluate.

`completedBonuses(RESEARCH_TREE)` is called from:
- `state.update()` (called every 1s tick)
- `state.expansionCost` getter (used in template)
- `state._constructionDurationMult` getter
- `storageCap` computed in `game_screen.vue`
- `storageCap` computed in `market_modal.vue`

`RESEARCH_TREE` is a large nested structure (5 categories, 18 subcategories, 90
research keys). Iterating through all of it on cache miss is non-trivial. The
reactive invalidation of `_bonusCache` also triggers cascading re-evaluations
across all of those consumers.

**Fix after Fix 1:** With plain (non-reactive) state, the `_bonusCache = null`
write no longer triggers Vue notifications. The cache invalidation becomes a
cheap operation. No further fix needed beyond Fix 1.

If implemented before Fix 1: consider making `_bonusCache` a non-enumerable
property (so Vue's `reactive()` doesn't track it) using
`Object.defineProperty(this, '_bonusCache', { value: null, writable: true })`.

**Impact:** Eliminates cascading reactive re-evaluations when research
completes. Medium — but mitigated by caching (only triggers on research
completion, not every frame).

---

## Proposed Implementation Order

- **Fix 1 — Decouple engine from Vue reactivity**: Foundation for all other fixes. Replace `reactive(State)` with plain JS + `shallowReactive` view model, refactor `provide`/`inject` and child component data access.
- **Fix 3 — Throttle UI sync to ~20fps**: Quick follow-up to Fix 1. Throttle `syncUI()` in the rAF loop while keeping engine at full rate for accurate timekeeping.
- **Fix 2 — Template functions to computed properties**: Convert `isBuildingLocked`, `isResourceVisible`, etc. to `computed` sets/values keyed off `ui`, eliminating redundant per-render recalculation.
- **Fix 4 — Explicit property access in `totalLevels`/`pendingTerritory`**: Small standalone change. Replace `Object.entries(this)` with explicit property sums to avoid proxy key enumeration and temp arrays.
- **Fix 5 — Reduce GC pressure from `Cost.entries`**: With the view model in place, pre-compute cost snapshots in `syncUI()` as plain objects instead of allocating `Map`/`Cost` on every render.
- **Fix 6 — Cache `completedBonuses` invalidation**: Largely resolved by Fix 1 (plain state means no reactive cascade). Verify after Fix 1; if needed pre-Fix-1, use non-enumerable `_bonusCache`.
