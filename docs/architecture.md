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

### Confirm Modal (`confirm_modal.vue`)

Reusable confirmation dialog (same overlay pattern). Props: `titleKey` and `descriptionKey` (i18n keys). Layout: uppercase title, decorative rule, description paragraph, and a side-by-side button row — subdued "CANCEL" (gold) and red-styled "CONFIRM". Emits `confirm` or `close`. Used by `game_screen.vue` for the "Clear all" past events action.

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

**Data source**: `BUILDING_GRID` constant from `constants.js` — array of column definitions, each with `headerKey` (i18n key) and `buildings` array of `{ key, img }` objects. The `img` is a full path constant from `assets.js` (e.g. `IMG_BUILDING_HOUSE` → `'/img/buildings/misc/house.png'`). The `key` indexes into both `state.colony.buildings[key]` for the level and `'building.' + key` for the localized name.

**Dynamic component resolution**: `game_screen.vue` maps all 21 building keys to dedicated card components via `CARD_COMPONENTS` (e.g. `headquarters → HeadquartersCard`). Uses Vue's `<component :is>` in the grid loop.

**Building unlock restrictions**: Buildings are locked/unlocked based on the headquarters type. The `HQ_BUILDING_UNLOCKS` constant in `constants.js` maps each HQ type to the building keys it unlocks (per-tier, non-cumulative). Headquarters is always unlocked. `game_screen.vue` checks each building via `isBuildingLocked()`, which iterates tiers up to the current HQ type index. Locked buildings render as a disabled placeholder card (same shell as `.building-card` but with `opacity: 0.4`) with a centered grayscale lock icon and a "Locked" tooltip, instead of the real card component.

**Column headers**: Josefin Sans uppercase labels (1rem, brighter accent at 0.75 opacity) centered above each column with a bottom border separator and extra bottom spacing.

### Building Cards (`src/components/buildings/`)

Per-building card components. Each receives `buildingKey`, `img`, and `building` (model instance) props.

**`base_card.vue`** — Shared card layout: flex row (top-aligned) with thumbnail image (4.5rem, `drop-shadow`) and a level badge overlay (bottom-right, semi-transparent black background, `Azeret Mono` 0.8rem) showing the numeric level, building name (`Jost`, 1.1rem). Cards use `--color-bg-surface` background with `--color-border` that intensifies on hover. Accepts optional `nameKey` prop to override the default localization key. Provides a default `<slot>` inside `.building-info` for custom content. A `?` help icon button sits in the top-right corner of each card (circular, muted accent border, brightens on hover). Hovering shows a "Help" tooltip; clicking opens `BuildingHelpModal` with the building's name and description. Accepts `showLevel` prop (default `true`); when false, the level badge is hidden (used by HQ card). Accepts `showBuildAction` prop (default `true`); when true, shows an action row: a build button (build icon, "Build {Name}" tooltip) at level 0, or a level-up button (upgrade icon, "Increase level" tooltip) at level > 0. Both the slot and the action row render when level > 0. Clicking the button deducts the cost from colony resources and starts a construction timer. Cost is computed via `building.levelUpCost()`. During construction (`building.constructionRemaining > 0`), the button itself becomes the progress indicator: a semi-transparent gold `::before` overlay fills left-to-right (driven by `--progress` CSS variable), the icon is replaced by a MM:SS countdown, and the cost items hide. The card border subtly glows with the accent color while constructing. The level increments only when the timer reaches zero.

