# Test Plan

## Priority 3: Edge cases

7. **`market.test.js` — `executeTrade` with `TRADE_SELL` gold cap**: The sell path where gained gold would exceed `storageCap` is tested, but a test with the exact boundary (gold + sellPrice == cap) would strengthen confidence.

8. **`events.test.js` — `_binaryInsertFuture` ordering**: Test adding many future events out of order to verify binary insertion maintains sorted order.

9. **`season.test.js` — `advance` with delta exceeding multiple season durations**: Verify that even a very large delta only flips the season once (already partially tested but an extreme value like 10x duration would be a good edge case).
