# Testing Improvements

## 1. State Private Methods (`tests/engine/state.test.js`)

Add dedicated test cases for the private helper methods in `State`. These are currently only tested indirectly through `update()` and public methods.

### Computation Methods

- **`_computeGeneralProductivity()`**
  - Returns 1 when food and wood are sufficient
  - Returns reduced value when food is short
  - Returns reduced value when wood is short
  - Returns minimum of food/wood penalty when both are short
  - Returns 0 when a resource is completely depleted

- **`_computeSeasonMultipliers()`**
  - Returns base multipliers in warm season
  - Applies cold season penalties
  - Stacks blessing modifiers on top of season
  - Stacks punishment modifiers on top of season

- **`_computeConsumptionRates()`**
  - Returns zero rates with no workers
  - Scales with worker count
  - Applies research bonuses (reduced consumption)

- **`_computeProductionRates()`**
  - Returns zero with no buildings
  - Aggregates production from multiple buildings
  - Scales with assigned workers
  - Applies productivity and season multipliers

### Challenge Resolution Chain

- **`_resolveChallengeTimeout()`**
  - Resolves when timeout is reached
  - Does not resolve before timeout
  - Handles edge case at exact timeout tick

- **`_deductRequirements()`**
  - Deducts resources when affordable
  - Handles case when resources are insufficient

- **`_completeChallenge()`**
  - Applies reward correctly
  - Updates challenge state

- **`_failChallenge()`**
  - Applies punishment correctly
  - Updates challenge state

- **`_sacrificeWorkers()`**
  - Removes correct number of workers
  - Handles case when fewer workers than required

### Effect Management

- **`_advanceEffectTimeouts()`**
  - Decrements active blessing duration
  - Decrements active punishment duration
  - Clears blessing when duration reaches 0
  - Clears punishment when duration reaches 0
  - No-ops when no active effects

- **`_applyBlessing()`**
  - Sets blessing on colony
  - Initializes duration timer

### Other Private Methods

- **`_constructionDurationMult` (getter)**
  - Returns 1 with no research bonus
  - Returns correct reduced multiplier with research

- **`_recruit()`**
  - Auto-recruits worker when assigning to building
  - Respects population cap