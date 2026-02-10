# Architecture & Design

Vite + Vue 3 single-page application using Composition API (`<script setup>`). No Vue Router — screens switch via `v-if` on a `currentScreen` ref in `app.vue`.

**Screen flow**: Home → Game (via `start` event)

**Modal pattern**: Parent controls visibility with `v-if`. Modal component emits `close` on backdrop click (`.self` modifier) or close button. Mounts/unmounts cleanly.

### Pause Modal (`pause_modal.vue`)

Centered overlay with "PAUSED" title, decorative rule, and two stacked buttons:
- **Continue** — emits `close`, resumes the game
- **Quit** — emits `quit`, bubbled through `game_screen.vue` to `app.vue` which switches back to the home screen

### Building Help Modal (`building_help_modal.vue`)

Centered overlay (same pattern as pause modal) showing information about a building. Rendered inside `base_card.vue` via `v-if` on a local `showHelp` ref. Props: `nameKey` (i18n key for the title) and `buildingKey` (indexes into `buildingHelp.{key}` for the description). Layout: uppercase building name title, decorative rule, description paragraph, and a "CLOSE" button. Emits `close` on backdrop click or button press.

### Game Header (`game_screen.vue`)

Top bar divided into 4 sections separated by decorative vertical dividers:

1. **Season** — text label (`Josefin Sans`, small uppercase, muted accent) + value with accent color
2. **Resources** — food, wood, stone each shown as icon image + `current/max` value (flex: 1, centered)
3. **Colony** — population, idle workers, territory each shown as icon image + value (flex: 1, centered)
4. **Menu button** — hamburger icon (inline SVG), opens pause modal

Resource/colony items use `<img>` icons from `public/img/` (no text labels). Values use `Jost` (body font). All values sourced from `GameState` (see below), which initializes from `src/js/constants.js`.

**Keyboard**: Escape key toggles the pause modal (ignored when an `INPUT` or `TEXTAREA` is focused).

### Building Grid (`game_screen.vue`)

Main content area displaying all 21 buildings in a 4-column layout. Each column represents a building category (Colony, Economy, Religion, Military) with a Josefin Sans uppercase header and vertically stacked building cards.

**Data source**: `BUILDING_GRID` constant from `constants.js` — array of column definitions, each with `headerKey` (i18n key) and `buildings` array of `{ key, img }` objects. The `img` is a relative path (e.g. `'misc/house.png'`) resolved at render time by prepending the `BUILDING_IMG_PATH` constant (`'/img/buildings/'`). The `key` indexes into both `state.colony.buildings[key]` for the level and `'building.' + key` for the localized name.

**Dynamic component resolution**: `game_screen.vue` maps building keys to card components via `CARD_COMPONENTS` (e.g. `headquarters → HeadquartersCard`), falling back to `BaseCard` for all others. Uses Vue's `<component :is>` in the grid loop.

**Building unlock restrictions**: Buildings are locked/unlocked based on the headquarters type. The `HQ_BUILDING_UNLOCKS` constant in `constants.js` maps each HQ type to the building keys it unlocks (per-tier, non-cumulative). Headquarters is always unlocked. `game_screen.vue` checks each building via `isBuildingLocked()`, which iterates tiers up to the current HQ type index. Locked buildings render as a disabled placeholder card (same shell as `.building-card` but with `opacity: 0.4`) with a centered grayscale lock icon and a "Locked" tooltip, instead of the real card component.

**Column headers**: Josefin Sans uppercase labels (1rem, brighter accent at 0.75 opacity) centered above each column with a bottom border separator and extra bottom spacing.

### Building Cards (`src/components/buildings/`)

Per-building card components. Each receives `buildingKey`, `img`, and `building` (model instance) props.

**`base_card.vue`** — Shared card layout: flex row (top-aligned) with thumbnail image (5.5rem, `drop-shadow`) and a level badge overlay (bottom-right, semi-transparent black background, `Jost` 0.75rem) showing the numeric level, building name (`Jost`, 0.95rem). Cards use `--color-bg-surface` background with `--color-border` that intensifies on hover. Accepts optional `nameKey` prop to override the default localization key. Provides a default `<slot>` inside `.building-info` for custom content. A `?` help icon button sits in the top-right corner of each card (circular, muted accent border, brightens on hover). Hovering shows a "Help" tooltip; clicking opens `BuildingHelpModal` with the building's name and description. Accepts `showBuildAction` prop (default `true`); when true, shows an action row: a build button (build icon, "Build {Name}" tooltip) at level 0, or a level-up button (upgrade icon, "Increase level" tooltip) at level > 0. Both the slot and the action row render when level > 0. Clicking the button deducts the cost from colony resources and increments the building level. Cost is computed via `BUILDING_CLASS_MAP[key].levelUpCost(level)`.

