# Test Coverage Improvement Plan

## Goal

Close the 51 uncovered lines in `state.js` (89.5% → ~100% statements) and the 1 uncovered line in `constants.js` (98% → 100%). All other source files are already at 100%.

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
| 7 | `checkTutorial` completion | 1215–1217 | 1 |
| 8 | `levelUpBuilding` territory event | 957, 962 | 1 |
| 9 | `constants.js` tutorial step | 766 | 1 |
| **Total** | | | **3 tests** |

Expected result: `state.js` → ~100% statements/lines, `constants.js` → 100%. Overall coverage → ~99%+ statements.
