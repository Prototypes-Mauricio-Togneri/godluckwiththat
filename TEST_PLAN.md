# Test Plan

## Priority 2: Deeper model coverage

4. **`resources.test.js` — `toJSON` round-trip**: Add a direct serialization test to `resources.test.js` (currently only covered transitively through `colony.test.js` and `serialization.test.js`).

5. **`building.test.js` — `advance` completion**: Test that `advance` returns `true` and resets `constructionRemaining`/`constructionDuration` to 0 when `constructionRemaining <= delta`. Current tests check `advance` returns `false` when not constructing and decrements, but the completion path is tested via `state.test.js` rather than the unit test.

6. **`building.test.js` — `toJSON`**: Add a direct `toJSON` test (currently tested only in subclasses).

## Priority 3: Edge cases

7. **`market.test.js` — `executeTrade` with `TRADE_SELL` gold cap**: The sell path where gained gold would exceed `storageCap` is tested, but a test with the exact boundary (gold + sellPrice == cap) would strengthen confidence.

8. **`events.test.js` — `_binaryInsertFuture` ordering**: Test adding many future events out of order to verify binary insertion maintains sorted order.

9. **`season.test.js` — `advance` with delta exceeding multiple season durations**: Verify that even a very large delta only flips the season once (already partially tested but an extreme value like 10x duration would be a good edge case).
