# CLAUDE.md

## What

A hybrid incremental strategy game. After a shipwreck on an unknown island, the player discovers an ancient portal guarded by Gods. To activate the portal and escape, the player must prove their faith by completing divine challenges — while building a colony, managing resources (Food, Wood, Stone, Copper, Iron, Gold), raising military, defending against native raids, and surviving natural disasters.

**Stack**: Vite + Vue 3 (JavaScript, Composition API with `<script setup>`), ESLint + @stylistic

**Structure**:

```
src/
├── assets/
│   └── styles.css            → Global styles (variables, shared classes)
├── components/
│   ├── buildings/
│   │   ├── base_card.vue     → Shared building card (thumbnail, name, level, slot)
│   │   ├── headquarters_card.vue → Headquarters card (type-based name)
│   │   └── *_card.vue        → 20 building cards (wrap base_card)
│   ├── modals/
│   │   └── pause_modal.vue   → Pause menu modal
│   └── screens/
│       ├── home_screen.vue   → Title screen with start button
│       └── game_screen.vue   → Main game screen
├── js/
│   ├── constants.js          → Centralized magic constants
│   ├── game_state.js         → GameState class (colony data model)
│   ├── i18n/
│   │   ├── en.js             → English locale strings
│   │   ├── es.js             → Spanish locale strings
│   │   └── localized.js      → Browser language detection + t() helper
│   ├── main.js               → Vue app entry point
│   └── models/
│       ├── buildings/
│       │   ├── building.js   → Base Building class (shared level field)
│       │   ├── buildings.js  → Buildings container (holds all building instances)
│       │   ├── headquarters.js → Headquarters (extends Building, adds type)
│       │   └── *.js          → 20 building classes (extend Building)
│       ├── colony.js         → Colony class (wraps all colony sub-models)
│       ├── cost.js           → Cost class (multi-resource cost holder)
│       ├── production.js     → Production class (per-tick rates)
│       ├── resources.js      → Resources class (current amounts)
│       └── stockpile.js      → Stockpile class (capacity caps)
└── app.vue                   → Root component (screen switching)
index.html                    → Vite entry HTML (at repo root)
vite.config.js                → Vite configuration
eslint.config.js              → ESLint configuration
```

## Reference Docs

Read these when working on specific areas:

- `docs/architecture.md` - Visual design (colors, typography, effects), class architecture with line references, game mechanics
- `docs/specs.md` - Game specifications (history, resources, buildings, seasons, game progression)

# Critical Instructions

## Planning

- **Context First**: Before proposing any change, read and understand the problem and all relevant files. If a file or path is referenced, you MUST open and inspect it. Do not speculate.
- **Ambiguity Handling**: If any requirement is infeasible, ambiguous, risky, or unclear, state your assumptions explicitly and ask for confirmation before proceeding. If ambiguity, risk, or rule violations remain, refuse to proceed and explain why.
- **Plan & Pause**: Propose a clear, step-by-step plan before making any code changes. Stop after planning and proceed only after I verify.

## Implementation

- **Strict Scope**: Stick to the requested task. Do not add features, refactor, optimize, rename, rewrite, or reorganize code beyond what was explicitly requested or strictly necessary for correctness. Do not design for hypothetical future requirements.
- **Analytical Rigor**: Thoroughly review the codebase for relevant facts, styles, conventions, and abstractions. Before implementation, clearly identify what will change and what will remain untouched.
- **Minimalist Approach**: Prioritize extreme simplicity. Impact only the code strictly necessary for the task to avoid complexity and prevent breaking existing functionality.
- **Maintainability Check**: Ensure the solution is readable, consistent, maintainable, simple, robust, and strictly follows the requested requirements.
- **Centralized Constants**: Declare all magic constants in `src/js/constants.js` and reference them from there. Do not hardcode values directly in other files.
- **Localization**: All user-facing text goes in every locale file under `src/js/i18n/`. Use the `t(key)` helper to reference strings. Keys use flat dot-notation with lowerCamelCase segments (e.g. `'resource.idleWorkers'`).
- **Shared Styles**: When a CSS rule or value is repeated across `.vue` files, extract it into `src/assets/styles.css` (as a CSS variable, shared class, or both). Component-specific overrides stay in scoped `<style>` blocks.
- **Root Cause Fixes**: If a bug exists, identify and fix the root cause. Do not apply temporary or partial fixes.
- **Async Patterns**: Prefer `async` and `await` over `Promise` and `then` calls.
- **UI/UX**: Always use the `frontend-design` skill when changing the UI.

## Verification

- **Mental Execution**: Before finalizing your response, simulate the code path mentally and identify edge cases, failure modes, and race conditions.
- **Lint**: After editing code, run `npm run lint -- --fix` and fix any remaining errors before considering the task complete.
- **Maintenance**: Always check if the files `CLAUDE.md` and `docs/architecture.md` are up-to-date after making changes. If not, update them accordingly.
