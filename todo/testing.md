# Testing Plan

Expand coverage from 91% statements / 84% branches to ~97% statements / ~95% branches.
All new tests go into existing test files following the project's conventions (see `docs/testing.md`).

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
