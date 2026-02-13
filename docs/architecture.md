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

1. **Year & Season** — year label (`Josefin Sans`, small uppercase, muted) with numeric value (`Azeret Mono`), season emoji, and season progress bar
2. **Resources** — iterated via `HEADER_RESOURCES` constant (`v-for` loop). Each resource rendered as a `.resource-box` (bordered container from `styles.css`) with icon image + `current/max` value (unbounded resources like knowledge and faith show only `current`). Bounded resources (food, wood, stone, copper, iron, gold) have a 3px progress bar at the bottom showing capacity fill percentage — green when production is positive, red when zero or negative. Production rate is not shown inline; instead, hovering a resource box reveals a rich HTML tooltip (`.resource-tooltip`) displaying the resource name, colored per-minute rate (green/red), and a time estimate ("Full in MM:SS" or "Empty in MM:SS") when the rate is nonzero. `UNBOUNDED_RESOURCES` set in `constants.js` controls which resources skip the progress bar and "full in" estimate.
3. **Colony** — population, idle workers, territory each shown as icon image + value (flex: 1, centered)
4. **Menu button** — hamburger icon (inline SVG), opens pause modal

Resource/colony items use `<img>` icons from `public/img/` (no text labels). Values use `Azeret Mono` (numeric font). All values sourced from `GameState` (see below), which initializes from `src/js/engine/constants.js` (factories) using values from `src/js/engine/balancing.js`.

**Keyboard**: Escape key toggles the pause modal (ignored when an `INPUT` or `TEXTAREA` is focused).

### Building Grid (`game_screen.vue`)

Main content area displaying all 21 buildings in a 4-column layout. Each column represents a building category (Colony, Economy, Religion, Military) with a Josefin Sans uppercase header and vertically stacked building cards.

**Data source**: `BUILDING_GRID` constant from `constants.js` — array of column definitions, each with `headerKey` (i18n key) and `buildings` array of `{ key, img }` objects. The `img` is a relative path (e.g. `'misc/house.png'`) resolved at render time by prepending the `BUILDING_IMG_PATH` constant (`'/img/buildings/'`). The `key` indexes into both `state.colony.buildings[key]` for the level and `'building.' + key` for the localized name.

**Dynamic component resolution**: `game_screen.vue` maps all 21 building keys to dedicated card components via `CARD_COMPONENTS` (e.g. `headquarters → HeadquartersCard`). Uses Vue's `<component :is>` in the grid loop.

**Building unlock restrictions**: Buildings are locked/unlocked based on the headquarters type. The `HQ_BUILDING_UNLOCKS` constant in `constants.js` maps each HQ type to the building keys it unlocks (per-tier, non-cumulative). Headquarters is always unlocked. `game_screen.vue` checks each building via `isBuildingLocked()`, which iterates tiers up to the current HQ type index. Locked buildings render as a disabled placeholder card (same shell as `.building-card` but with `opacity: 0.4`) with a centered grayscale lock icon and a "Locked" tooltip, instead of the real card component.

**Column headers**: Josefin Sans uppercase labels (1rem, brighter accent at 0.75 opacity) centered above each column with a bottom border separator and extra bottom spacing.

### Building Cards (`src/components/buildings/`)

Per-building card components. Each receives `buildingKey`, `img`, and `building` (model instance) props.

**`base_card.vue`** — Shared card layout: flex row (top-aligned) with thumbnail image (5.5rem, `drop-shadow`) and a level badge overlay (bottom-right, semi-transparent black background, `Azeret Mono` 0.9rem) showing the numeric level, building name (`Jost`, 1.1rem). Cards use `--color-bg-surface` background with `--color-border` that intensifies on hover. Accepts optional `nameKey` prop to override the default localization key. Provides a default `<slot>` inside `.building-info` for custom content. A `?` help icon button sits in the top-right corner of each card (circular, muted accent border, brightens on hover). Hovering shows a "Help" tooltip; clicking opens `BuildingHelpModal` with the building's name and description. Accepts `showLevel` prop (default `true`); when false, the level badge is hidden (used by HQ card). Accepts `showBuildAction` prop (default `true`); when true, shows an action row: a build button (build icon, "Build {Name}" tooltip) at level 0, or a level-up button (upgrade icon, "Increase level" tooltip) at level > 0. Both the slot and the action row render when level > 0. Clicking the button deducts the cost from colony resources and increments the building level. Cost is computed via `building.levelUpCost()`.