**`headquarters_card.vue`** — Wraps `BaseCard` with `:show-level="false"` (level badge hidden), passes a computed `nameKey` of `building.headquarters.${type}` to display the HQ type name (Camp, Settlement, etc.) instead of the generic building name. Injects `colony` (provided by `game_screen.vue`) for reactive access to resources and stockpile. Displays two action buttons:
- **Expand Territory** — territory icon, "Expand territory" tooltip. Costs `hq.levelUpCost()` (food + wood). Starts a construction timer; level increments on completion. Disabled when resources insufficient or HQ is busy (either timer active).
- **Upgrade** — costs `Headquarters.upgradeCost(type)`. Starts a construction timer; advances HQ type on completion. Hidden at max type (City). Disabled when resources insufficient or HQ is busy. Both action buttons become progress indicators (gold fill overlay + countdown) while their timer is active. The two timers are mutually exclusive.

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
- `buildings` (`Buildings`) — container with public fields keyed by camelCase building name. Each field holds a class instance extending `Building` (base class with `level`, `constructionRemaining`, `constructionDuration`) or `Producer` (extends `Building`, adds `workers` defaulting to 0). `constructionRemaining > 0` means the building is under construction; `constructionDuration` stores the total build time for progress calculation. Instance method `totalLevels()` returns the sum of all building levels excluding headquarters (used as current territory count). Instance method `pendingTerritory()` returns the count of non-HQ buildings currently under construction (used to reserve territory). The 9 worker-assignable buildings (academy, shrine, temple, farm, woodcutter, quarry, copperMine, ironMine, goldMine) extend `Producer`; all others extend `Building` directly. `Headquarters` also has `type`, `upgradeRemaining`, `upgradeDuration` (for type upgrade timer), instance method `territoryCap()`, and static methods `upgradeCost(type)`, `nextType(type)`. All 21 building classes (including HQ) have a static `ID` property (the camelCase key, e.g. `'farm'`, `'copperMine'`) used throughout `constants.js` to avoid hardcoded strings. All 21 building classes have an instance method `levelUpCost()` that returns a `Cost` using `cost` and `costMultiplier` from `BUILDING_UPGRADES` (HQ: `cost × m^(level-1)`, others: `cost × m^level`). Individual building classes live in `src/js/models/buildings/`.
- `Cost` (`src/js/models/cost.js`) — multi-resource cost holder with properties: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `knowledge`. Methods: `entries()` (returns a `Map<string, number>` of non-zero resources), `toSeconds()` (derives build time in seconds from resource weights defined in `RESOURCE_TIME_WEIGHTS`).

All initial values declared via `createInitialMeta()` (a `Meta` instance) and `createInitialColony()` (a `Colony` instance) in `src/js/engine/constants.js`, using numeric values from `src/js/engine/balancing.js`. `BUILDING_CLASS_MAP` maps all 21 building keys to their class constructors.

### Player Actions (`GameState` methods in `src/js/engine/game_state.js`)

All game state mutations are centralised in `GameState`. Each method guards preconditions, applies the mutation, and calls `this.update(0)` to recalculate derived values.

- `levelUpBuilding(buildingKey)` — deducts `levelUpCost`, starts a construction timer (`constructionRemaining`). Territory is reserved immediately via `pendingTerritory()`. Level increments when the timer reaches zero. Blocked when territory is full or already constructing.
- `levelUpHeadquarters()` — deducts `levelUpCost`, starts a construction timer. Level increments on completion. Blocked when HQ is busy (either timer active).
- `upgradeHeadquarters()` — deducts `upgradeCost`, starts a type upgrade timer (`upgradeRemaining`). HQ type advances on completion. Blocked when HQ is busy.
- `recruitWorker()` — deducts `WORKER_RECRUIT_COST`, increments `resources.workers` and `colony.idleWorkers`. Blocked when can't afford or at population cap.
- `assignWorker(buildingKey)` — moves one idle worker to the building. Blocked when no idle workers or building at max workers (`level × WORKERS_PER_LEVEL`).
- `unassignWorker(buildingKey)` — moves one worker from the building back to idle.
- `_killWorkers(count)` — removes workers from the colony (starvation). Kills idle workers first, then unassigns from buildings with the most workers. Decrements `resources.workers`.

### Events (`src/js/models/events/event.js`, `event_future.js`, `event_past.js`, `events.js`)

Ephemeral event system for notifying the player of upcoming threats and past occurrences. Events live on `GameState.events` (not `Colony`) and are **not persisted** in save data — they reset on page refresh.

**`Event`** — Abstract base class with common fields: `id` (auto-assigned), `type` (event type constant, e.g. `EVENT_TYPE_SEASON_CHANGED`, `EVENT_TYPE_BUILDING_UPGRADE`), `textKey` (i18n key), `icon` (full image path from `assets.js`, e.g. `IMG_RESOURCE_FOOD`), `params` (string array for positional i18n interpolation, default `[]`), `buildingKey` (building key for construction event lookup, default `null`).

**`EventFuture`** — Extends `Event`. Adds `remainingSeconds` (countdown until event fires).

**`EventPast`** — Extends `Event`. No additional fields.

