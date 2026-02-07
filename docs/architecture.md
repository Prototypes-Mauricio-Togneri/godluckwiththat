# Architecture & Design

Vite + Vue 3 single-page application using Composition API (`<script setup>`). No Vue Router — screens switch via `v-if` on a `currentScreen` ref in `app.vue`.

**Screen flow**: Home → Game (via `start` event)

**Modal pattern**: Parent controls visibility with `v-if`. Modal component emits `close` on backdrop click (`.self` modifier) or close button. Mounts/unmounts cleanly.

### Pause Modal (`pause_modal.vue`)

Centered overlay with "PAUSED" title, decorative rule, and two stacked buttons:
- **Continue** — emits `close`, resumes the game
- **Quit** — emits `quit`, bubbled through `game_screen.vue` to `app.vue` which switches back to the home screen

### Game Header (`game_screen.vue`)

Top bar divided into 4 sections separated by decorative vertical dividers:

1. **Season** — displays current season (warm/cold) with accent color
2. **Resources** — food, wood, stone shown as `current/max` (flex: 1, centered)
3. **Colony** — population (`current/max`), idle workers (count), territory (`current/max`) (flex: 1, centered)
4. **Menu button** — hamburger icon (inline SVG), opens game modal

Labels use `Cinzel` (display font, small uppercase, muted accent). Values use `Jost` (body font). All values sourced from `GameState` (see below), which initializes from `src/js/constants.js`.

### Game State (`src/js/game_state.js`)

Central state container instantiated once per game session. Pure JS class wrapped in `reactive()` by `game_screen.vue` for Vue reactivity. Constructor receives a `Colony` instance. The `Colony` expects pre-constructed sub-model instances (e.g. `Resources`) from the caller. Cloned from the `createInitialColony()` Colony instance in `constants.js`.

**Structure**: `state.colony.{ season, idleWorkers, resources, production, stockpile, buildings }`

- `resources` (`Resources`) — current amounts with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `production` (`Production`) — per-tick rates with public fields: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `stockpile` (`Stockpile`) — max capacity with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `buildings` (`Buildings`) — container with public fields keyed by camelCase building name. Each field holds a class instance extending `Building` (base class with `level`). `Headquarters` also has `type`. Individual building classes live in `src/js/models/buildings/`.

All initial values and stockpile caps declared as `createInitialColony()` (a `Colony` instance) in `src/js/constants.js`.

**Tooltips** — Each resource and colony item has a CSS-only tooltip (`.tooltip` class + `data-tooltip` attribute). The `::after` pseudo-element renders tooltip text on hover with a fade-in transition. Tooltip texts are constants in `src/js/constants.js`. Shared `.tooltip` class defined in `src/assets/styles.css`.

## Visual Design

**Theme**: Earthy & Ancient — warm browns, parchment tones, and aged bronze accents, evoking a torchlit ancient settlement. Inspired by Forge of Empires, Tribal Wars 2, Goodgame Empire.

**Colors**:
- Background: `#16120e` (deep umber, aged wood by torchlight)
- Raised surface: `#1e1a14` (dark walnut)
- Panel surface: `#272119` (stone panel)
- Text: `#e4d5bc` (warm parchment cream)
- Accent: `#b8943e` / `rgba(184, 148, 62, ...)` (aged bronze)
- Border: `rgba(184, 148, 62, 0.15)` (subtle warm border)
- Modal overlay: `rgba(0, 0, 0, 0.75)` with `backdrop-filter: blur(4px)`
- Muted UI: `rgba(228, 213, 188, 0.1–0.4)` (parchment-toned)

**Effects**:
- Title screen: staggered `fade-up` animations, warm torchlight glow behind title
- Modal: fade-in overlay + upward slide on content box, stone-like depth shadow
- Buttons: bronze gradient background, border intensifies on hover, subtle `box-shadow` glow

### Typography

- **Display/headings**: `Cinzel` (serif, Roman inscriptional) — weights 400, 700, 900
- **Body/UI**: `Jost` (geometric sans-serif) — weights 300, 400, 500
- Loaded via Google Fonts `<link>` in `index.html`

### Global Styles (`src/assets/styles.css`)

- **CSS variables** on `:root`: `--color-bg`, `--color-bg-raised`, `--color-bg-surface`, `--color-text`, `--color-text-rgb`, `--color-accent`, `--color-accent-rgb`, `--color-border`, `--font-display`, `--font-body`
- **Shared classes**: `.btn-gold` — bronze-gradient button base (font, color, gradient background, border, hover glow). Components add sizing/spacing overrides in scoped styles.

## Code Style

### JavaScript Conventions

- Do not use semicolons
- One class per file
- Naming
  - Files: `snake_case`
  - Classes: `PascalCase`
  - Functions: `camelCase` (no underscore prefixes)
  - Variables: full descriptive names, avoid abbreviations
    - Allowed: `i`, `j` (loop counters), `x`, `y` (coordinates), `dx`, `dy` (deltas), `ctx` (canvas context)
    - Avoid: `p` (player), `em` (enemyManager), `el` (element), `sw` (switch), `m` (mine), etc.
- All magic values in `src/js/constants.js`
- Unused parameters: use `_`, `__`, `___`, etc.

### JavaScript Comment Conventions

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

### CSS Comment Conventions

All CSS code uses a minimal, purpose-focused comment style:

**Section Dividers** - Major sections use decorated block comments:
```css
/* ============================================
   Section Name
   ============================================ */
```

**Rule Comments** - Single-line comment above the rule:
```css
/* Animated background */
.background-element::before {
```

**Pseudo-element Comments** - Brief description of visual effect:
```css
/* Scan line overlay effect */
.title-text::after {
```

**Conditional Logic Comments** - Explain non-obvious selectors:
```css
/* Hide background animation when game screen is active */
body:has(.game-screen.active) .background-animation {
```

**Guidelines:**
- Place comments above the rule they describe
- Use short, descriptive phrases (not full sentences)
- Focus on visual/functional purpose, not technical implementation
- Group related selectors together (base rule, pseudo-elements, states)
- Place keyframe animations near their corresponding animation properties