**`headquarters_card.vue`** — Wraps `BaseCard` with `:show-level="false"` (level badge hidden), passes a computed `nameKey` of `building.headquarters.${type}` to display the HQ type name (Camp, Settlement, etc.) instead of the generic building name. Injects `colony` (provided by `game_screen.vue`) for reactive access to resources and stockpile. Displays two action buttons:
- **Expand Territory** — territory icon, "Expand territory" tooltip. Costs `hq.levelUpCost()` (food + wood). Increments building level. Disabled when resources insufficient.
- **Upgrade** — costs `Headquarters.upgradeCost(type)`. Advances HQ type (e.g. camp → settlement). Hidden at max type (City). Disabled when resources insufficient.

**`house_card.vue`** — Wraps `BaseCard`. When built (level > 0), displays a recruit worker action button. Injects `colony` for reactive access to resources, workers, and stockpile.
- **Recruit** — costs `WORKER_RECRUIT_COST` (50 food). Adds a worker and increments idle count. Disabled when food insufficient or worker stockpile cap reached.

Each action is a horizontal row: a square icon-only button (2.5rem × 2.5rem) with the action image (`worker.png`, `upgrade.png`, `territory.png`) + cost items displayed outside the button to its right. Buttons use the `.tooltip` class with localized `data-tooltip` for hover labels. Cost rendering iterates `Cost.entries()` (a `Map<string, number>` of non-zero resources).

**`worker_assignment_row.vue`** — Reusable component rendered by `base_card.vue` for `Producer` buildings (academy, shrine, temple, farm, woodcutter, quarry, copperMine, ironMine, goldMine) via `instanceof Producer` check. Displays a red minus button, worker icon with `current/max` count, and green plus button. Max workers = `level × WORKERS_PER_LEVEL` (5). Injects `colony` to transfer workers between `colony.idleWorkers` and `building.workers`. Minus disabled at 0 workers; plus disabled when no idle workers or at capacity.

**Adding a new building card**: Create `{building}_card.vue` wrapping `BaseCard`, add custom content via the slot, and register it in the `CARD_COMPONENTS` map in `game_screen.vue`.

### Game State (`src/js/engine/game_state.js`)

Central state container instantiated once per game session. Pure JS class wrapped in `reactive()` by `game_screen.vue` for Vue reactivity. Constructor receives a `Meta` instance (first) and a `Colony` instance (second). `Meta` tracks save version, creation/update timestamps, and challenge count. `Colony` expects pre-constructed sub-model instances (e.g. `Resources`) from the caller. Initialized via `createInitialMeta()` and `createInitialColony()` factories in `constants.js`.

**Provide/inject**: `game_screen.vue` calls `provide('colony', state.colony)` and `provide('gameState', state)`. Components `inject('colony')` for reactive reads and `inject('gameState')` to call mutation methods (`levelUpBuilding`, `levelUpHeadquarters`, `upgradeHeadquarters`, `assignWorker`, `unassignWorker`).

**Structure**: `state.meta.{ version, createdDateTime, updatedDateTime, numberOfChallenges }`, `state.colony.{ year, season, seasonElapsed, idleWorkers, resources, production, stockpile, buildings }`, and `state.events` (ephemeral event log, see Events section)