**`headquarters_card.vue`** — Wraps `BaseCard`, passes a computed `nameKey` of `building.headquarters.${type}` to display the HQ type name (Camp, Settlement, etc.) instead of the generic building name. Injects `colony` (provided by `game_screen.vue`) for reactive access to resources and stockpile. Displays two action buttons:
- **Level Up** — costs `Headquarters.levelUpCost(level)`. Increments building level. Disabled when resources insufficient.
- **Upgrade** — costs `Headquarters.upgradeCost(type)`. Advances HQ type (e.g. camp → settlement). Hidden at max type (City). Disabled when resources insufficient.

**`house_card.vue`** — Wraps `BaseCard`. When built (level > 0), displays a recruit worker action button. Injects `colony` for reactive access to resources, workers, and stockpile.
- **Recruit** — costs `WORKER_RECRUIT_COST` (50 food). Adds a worker and increments idle count. Disabled when food insufficient or worker stockpile cap reached.

Each action is a horizontal row: a square icon-only button (2.5rem × 2.5rem) with the action image (`worker.png`, `upgrade.png`, `headquarters_upgrade.png`) + cost items displayed outside the button to its right. Buttons use the `.tooltip` class with localized `data-tooltip` for hover labels. Cost rendering iterates `Cost.entries()` (a `Map<string, number>` of non-zero resources).

**`worker_assignment_row.vue`** — Reusable component rendered by `base_card.vue` for buildings in `WORKER_ASSIGNABLE_BUILDINGS` (academy, shrine, temple, farm, woodcutter, quarry, copperMine, ironMine, goldMine). Displays a red minus button, worker icon with `current/max` count, and green plus button. Max workers = `level × WORKERS_PER_LEVEL` (5). Injects `colony` to transfer workers between `colony.idleWorkers` and `building.workers`. Minus disabled at 0 workers; plus disabled when no idle workers or at capacity.

**Adding a new building card**: Create `{building}_card.vue` wrapping `BaseCard`, add custom content via the slot, and register it in the `CARD_COMPONENTS` map in `game_screen.vue`.

### Game State (`src/js/game_state.js`)

Central state container instantiated once per game session. Pure JS class wrapped in `reactive()` by `game_screen.vue` for Vue reactivity. Constructor receives a `Meta` instance (first) and a `Colony` instance (second). `Meta` tracks save version, creation/update timestamps, and challenge count. `Colony` expects pre-constructed sub-model instances (e.g. `Resources`) from the caller. Initialized via `createInitialMeta()` and `createInitialColony()` factories in `constants.js`.

**Colony provide/inject**: `game_screen.vue` calls `provide('colony', state.colony)` so descendant components (e.g. `headquarters_card.vue`, `house_card.vue`) can `inject('colony')` for direct reactive access to colony data without prop drilling.

**Structure**: `state.meta.{ version, createdDateTime, updatedDateTime, numberOfChallenges }` and `state.colony.{ season, idleWorkers, resources, production, stockpile, buildings }`

- `resources` (`Resources`) — current amounts with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `production` (`Production`) — per-tick rates with public fields: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `stockpile` (`Stockpile`) — max capacity with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `buildings` (`Buildings`) — container with public fields keyed by camelCase building name. Each field holds a class instance extending `Building` (base class with `level` and `workers`, where `workers` defaults to 0). `Headquarters` also has `type`, static properties `baseCost` and `levelUpMultiplier`, and static methods `levelUpCost(level)`, `upgradeCost(type)`, `nextType(type)`. All 20 non-HQ building classes also have a static `baseCost` property (`{ wood, stone? }`) and a static `levelUpCost(level)` method that returns a `Cost` (base wood/stone scaled by `level + 1`). Individual building classes live in `src/js/models/buildings/`.
- `Cost` (`src/js/models/cost.js`) — multi-resource cost holder with properties: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `knowledge`. Methods: `canAfford(resources)`, `deductFrom(resources)`, `entries()` (returns a `Map<string, number>` of non-zero resources).

All initial values declared via `createInitialMeta()` (a `Meta` instance) and `createInitialColony()` (a `Colony` instance) in `src/js/constants.js`. `BUILDING_CLASS_MAP` maps all 21 building keys to their class constructors.

