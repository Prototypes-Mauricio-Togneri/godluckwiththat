# Test Plan

## Suggested New Tests (prioritized)

### High Priority (uncovered branches)

1. **`state.js:652`** — `advanceChallenges` with no active and no pending challenge after initial guard
   - Test: Create state with empty pending and null active, call `advanceChallenges(1)`, verify early return without error

2. **`constants.js:820,825`** — `createInitialChallenges` punishment field `??` fallbacks
   - Test: Create challenge template with `undefined` values for `punishment.faith` and `punishment.resource`, verify defaults to `null`

3. **`challenges.js:95`** — `advance()` with `CHALLENGE_STATUS_STARTED`
   - Test: Create challenges with active challenge in `STARTED` status, call `advance(5)`, verify `timeoutElapsed` incremented

4. **`cost.js:98`** — `toSeconds` with unknown resource key
   - Test: Create Cost with a hypothetical resource not in `RESOURCE_TIME_WEIGHTS`, verify `?? 0` fallback

### Low Priority (edge cases for completeness)

5. **`market.js`** — `executeTrade` with `blessedMarkets` flag active
   - Already indirectly tested via `effectiveTradeFee`, but a direct trade under blessed conditions would strengthen coverage

6. **`serialization.test.js`** — Add `Production` and `Consumption` robustness tests
   - These simple classes have constructor tests but no `fromJSON` robustness entries in `serialization.test.js`
