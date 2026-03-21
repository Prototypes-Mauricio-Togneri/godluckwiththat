---
name: audit-tests
description: Sync docs/testing.md with actual test implementation, then report coverage, KPIs, and suggested new tests.
---

I want you to audit the test suite and synchronize its documentation. Follow this specific workflow:

1. **Discovery Phase**:
   - Scan all test files under `tests/` recursively. For each `.test.js` file, read it and catalog: file path, describe blocks, individual test names (`it`/`test`), what source file/class/function it covers.
   - Scan all source files under `src/js/` recursively. For each `.js` file, catalog: exported classes, functions, and getters/methods.
   - Read `tests/helpers/factories.js`, `tests/helpers/setup.js`, and `tests/helpers/building_keys.js` to document helper utilities.
   - Read the current `docs/testing.md`.

2. **Sync Phase** - Update `docs/testing.md` to match reality:
   - Add any test files that exist but are missing from the doc.
   - Remove any test files listed in the doc that no longer exist.
   - Update the "Covers" column for each test file to accurately reflect what the test actually tests (describe blocks, tested methods/getters).
   - Update the Factory Helpers section if new factories were added or existing ones changed.
   - Update the Mocking section if new mocks were added.
   - Update the "What Is Not Tested" section based on which source files have no corresponding test.
   - Update the Setup File section if it changed.
   - Preserve the existing document structure and style.

3. **Coverage Phase**:
   - Run `npm run test:coverage` and capture the output.
   - Parse the coverage summary (statements, branches, functions, lines percentages).

4. **Report Phase** - After syncing the doc, output a structured report with these sections:

   **Test Suite Summary**
   - Total test files, total `it`/`test` cases, total `describe` blocks.

   **Coverage KPIs** (from the coverage run)
   - Statement coverage %
   - Branch coverage %
   - Function coverage %
   - Line coverage %
   - List any source files with 0% coverage that are NOT in the exclusion list.

   **Functions Tested vs Untested**
   - For each source file under `src/js/` (excluding coverage-excluded files), list:
     - Number of exported functions/methods/getters tested
     - Number of exported functions/methods/getters NOT tested
     - Names of untested functions/methods/getters

   **Suggested New Tests** (prioritized)
   - Identify source functions, methods, and getters that have NO test coverage.
   - Identify branches with low coverage (from the coverage report).
   - Suggest specific test cases that would improve coverage, grouped by file, with a brief description of what each test should verify.
   - Prioritize: critical game logic (state.js, balancing.js) > model methods > utility functions > edge cases.

   **Test Quality Observations**
   - Flag any tests that only test the constructor but skip methods/getters.
   - Flag any serialization round-trips that are missing.
   - Flag any source files that have a test file but with very shallow coverage.

**Constraints**:
- Only modify `docs/testing.md`. Do NOT modify any test files or source files.
- Do NOT delete or reorganize existing tests.
- The report is output text only (not written to a file).
