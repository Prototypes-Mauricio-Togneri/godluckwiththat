# Test Coverage Improvement Plan

## Goal

Close the 51 uncovered lines in `state.js` (89.5% → ~100% statements) and the 1 uncovered line in `constants.js` (98% → 100%). All other source files are already at 100%.

---

## Step 1: `advanceConstruction` — building-type-specific completion branches

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 550–580 (6 branches)

Add tests inside `describe('advanceConstruction')`:

1. **HQ level-up completion**: Build HQ (not type upgrade), advance timer to 0. Assert:
   - `convertToPast` called with `event.territoryExpanded` text and `IMG_OTHER_TERRITORY` icon
   - `SND_TERRITORY_EXPANDED` sound played
   - `EVENT_TYPE_TERRITORY_LIMIT_REACHED` past events dismissed

2. **Storehouse completion**: Build storehouse, advance timer to 0. Assert:
   - `dismissFutureByBuildingKey('storehouse')` called
   - `EVENT_TYPE_RESOURCE_LIMIT_REACHED` past events dismissed
   - `_resourcesAtCap` cleared

3. **House completion**: Build house, advance timer to 0. Assert:
   - `EVENT_TYPE_POPULATION_LIMIT_REACHED` past events dismissed

4. **Monument completion**: Build monument at level 2, advance timer to 0. Assert:
   - `resources.faith` increased by `MONUMENT_FAITH_PER_LEVEL * 2`

5. **HQ type upgrade completion**: Start HQ upgrade, advance timer to 0. Assert:
   - `_hqUpgrading` set to `false`
   - `dismissFutureByBuildingKey(BUILDING_HEADQUARTERS)` called
   - `SND_HEADQUARTERS_UPGRADED` sound played
   - Tutorial modal `TUTORIAL_MODAL_HQ_UPGRADE` triggered

---

## Step 2: `_computeProductionRates` — remaining blessing branches

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 473–490 (4 blessing types)

Add tests inside `describe('_computeProductionRates')`:

1. **`FOREST_BLOOM`**: Verify `multipliers.wood` increases by `blessing.productivity`
2. **`RICH_MINES`**: Verify `multipliers.stone`, `.copper`, `.iron`, `.gold` all increase
3. **`WISDOM_OF_THE_GODS`**: Verify `multipliers.knowledge` increases
4. **`CELESTIAL_PROSPERITY`**: Verify all 8 resource multipliers increase

Each test: create a State with an active blessing of the given type, call `_computeProductionRates`, assert the returned `multipliers` object.

---

## Step 3: `update()` — resource cap and negative production recovery

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 214–216, 250–252

Add tests inside `describe('update')`:

1. **Resource drops below storage cap**: Pre-populate `_resourcesAtCap` with a resource, set that resource below `storageCap`, call `update(1)`. Assert the resource is removed from `_resourcesAtCap` and `dismissPastByTextKey` is called with the correct config text key.

2. **Negative production recovers**: Pre-populate `_resourcesNegativeProduction` with a resource, set production to exceed consumption, call `update(1)`. Assert the resource is removed from `_resourcesNegativeProduction` and the negative-production past event is dismissed.

---

## Step 4: `advanceChallenges` — untested paths

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 644, 652, 659–660, 672, 677

Add tests inside `describe('advanceChallenges')`:

1. **`allCompleted` short-circuit**: Set `challenges.allCompleted` to true (empty pending, no active, non-empty completed). Call `advanceChallenges(1)`. Assert no activation or timer advancement occurs.

2. **No pending challenges, no active**: Empty pending array, null active. Call `advanceChallenges(1)`. Assert early return (no errors).

3. **Delay → started transition**: Set active challenge with `delayElapsed` about to become true. Call `advanceChallenges(delta)` so delay expires. Assert:
   - `challenges.start()` called (status → started)
   - `EVENT_TYPE_CHALLENGE_STARTED` future event created with correct params
   - `SND_NOTIFICATION_ALERT` sound played

4. **Timeout expiry**: Set active challenge with `timeoutElapsed` about to become true, requirements met. Call `advanceChallenges(delta)`. Assert `_resolveChallengeTimeout` path executes (challenge completes or fails).

---

## Step 5: `areChallengeRequirementsMet` — missing requirement types

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 715, 718, 731

Add tests inside `describe('areChallengeRequirementsMet')`:

1. **Monument level insufficient**: Active challenge requires `monument: 3`, colony monument at level 1 → return `false`
2. **Temple level insufficient**: Active challenge requires `temple: 2`, colony temple at level 0 → return `false`
3. **Workers insufficient**: Active challenge requires `workers: 10`, colony has 3 workers → return `false`

---

## Step 6: `assignWorkers` — auto-recruit failure branch

**File**: `tests/engine/state.test.js`
**Uncovered line**: 1098

Add test inside `describe('assignWorkers')`:

1. **Auto-recruit fails mid-batch**: Set idle workers to 0, resources insufficient for recruit cost, building not full. Call `assignWorkers(key, 5)`. Assert no workers assigned (building.workers unchanged).

---

## Step 7: `checkTutorial` — tutorial completion branch

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 1215–1217

Add test inside `describe('checkTutorial')`:

1. **All steps completed**: Set building state so every `TUTORIAL_STEPS[i].check()` returns true (HQ level >= 2, house level >= 1, farm level >= 1, HQ type !== camp). Call `checkTutorial()`. Assert `tutorial.completed === true` and `storage.tutorialCompleted === true`.

---

## Step 8: `levelUpBuilding` — territory limit event

**File**: `tests/engine/state.test.js`
**Uncovered lines**: 957, 962

Add test inside `describe('levelUpBuilding')`:

1. **Territory becomes full after build**: Set territory near cap (one slot remaining), build a building. Assert `EVENT_TYPE_TERRITORY_LIMIT_REACHED` past event fired and `SND_NOTIFICATION_ALERT` played after `update(0)`.

---

## Step 9: `constants.js` — tutorial step check function

**File**: `tests/engine/constants.test.js`
**Uncovered line**: 766

Add test inside `describe('factory functions')` or a new `describe('TUTORIAL_STEPS')`:

1. **`upgradeCamp` step check**: Call `TUTORIAL_STEPS` step with `building: BUILDING_HEADQUARTERS` and `check` function. Pass buildings with HQ type `HQ_TYPE_SETTLEMENT` → assert `true`. Pass with `HQ_TYPE_CAMP` → assert `false`.

---

## Summary

| Step | Target | Lines Covered | New Tests |
|------|--------|---------------|-----------|
| 1 | `advanceConstruction` branches | 550–580 | 5 |
| 2 | `_computeProductionRates` blessings | 473–490 | 4 |
| 3 | `update()` recovery branches | 214–216, 250–252 | 2 |
| 4 | `advanceChallenges` paths | 644, 652, 659–660, 672, 677 | 4 |
| 5 | `areChallengeRequirementsMet` | 715, 718, 731 | 3 |
| 6 | `assignWorkers` failure | 1098 | 1 |
| 7 | `checkTutorial` completion | 1215–1217 | 1 |
| 8 | `levelUpBuilding` territory event | 957, 962 | 1 |
| 9 | `constants.js` tutorial step | 766 | 1 |
| **Total** | | **52 lines** | **22 tests** |

Expected result: `state.js` → ~100% statements/lines, `constants.js` → 100%. Overall coverage → ~99%+ statements.
