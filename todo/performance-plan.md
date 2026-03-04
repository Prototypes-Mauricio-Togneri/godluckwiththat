# Performance Fix Plan — Safari CPU/GPU Issue

## Problem

The game runs at 85% CPU in Safari after some play time. The root cause is
**Vue's deep `reactive()` proxy wrapping the entire game state**, combined with
**~60 fps mutations** from `requestAnimationFrame`. Safari's `Proxy`
implementation is 2-5x slower than V8 (Chrome/Edge), so every property
read/write through the proxy is expensive.

There are no memory leaks. The issue is sustained high CPU from proxy overhead.

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

## Fix 3 — Skip idle research and events in rAF loop

**File:** `src/js/engine/state.js` (lines 268-298)

**Problem:** `advanceResearch` iterates `academy.active` Map every frame (even
when empty). `advanceEvents` iterates `events.future` array every frame (even
when empty).

**Fix:** Add early returns when there's nothing to advance:

```js
advanceResearch(delta) {
  const { academy } = this.colony.buildings
  if (academy.active.size === 0) return  // <-- skip when idle
  // ... existing logic
}

advanceEvents(delta) {
  if (this.colony.events.future.length === 0) return  // <-- skip when idle
  this.colony.events.advance(delta)
}
```

Also in `advanceSeason` — season always advances, so no skip possible, but
ensure it's a single property write (already is).

**Impact:** Small but meaningful — eliminates Map/Array iteration overhead on
frames where nothing is active.

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

## Implementation Order

1. **Fix 3** (early returns) — Smallest change, immediate benefit, no risk
2. **Fix 2** (constructing set) — Small change, good benefit, low risk
3. **Fix 6** (explicit property access) — Small change, no risk
4. **Fix 1** (decouple engine from reactivity) — Largest change, highest impact
5. **Fix 4** (computed properties) — Natural follow-up to Fix 1
6. **Fix 5** (throttle UI sync) — Final optimization layer on top of Fix 1

Fixes 1-3 can be done independently. Fixes 4-5 depend on Fix 1.

---

## Expected Outcome

The combination of these fixes should reduce Safari CPU from ~85% to well under
20% during normal gameplay by:
- Eliminating ~95% of Proxy trap invocations in the hot path
- Reducing Vue re-render frequency from ~60fps to ~20fps
- Skipping iteration of idle buildings/research/events
- Caching derived values that change infrequently