**`Events`** — Array-backed container with methods:
- `addFuture({ type, textKey, icon, params, buildingKey, remainingSeconds })` — creates an `EventFuture` with countdown
- `addPast({ type, textKey, icon, params, buildingKey })` — creates an `EventPast`
- `convertToPast(buildingKey, data)` — finds the future event matching `buildingKey`, removes it, and adds a past event with the given data
- `dismiss(id)` — removes event by id (uses `splice` for Vue reactivity)
- `future()` — returns `EventFuture` items sorted by `remainingSeconds` ascending
- `past()` — returns `EventPast` items sorted by `id` descending (most recent first)
- `tick(delta)` — decrements `remainingSeconds` on `EventFuture` items, clamps at 0 (does not auto-convert to past)

Called from the `progressTick` loop (`requestAnimationFrame`, ~60 fps) in `game_screen.vue` via `state.events.tick(delta)`, alongside `advanceSeason` and `advanceConstruction`. The `gameTick` fallback also calls it to cover backgrounded tabs where `requestAnimationFrame` pauses.

**UI**: Displayed as a 5th column in `game_screen.vue` alongside the 4 building columns (all `flex: 1`, equal width). Two sub-sections: "Upcoming" (future events with gold countdown timer) and "History" (past events). Both use the same row style: icon + text + dismiss button, with a gold left-border accent. Future events additionally show a countdown timer. Empty state shown when no events exist.

### Tick System (`GameState.update()` in `src/js/engine/game_state.js`)

Core game loop that generates resources over time. `game_screen.vue` runs a main `setInterval` (1 second, `TICK_INTERVAL`) that calls `state.update(deltaSec)` for production/consumption, and a `requestAnimationFrame` loop (~60 fps, `progressTick`) that calls `state.advanceSeason(deltaSec)`, `state.advanceConstruction(deltaSec)`, and `state.events.tick(deltaSec)` for smooth visual progress. Both use `performance.now()` for delta calculation. Delta time naturally handles backgrounded tabs — when the tab returns, the first tick applies the full accumulated time.

**Construction timers**: `advanceConstruction(delta)` runs inside the `requestAnimationFrame` loop (`progressTick`) for smooth visual progress (~60 fps). It decrements `constructionRemaining` on all buildings; when a timer reaches zero, the building's level increments, `constructionDuration` resets, and the corresponding future event is converted to a past event via `events.convertToPast()`. The HQ type upgrade timer (`upgradeRemaining`) is ticked separately; on completion, `hq.type` advances to the next tier (no event fired for type upgrades). The next `update()` call (1-second interval) picks up the new level for stockpile/production recalculation.

**Territory & stockpile recalculation**: Each tick recalculates `resources.territory` via `buildings.totalLevels() + buildings.pendingTerritory()` (sum of all building levels plus buildings under construction — each counts as one territory slot), then recalculates all stockpile caps from building levels: `stockpile.workers` via `buildings.house.populationCap()` (`HOUSE_BASE_POPULATION + level × HOUSE_POPULATION_PER_LEVEL`), `stockpile.territory` via `buildings.headquarters.territoryCap()` (`level × HQ_TERRITORY_PER_LEVEL`), and all 6 resource caps (food, wood, stone, copper, iron, gold) via `buildings.storehouse.storageCap()` (`STOREHOUSE_BASE_CAPACITY + level × STOREHOUSE_CAPACITY_PER_LEVEL`). All balancing values in `src/js/engine/balancing.js`. Building level-ups (except HQ) are blocked when `resources.territory >= stockpile.territory`; HQ is exempt since it is the only building that increases max territory.

**Production formula**: For each building in `PRODUCTION_RATES` (balancing.js), production rate = `workers × baseRate`. Passive buildings (e.g. altar, flagged `passive: true`) use `level × rate` instead. After base rates are computed, food production is modified by season: warm applies `×(1 + SEASON_WARM_FOOD_MODIFIER)` (+20%) and cold applies `×(1 + SEASON_COLD_FOOD_MODIFIER)` (−20%). Rates are stored on `colony.production` (per-second) for UI display, then scaled by `deltaSec` when applied to `colony.resources`. Resources (except faith and knowledge, which are unbounded) are capped at `colony.stockpile` limits after application.

