# JavaScript Rules

- **Code Conventions**: All JavaScript naming, style, and comment conventions are in `docs/conventions.md`. Follow them for every code change.
- **Centralized Constants**: Numeric balancing values (costs, rates, formulas, initial state) go in `src/js/engine/balancing.js`. Structural constants (class maps, enums, sets, factory functions) go in `src/js/engine/constants.js`. Do not hardcode values in other files.
- **Asset Paths**: All image/sound paths from `public/` are in `src/js/engine/assets.js` (auto-generated). Run `npm run generate-assets` after adding/removing files in `public/`. Do not edit manually.
- **Imports**: Always use the `@` path alias (mapped to `src/`). No relative paths (`./`, `../`).
- **Getters**: Prefer getters over methods for parameterless functions that only read instance state and return a computed value (no side effects).
