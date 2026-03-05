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
