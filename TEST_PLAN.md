# Test Coverage Improvement Plan

## Goal

Close the 51 uncovered lines in `state.js` (89.5% → ~100% statements) and the 1 uncovered line in `constants.js` (98% → 100%). All other source files are already at 100%.

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
| 8 | `levelUpBuilding` territory event | 957, 962 | 1 |
| 9 | `constants.js` tutorial step | 766 | 1 |
| **Total** | | | **2 tests** |

Expected result: `state.js` → ~100% statements/lines, `constants.js` → 100%. Overall coverage → ~99%+ statements.
