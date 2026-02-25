# CLAUDE.md

## Project

A hybrid incremental strategy game (Vite + Vue 3, JavaScript, Composition API with `<script setup>`, ESLint + @stylistic).

## Reference Docs

Read `docs/architecture.md` (visual design, class architecture, game mechanics) and `docs/specs.md` (game specs, buildings, seasons, progression) when working on related areas.

## Planning

- **Plan & Pause**: Propose a clear, step-by-step plan before making any code changes. Stop after planning and proceed only after I verify.
- **Ambiguity Handling**: If any requirement is ambiguous, risky, or unclear, state your assumptions explicitly and ask for confirmation before proceeding.

## Rules

- **Centralized Constants**: Numeric balancing values (costs, rates, formulas, initial state) go in `src/js/engine/balancing.js`. Structural constants (class maps, enums, sets, factory functions) go in `src/js/engine/constants.js`. Do not hardcode values in other files.
- **Asset Paths**: All image/sound paths from `public/` are in `src/js/engine/assets.js` (auto-generated). Run `npm run generate-assets` after adding/removing files in `public/`. Do not edit manually.
- **Localization**: All user-facing text goes in every locale file under `src/js/i18n/`. Use `t(key)` to reference strings. Keys use flat dot-notation with lowerCamelCase segments (e.g. `'resource.idleWorkers'`).
- **Imports**: Always use the `@` path alias (mapped to `src/`). No relative paths (`./`, `../`).
- **Shared Styles**: Repeated CSS across `.vue` files gets extracted into `src/assets/styles.css`. Component-specific overrides stay in scoped `<style>` blocks.
- **Color Format**: Always use `rgba()`. No hex. Opaque colors use alpha `1` (e.g. `rgba(196, 80, 80, 1)`).
- **Strict Scope**: Do not add features, refactor, or reorganize beyond what was explicitly requested.
- **UI/UX**: Always use the `frontend-design` skill when changing the UI.
- **Lint**: After editing code, run `npm run lint -- --fix` and fix remaining errors.
- **Code Review**: After completing code changes, run /delta-review before responding.
- **Doc Maintenance**: After changes, check if `CLAUDE.md`, `docs/architecture.md`, and `docs/specs.md` need updating.