**Worker consumption**: After production gains, every worker (idle and assigned) consumes `WORKER_FOOD_CONSUMPTION` food/sec and `WORKER_WOOD_CONSUMPTION` wood/sec (scaled by delta). If resources are insufficient, food and wood shortages are evaluated independently: `deaths = totalWorkers − floor(available / costPerWorker)`. The higher death count is applied (not the sum), then capped at `MAX_WORKER_DEATHS_PER_TICK` to prevent mass die-offs. Surviving workers' consumption is deducted normally (clamped to 0). Deaths remove idle workers first, then from buildings with the most assigned workers (via `_killWorkers`). Skipped when `delta === 0` or no workers exist.

**Negative production detection**: After net production is finalized (including worker upkeep subtraction), a `_resourcesNegativeProduction` Set tracks which bounded resources currently have negative net production. When a resource transitions from non-negative to negative, a past event fires (using `RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG` from `constants.js`). When it recovers to non-negative, it is removed from the set so future drops can re-trigger. This follows the same edge-detection pattern as `_resourcesAtCap`.

**Base rates** (per worker per second): farm→food 0.5, woodcutter→wood 0.3, quarry→stone 0.2, copperMine→copper 0.15, ironMine→iron 0.1, goldMine→gold 0.05, academy→knowledge 0.1, shrine→faith 0.15. Altar→faith 0.1/level/sec (passive). All values defined in `src/js/engine/balancing.js`.

**Tooltips** — Colony items (population, idle workers, territory) use CSS-only tooltips (`.tooltip` class + `data-tooltip` attribute). Resource items use HTML-based rich tooltips (`.resource-tooltip` inside `.resource-box`) that display the resource name, colored production rate, and time estimate on hover. Both tooltip styles are defined in `src/assets/styles.css`.

### Localization (`src/js/i18n/`)

Each supported language has its own file (`en.js`, `es.js`) exporting a flat object with dot-notation keys (e.g. `'screen.home.play'`, `'resource.food'`, `'season.warm'`). At startup, `localized.js` reads `navigator.language`, resolves it to a supported locale (defaulting to English), and exports a `t(key, ...params)` helper that looks up strings from the resolved locale. When `params` are provided, positional placeholders (`{0}`, `{1}`, etc.) in the string are replaced with the corresponding values. Components import `t` from `localized.js` and use it in templates (`{{ t('key') }}`, `{{ t('key', param0) }}`) and bound attributes (`:alt="t('key')"`). No hardcoded display text in templates or JS.

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
  - `.tooltip` — CSS-only hover tooltip (positioned below element via `::after` pseudo-element reading `data-tooltip` attribute, instant fade-in). `.tooltip--delayed` modifier adds a 1s hover delay (used on building card tooltips).
  - `.action-row` — flex row for icon-button + cost display pairs. `.action-btn` (2rem square icon button), `.action-btn-icon` (1.25rem icon), `.action-cost` (cost container), `.action-cost-item` (icon + amount pair), `.action-cost-icon` (0.9rem resource icon), `.action-cost-amount` (0.75rem value text), `.action-cost-short` (red color `#c45050` when unaffordable).
  - `.action-btn--constructing` — modifier that turns the action button into a progress indicator. Uses `::before` pseudo-element with `--progress` CSS variable for gold fill overlay (`transition: width 1s linear`). `.action-btn-time` (0.65rem numeric countdown inside the button).
  - `.slot-actions` — flex row wrapper for action groups inside building card slots. Uses `margin-top: auto` to bottom-align with thumbnail, `justify-content: space-between` for side-by-side dual-button layout, `align-items: flex-end` for bottom alignment.
  - `.worker-row` — flex row for worker assignment controls. `.worker-btn` (2rem square ghost button), `.worker-btn--minus` (red `#c45050`), `.worker-btn--plus` (green `#50a850`), `.worker-count` (icon + text, 0.95rem), `.worker-count-icon` (1.4rem worker icon).
  - `.production-rate` — per-minute rate indicator (0.8rem numeric font). `.production-rate--positive` (green `#50a850`), `.production-rate--negative` / `.production-rate--zero` (red `#c45050`).
  - `.resource-box` — bordered container for header resource items (subtle bronze gradient, `position: relative`). `.resource-bar` (4px progress track at bottom), `.resource-bar-fill--positive` (green), `.resource-bar-fill--negative` (red). `.resource-tooltip` (HTML-based rich tooltip with flex-column layout), `.resource-tooltip-rate` (monospace rate), `.resource-tooltip-time` (subdued time estimate).

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
