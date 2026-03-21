# Testing Plan

Expand coverage from 91% statements / 84% branches to ~97% statements / ~95% branches.
All new tests go into existing test files following the project's conventions (see `docs/testing.md`).

---

## Phase 2 — `state.js` private helper methods

File: `tests/engine/state.test.js`

### 2.1 `_triggerTutorialModal`

Add a `describe('_triggerTutorialModal', ...)` block with:

- should set `tutorial.activeModal` to the given key
- should pause the game
- should not trigger when key is already in `dismissedModals`
- should not trigger when `activeModal` is already set
- should not trigger when `storage.tutorialCompleted` is true

### 2.2 `_playAssignSound`

Add a `describe('_playAssignSound', ...)` block with:

- should play `SND_WORKER_FARM` for farm
- should play `SND_WORKER_WOODCUTTER` for woodcutter
- should play `SND_WORKER_ACADEMY` for academy
- should play `SND_WORKER_TEMPLE` for temple
- should play `SND_WORKER_MINE` for quarry, copper_mine, iron_mine, gold_mine
- should not play any sound for non-producer buildings (e.g. house)

### 2.3 `_buildingName`

Add a `describe('_buildingName', ...)` block with:

- should return `t('building.headquarters.<type>')` for headquarters
- should return `t('building.<key>')` for non-headquarters buildings

---

## Phase 3 — `state.js` `fromJSON` branch coverage

File: `tests/engine/state.test.js`, within the existing `toJSON / fromJSON` describe block.

### 3.1 `fromJSON` with `challengeModal`

- should restore `paused` to true when `challengeModal` is set in data (covers lines 1318-1320)

### 3.2 `fromJSON` with missing tracking fields

- should default `resourcesAtCap` to empty set when missing from data
- should default `resourcesNegativeProduction` to empty set when missing
- should default `hadIdleWorkers` to false when missing
- should default `challengeModal` to null when missing

---

## Phase 4 — Branch coverage in model files

### 4.1 `cost.js` `entries` — uncovered resources (lines 50-63)

File: `tests/models/cost.test.js`, within the existing `entries` describe block.

- should include copper when non-zero
- should include iron when non-zero
- should include gold when non-zero
- should include knowledge when non-zero
- should include faith when non-zero

These can be a single test that creates a `Cost` with all 8 resources non-zero and asserts `entries.size === 8`.

### 4.2 `challenges.js` `toJSON` — null active branch (line 122)

File: `tests/models/challenges.test.js`, within the existing `fromJSON / toJSON` describe block.

- should serialize `active` as null when no active challenge

### 4.3 `events.js` — miss branches (lines 83, 140)

File: `tests/models/events/events.test.js`

- `convertToPast`: should still add past event when no matching future event found (buildingKey not in future array — covers line 83 false branch)
- `dismiss`: should no-op gracefully when ID does not match any future or past event (covers line 140 false branch)

### 4.4 `buildings.js` `pendingTerritory` — per-building branches (lines 100-149)

File: `tests/models/buildings.test.js`, within the existing `pendingTerritory` describe block.

- should count each individual building type when constructing

Use a loop or `it.each` over all 19 non-HQ building keys: set each one to constructing, assert `pendingTerritory === 1`. This covers all 19 `if` branches.

### 4.5 `academy.js` `completedBonuses` — subcategory without bonus (line 96-97)

File: `tests/models/buildings/academy.test.js`, within the existing `completedBonuses` describe block.

- should skip subcategories that have no `bonus` property

Pass a research tree that includes a subcategory with `bonus: undefined` alongside one with a valid bonus — assert only the valid bonus appears in the result.

---

## Phase 5 — Factory functions in `constants.js`

File: `tests/engine/constants.test.js`, within the existing `factory functions` describe block.

### 5.1 `createInitialColonyBasic`

- should return a Colony instance
- should have HQ at level 1 with type camp
- should have starting food of 250 and wood of 100

### 5.2 `createInitialColonyAdvanced`

- should return a Colony instance
- should have HQ at level 5 with type city
- should have 60 workers and 1000 of each basic resource

---

## Phase 6 — `Research` class direct tests

File: `tests/models/buildings/academy.test.js`

### 6.1 `Research`

Add a `describe('Research', ...)` block with:

- should initialize with duration and remainingSeconds equal to duration
- should accept custom remainingSeconds override
- `advance` should decrement remainingSeconds by delta
- `advance` should clamp remainingSeconds at 0

---

## Execution order

Work through phases 1–6 sequentially. After each phase:
1. Run `npm test` to verify all tests pass
2. Run `npm run lint-fix` to fix style
3. Run `npm run test:coverage` to confirm coverage improvement

Expected final coverage (approximate):
- Statements: ~97%
- Branches: ~95%
- Functions: ~99%
- Lines: ~97%