- `resources` (`Resources`) — current amounts with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`. Methods: `canAfford(cost)` (returns `true` if all cost fields are covered), `deduct(cost)` (subtracts cost fields in place).
- `production` (`Production`) — per-tick rates with public fields: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `stockpile` (`Stockpile`) — max capacity with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`. Faith and knowledge are unbounded (no stockpile cap).
- `buildings` (`Buildings`) — container with public fields keyed by camelCase building name. Each field holds a class instance extending `Building` (base class with `level`) or `Producer` (extends `Building`, adds `workers` defaulting to 0). Instance method `totalLevels()` returns the sum of all building levels excluding headquarters (used as current territory count). The 9 worker-assignable buildings (academy, shrine, temple, farm, woodcutter, quarry, copperMine, ironMine, goldMine) extend `Producer`; all others extend `Building` directly. `Headquarters` also has `type`, instance method `territoryCap()`, and static methods `upgradeCost(type)`, `nextType(type)`. All 21 building classes (including HQ) have a static `ID` property (the camelCase key, e.g. `'farm'`, `'copperMine'`) used throughout `constants.js` to avoid hardcoded strings. All 21 building classes have an instance method `levelUpCost()` that returns a `Cost` using base costs from `BUILDING_BASE_COSTS` and exponential multipliers from `BUILDING_LEVEL_UP_MULTIPLIERS` (HQ: `base × m^(level-1)`, others: `base × m^level`). Individual building classes live in `src/js/models/buildings/`.
- `Cost` (`src/js/models/cost.js`) — multi-resource cost holder with properties: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `knowledge`. Methods: `entries()` (returns a `Map<string, number>` of non-zero resources).

All initial values declared via `createInitialMeta()` (a `Meta` instance) and `createInitialColony()` (a `Colony` instance) in `src/js/engine/constants.js`, using numeric values from `src/js/engine/balancing.js`. `BUILDING_CLASS_MAP` maps all 21 building keys to their class constructors.

### Player Actions (`GameState` methods in `src/js/engine/game_state.js`)

All game state mutations are centralised in `GameState`. Each method guards preconditions, applies the mutation, and calls `this.update(0)` to recalculate derived values.

- `levelUpBuilding(buildingKey)` — deducts `levelUpCost`, increments `level` and `territory`. Blocked when territory is full.
- `levelUpHeadquarters()` — deducts `levelUpCost`, increments HQ `level` (no territory cost, since HQ increases max territory).
- `upgradeHeadquarters()` — deducts `upgradeCost`, advances HQ `type` to the next progression tier.
- `recruitWorker()` — deducts `WORKER_RECRUIT_COST`, increments `resources.workers` and `colony.idleWorkers`. Blocked when can't afford or at population cap.
- `assignWorker(buildingKey)` — moves one idle worker to the building. Blocked when no idle workers or building at max workers (`level × WORKERS_PER_LEVEL`).
- `unassignWorker(buildingKey)` — moves one worker from the building back to idle.
- `_killWorkers(count)` — removes workers from the colony (starvation). Kills idle workers first, then unassigns from buildings with the most workers. Decrements `resources.workers`.

### Events (`src/js/models/events/event.js`, `event_future.js`, `event_past.js`, `events.js`)

Ephemeral event system for notifying the player of upcoming threats and past occurrences. Events live on `GameState.events` (not `Colony`) and are **not persisted** in save data — they reset on page refresh.

**`Event`** — Abstract base class with common fields: `id` (auto-assigned), `textKey` (i18n key), `icon` (image path relative to `/img/`).

**`EventFuture`** — Extends `Event`. Adds `remainingSeconds` (countdown until event fires).

**`EventPast`** — Extends `Event`. No additional fields.

**`Events`** — Array-backed container with methods:
- `addFuture({ textKey, icon, remainingSeconds })` — creates an `EventFuture` with countdown
- `addPast({ textKey, icon })` — creates an `EventPast`
- `dismiss(id)` — removes event by id (uses `splice` for Vue reactivity)
- `future()` — returns `EventFuture` items sorted by `remainingSeconds` ascending
- `past()` — returns `EventPast` items sorted by `id` descending (most recent first)
- `tick(delta)` — decrements `remainingSeconds` on `EventFuture` items, clamps at 0 (does not auto-convert to past)

Called from `GameState.update()` at the end of each tick via `this.events.tick(delta)`.

**UI**: Displayed as a 5th column in `game_screen.vue` alongside the 4 building columns (all `flex: 1`, equal width). Two sub-sections: "Upcoming" (future events with gold countdown timer) and "History" (past events, faded). Each event row shows icon + text + countdown (future only) + dismiss button. Future events have a gold left-border accent; past events are muted at 0.45 opacity. Empty state shown when no events exist.

