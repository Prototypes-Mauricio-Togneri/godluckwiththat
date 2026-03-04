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

## Fix 1 — Decouple game engine from Vue reactivity

**File:** `src/components/screens/game_screen.vue`

**Problem:** Line 236 wraps the entire object graph in a deep reactive proxy:

```js
const state = reactive(new State(createInitialMeta(), createInitialColony()))
```

This means every property on State, Colony, Buildings (×20), Resources,
Production, Consumption, Season, Events, and every nested object is accessed
through Proxy traps. The rAF loop mutates `seasonElapsed`,
`constructionRemaining`, `upgradeRemaining`, `research.remainingSeconds`, and
`event.remainingSeconds` ~60 times per second — each write triggers Vue's
dependency tracker and potentially schedules a re-render.

**Fix:** Use `shallowRef` for the State instance. The game engine operates on
plain JS objects with zero proxy overhead. The UI reads from a separate
`shallowReactive` "view model" that is updated once per frame with only the
values the template actually needs.

```js
import { shallowRef, shallowReactive, triggerRef } from 'vue'

// Engine state — plain JS, no proxy overhead on mutations
const state = new State(createInitialMeta(), createInitialColony())

// UI view model — only the values the template reads, updated once per frame
const ui = shallowReactive({
  year: state.colony.year,
  seasonElapsed: state.colony.season.seasonElapsed,
  currentSeason: state.colony.season.currentSeason,
  resources: { ...state.colony.resources },         // shallow copy
  production: { ...state.colony.production },
  consumption: { ...state.colony.consumption },
  workers: state.colony.resources.workers,
  workersCap: state.colony.buildings.house.workersCap,
  idleWorkers: state.colony.idleWorkers,
  territory: state.colony.resources.territory,
  territoryCap: state.colony.buildings.headquarters.territoryCap,
  hqType: state.colony.buildings.headquarters.type,
  storageCap: 0,
  futureEvents: [],   // snapshot of future event data for rendering
  pastEvents: [],      // snapshot of past event data for rendering
  buildings: {},       // per-building snapshot (constructionRemaining, level, etc.)
})
```

A single `syncUI()` function copies the values the template needs from the
plain engine state into `ui`. It is called:
- Once at the end of `progressTick` (replaces current direct mutations)
- Once at the end of `gameTick`
- Once after any player action (build, recruit, assign, research, trade)

This reduces proxy writes from ~40-100+ per frame down to one batch assignment
per frame, and eliminates all proxy reads from the engine's hot path.

**Impact:** Eliminates the primary cause of Safari CPU usage.

**Considerations:**
- `provide('colony', ...)` and `provide('state', ...)` currently give child
  components direct access to the reactive state. These need to be refactored so
  child components either receive props from `ui` or access the plain `state`
  through a non-reactive provide + explicit trigger.
- Building card components access `colony.buildings[key]` via inject. They will
  need to read from `ui.buildings[key]` or receive props.
- Player action methods on `state` (levelUpBuilding, recruitWorker, etc.) remain
  unchanged — they mutate plain objects. The UI just calls `syncUI()` after.

---

## Fix 2 — Skip non-constructing buildings in `advanceConstruction`

**File:** `src/js/engine/state.js` (lines 226-261)

**Problem:** `advanceConstruction` calls `Object.entries(buildings)` every frame,
iterating all 20 buildings through the reactive proxy even when 0-1 are actually
constructing. Each iteration reads `building.isConstructing` (getter that reads
`constructionRemaining`) through the proxy.

**Fix:** Track which buildings are currently constructing in a lightweight Set.
Only iterate that Set in the rAF loop.

```js
// In State constructor
this._constructingKeys = new Set()

// In levelUpBuilding() — after building.levelUp():
this._constructingKeys.add(buildingKey)

// In expandTerritory() — after hq.levelUp():
this._constructingKeys.add(BUILDING_HEADQUARTERS)

// In advanceConstruction():
advanceConstruction(delta) {
  for (const key of this._constructingKeys) {
    const building = this.colony.buildings[key]
    if (building.advance(delta)) {
      this._constructingKeys.delete(key)
      // ... existing completion logic
    }
  }
  const hq = this.colony.buildings.headquarters
  if (hq.advanceUpgrade(delta)) {
    // ... existing completion logic
  }
}
```

Similarly, track HQ upgrade state with a boolean flag instead of checking
`hq.isUpgrading` every frame.

**Impact:** Reduces per-frame iteration from 20 buildings to only those
constructing (typically 0-2). Eliminates ~18-20 proxy reads per frame.

---

## Fix 4 — Convert template functions to computed properties

**File:** `src/components/screens/game_screen.vue`

**Problem:** Template expressions call plain functions like `seasonProgress()`,
`seasonIcon()`, `seasonTooltip()`, `resourceFillPercent(resource)`,
`rateClass(...)`, `timeEstimate(resource)`, `isBuildingLocked(buildingKey)`,
`isResourceVisible(resource)`, and `getBuildingImg(building)` on every render.
These are recalculated from scratch each time even if their inputs haven't
changed.

**Fix after Fix 1:** With the `ui` view model approach, most of these become
simple reads from `ui` rather than function calls. For example:

- `seasonProgress()` → `ui.seasonElapsed / SEASON_DURATION` (already a simple
  division, but now reads from a flat reactive object instead of traversing
  `state.colony.season.seasonElapsed` through multiple proxy layers)
- `storageCap` is already a `computed` — it stays, but reads from `ui` instead
  of deep proxy chain
- `isBuildingLocked` and `isResourceVisible` depend on `hqType` which rarely
  changes — make them `computed` keyed off `ui.hqType`

Specifically:
- `isBuildingLocked` iterates `HQ_TYPES` and `HQ_BUILDING_UNLOCKS` for every
  building on every render. Convert to a `computed` that returns a `Set` of
  unlocked building keys, recalculated only when `ui.hqType` changes.
- `isResourceVisible` — same pattern, return a `Set` of visible resource keys.

**Impact:** Eliminates redundant computation on re-renders. Moderate impact.

---

## Fix 5 — Throttle UI sync to animation frame budget

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

## Fix 6 — Avoid `Object.entries()` in `totalLevels` and `pendingTerritory`

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

## Fix 8 — Reduce GC pressure from `Cost.entries` and `levelUpCost`

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

## Fix 10 — Cache `completedBonuses()` invalidation cascade

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

## Implementation Order

2. **Fix 2** (constructing set) — Small change, good benefit, low risk
3. **Fix 6** (explicit property access) — Small change, no risk
7. **Fix 4** (computed properties) — Natural follow-up to Fix 1
6. **Fix 1** (decouple engine from reactivity) — Largest change, highest impact

After Fix 1, the remaining fixes become less critical but still provide incremental improvements:
8. **Fix 5** (throttle UI sync) — Final optimization layer on top of Fix 1
9. **Fix 8** (reduce GC pressure from Cost) — Addressed naturally by Fix 1, or standalone cache
10. **Fix 10** (completedBonuses cache) — Addressed naturally by Fix 1, or standalone workaround

Fixes 1-4, 7, 9 can be done independently. Fixes 5, 8, 10 depend on or benefit from Fix 1.
