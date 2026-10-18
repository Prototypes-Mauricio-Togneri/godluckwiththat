# JavaScript Rules

## Style

- Do not use semicolons
- One class per file
- Unused parameters: use `_`, `__`, `___`, etc.

## Naming

- Files: `snake_case`
- Classes: `PascalCase`
- Functions: `camelCase`
- Variables: full descriptive names, avoid abbreviations
  - Allowed: `i`, `j` (loop counters), `x`, `y` (coordinates), `dx`, `dy` (deltas), `ctx` (canvas context)
  - Avoid: `p` (player), `em` (enemyManager), `el` (element), `sw` (switch), `m` (mine), etc.

## Centralized Constants

Numeric balancing values (costs, rates, formulas, initial state) go in `src/js/engine/balancing.js`. Structural constants (class maps, enums, sets, factory functions) go in `src/js/engine/constants.js`. Pure string enums in `src/js/engine/enums.js` (import them from there directly; `constants.js` does not re-export them). Do not hardcode values in other files.

## Asset Paths

All image/sound paths from `public/` are in `src/js/engine/assets.js` (auto-generated). Run `npm run generate-assets` after adding/removing files in `public/`. Do not edit manually.

## Imports

Always use the `@` path alias (mapped to `src/`). No relative paths (`./`, `../`).

## Getters

Prefer getters over methods for parameterless functions that only read instance state and return a computed value (no side effects).

## Comment Conventions

All JavaScript code uses a mixed comment style:

**Class Level** - JSDoc block describing purpose:
```javascript
/**
 * Brief description of class purpose.
 * Additional context about role in the game architecture.
 */
class ClassName {
```

**Function Level** - JSDoc with parameters and return type:
```javascript
/**
 * Brief description of what the method does.
 * @param {Type} paramName - Description
 * @returns {Type} Description
 */
methodName(paramName) {
```

**Field Level** - Inline end-of-line comment on first declaration:
```javascript
this.x = 0                // Current X position
this.speed = config.speed // Movement speed in pixels/second
```

**Code Block Level** - Plain comments for complex logic:
```javascript
// Calculate interpolated position toward target
const dir = Vector2.direction(current, target)
```