### Tick System (`GameState.update()` in `src/js/engine/game_state.js`)

Core game loop that generates resources over time. `game_screen.vue` runs a main `setInterval` (1 second, `TICK_INTERVAL`) that calls `state.update(deltaSec)` for production/consumption, and a `requestAnimationFrame` loop (~60 fps) that calls `state.advanceSeason(deltaSec)` to increment `colony.seasonElapsed` for smooth progress-bar animation. Both use `performance.now()` for delta calculation. Delta time naturally handles backgrounded tabs — when the tab returns, the first tick applies the full accumulated time.

**Territory & stockpile recalculation**: Each tick recalculates `resources.territory` via `buildings.totalLevels()` (sum of all building levels — each level occupies one territory slot), then recalculates all stockpile caps from building levels: `stockpile.workers` via `buildings.house.populationCap()` (`HOUSE_BASE_POPULATION + level × HOUSE_POPULATION_PER_LEVEL`), `stockpile.territory` via `buildings.headquarters.territoryCap()` (`level × HQ_TERRITORY_PER_LEVEL`), and all 6 resource caps (food, wood, stone, copper, iron, gold) via `buildings.storehouse.storageCap()` (`STOREHOUSE_BASE_CAPACITY + level × STOREHOUSE_CAPACITY_PER_LEVEL`). All balancing values in `src/js/engine/balancing.js`. Building level-ups (except HQ) are blocked when `resources.territory >= stockpile.territory`; HQ is exempt since it is the only building that increases max territory.

**Production formula**: For each building in `PRODUCTION_RATES` (balancing.js), production rate = `workers × baseRate`. Passive buildings (e.g. altar, flagged `passive: true`) use `level × rate` instead. After base rates are computed, food production is modified by season: warm applies `×(1 + SEASON_WARM_FOOD_MODIFIER)` (+20%) and cold applies `×(1 + SEASON_COLD_FOOD_MODIFIER)` (−20%). Rates are stored on `colony.production` (per-second) for UI display, then scaled by `deltaSec` when applied to `colony.resources`. Resources (except faith and knowledge, which are unbounded) are capped at `colony.stockpile` limits after application.

**Worker consumption**: After production gains, every worker (idle and assigned) consumes `WORKER_FOOD_CONSUMPTION` food/sec and `WORKER_WOOD_CONSUMPTION` wood/sec (scaled by delta). If resources are insufficient, food and wood shortages are evaluated independently: `deaths = totalWorkers − floor(available / costPerWorker)`. The higher death count is applied (not the sum). Surviving workers' consumption is deducted normally. Deaths remove idle workers first, then from buildings with the most assigned workers (via `_killWorkers`). Skipped when `delta === 0` or no workers exist.

**Base rates** (per worker per second): farm→food 0.5, woodcutter→wood 0.3, quarry→stone 0.2, copperMine→copper 0.15, ironMine→iron 0.1, goldMine→gold 0.05, academy→knowledge 0.1, shrine→faith 0.15. Altar→faith 0.1/level/sec (passive). All values defined in `src/js/engine/balancing.js`.

**Tooltips** — Colony items (population, idle workers, territory) use CSS-only tooltips (`.tooltip` class + `data-tooltip` attribute). Resource items use HTML-based rich tooltips (`.resource-tooltip` inside `.resource-box`) that display the resource name, colored production rate, and time estimate on hover. Both tooltip styles are defined in `src/assets/styles.css`.

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
  - `.production-rate` — per-minute rate indicator (0.8rem numeric font). `.production-rate--positive` (green `#50a850`), `.production-rate--negative` / `.production-rate--zero` (red `#c45050`).
  - `.resource-box` — bordered container for header resource items (subtle bronze gradient, `position: relative`). `.resource-bar` (3px progress track at bottom), `.resource-bar-fill--positive` (green), `.resource-bar-fill--negative` (red). `.resource-tooltip` (HTML-based rich tooltip with flex-column layout), `.resource-tooltip-rate` (monospace rate), `.resource-tooltip-time` (subdued time estimate).

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
- Numeric balancing values in `src/js/engine/balancing.js`, structural constants in `src/js/engine/constants.js`
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