### Tick System (`GameState.update()` in `src/js/game_state.js`)

Core game loop that generates resources over time. `game_screen.vue` runs a `setInterval` (1 second) that calls `state.update(deltaSec)` with the elapsed time since the last tick (via `performance.now()`). Delta time naturally handles backgrounded tabs — when the tab returns, the first tick applies the full accumulated time.

**Stockpile recalculation**: Each tick recalculates `stockpile.workers` from the house level: `HOUSE_BASE_POPULATION + house.level × HOUSE_POPULATION_PER_LEVEL` (constants.js).

**Production formula**: For each building in `PRODUCTION_RATES` (constants.js), production rate = `workers × baseRate`. Altar is passive: `level × ALTAR_FAITH_RATE`. Rates are stored on `colony.production` (per-second) for UI display, then scaled by `deltaSec` when applied to `colony.resources`. Resources are capped at `colony.stockpile` limits after application.

**Base rates** (per worker per second): farm→food 0.5, woodcutter→wood 0.3, quarry→stone 0.2, copperMine→copper 0.15, ironMine→iron 0.1, goldMine→gold 0.05, academy→knowledge 0.1, shrine→faith 0.15. Altar→faith 0.1/level/sec (passive).

**Tooltips** — Each resource and colony item has a CSS-only tooltip (`.tooltip` class + `data-tooltip` attribute). The `::after` pseudo-element renders tooltip text on hover with a fade-in transition. Shared `.tooltip` class defined in `src/assets/styles.css`.

### Localization (`src/js/i18n/`)

Each supported language has its own file (`en.js`, `es.js`) exporting a flat object with dot-notation keys (e.g. `'screen.home.play'`, `'resource.food'`, `'season.warm'`). At startup, `localized.js` reads `navigator.language`, resolves it to a supported locale (defaulting to English), and exports a `t(key)` helper that looks up strings from the resolved locale. Components import `t` from `localized.js` and use it in templates (`{{ t('key') }}`) and bound attributes (`:alt="t('key')"`). No hardcoded display text in templates or JS.

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
- Title screen: warm torchlight glow behind title (radial gradient accent)
- Modal: fade-in overlay + upward slide on content box, stone-like depth shadow
- Buttons: bronze gradient background, border intensifies on hover, subtle `box-shadow` glow

### Typography

- **Display/headings**: `Josefin Sans` (geometric vintage sans-serif) — weights 400, 600, 700
- **Body/UI**: `Jost` (geometric sans-serif) — weights 300, 400, 500
- **Numeric**: `Azeret Mono` (geometric monospace) — weights 400, 500. Used for all numeric displays (resource counts, building levels, costs, worker counts).
- Loaded via Google Fonts `<link>` in `index.html`

### Global Styles (`src/assets/styles.css`)

- **CSS variables** on `:root`: `--color-bg`, `--color-bg-raised`, `--color-bg-surface`, `--color-text`, `--color-text-rgb`, `--color-accent`, `--color-accent-rgb`, `--color-border`, `--font-display`, `--font-body`, `--font-numeric`
- **Shared classes**:
  - `.btn-gold` — bronze-gradient button base (font, color, gradient background, border, hover glow). Includes `:disabled` state (reduced opacity, `cursor: not-allowed`, hover neutralized). Components add sizing/spacing overrides in scoped styles.
  - `.tooltip` — CSS-only hover tooltip (positioned below element via `::after` pseudo-element reading `data-tooltip` attribute, fade-in transition).
  - `.action-row` — flex row for icon-button + cost display pairs. `.action-btn` (2.5rem square icon button), `.action-btn-icon` (1.6rem icon), `.action-cost` (cost container), `.action-cost-item` (icon + amount pair), `.action-cost-icon` (0.9rem resource icon), `.action-cost-amount` (0.75rem value text), `.action-cost-short` (red color `#c45050` when unaffordable).
  - `.slot-actions` — flex row wrapper for action groups inside building card slots. Uses `margin-top: auto` to bottom-align with thumbnail, `justify-content: space-between` for side-by-side dual-button layout, `align-items: flex-end` for bottom alignment.
  - `.worker-row` — flex row for worker assignment controls. `.worker-btn` (2.5rem square ghost button), `.worker-btn--minus` (red `#c45050`), `.worker-btn--plus` (green `#50a850`), `.worker-count` (icon + text, 0.95rem), `.worker-count-icon` (1.4rem worker icon).

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
