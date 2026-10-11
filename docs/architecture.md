# Architecture & Design

Vite + Vue 3 single-page application using Composition API (`<script setup>`). No Vue Router — screens switch via `v-if` on a `currentScreen` ref in `app.vue`.

**Screen flow**: Home → Game (via `start` event with optional saved data payload)

**Modal pattern**: Parent controls visibility with `v-if`. Modal component emits `close` on backdrop click (`.self` modifier) or close button. Mounts/unmounts cleanly.

### Pause Modal (`pause_modal.vue`)

Centered overlay with "PAUSED" title, decorative rule, and six stacked buttons:
- **Resume** — emits `close`, resumes the game
- **Save** — emits `save`, triggers `saveGame()` in `game_screen.vue` which writes `state.toJSON()` to `storage.savedGame` and closes the modal
- **Load** — emits `load`, loads the saved game (disabled when no saved game exists)
- **Settings** — emits `settings`, opens `SettingsModal`
- *(decorative rule separator)*
- **Restart** — emits `restart`, opens a confirm modal (does not restart directly); danger-styled
- **Quit** — emits `quit`, opens a confirm modal (does not quit directly); danger-styled

### Settings Modal (`settings_modal.vue`)

Centered overlay (same pattern as other modals) opened from the pause modal. Contains toggle switches and autosave configuration:
- **Music toggle** — on/off switch, persisted via `storage.musicEnabled`
- **Sound Effects toggle** — on/off switch, persisted via `storage.soundEnabled`
- *(decorative rule separator)*
- **Autosave toggle** — on/off switch, persisted via `storage.autosaveEnabled`
- **Autosave interval** — +/− buttons to adjust interval in minutes (clamped to `AUTOSAVE_MIN_INTERVAL`–`AUTOSAVE_MAX_INTERVAL`), persisted via `storage.autosaveInterval`
- Emits `close` on backdrop click, close button, or Escape key

### Building Help Modal (`building_help_modal.vue`)

Centered overlay (same pattern as pause modal) showing information about a building. Rendered inside `base_card.vue` via `v-if` on a local `showHelp` ref. Props: `nameKey` (i18n key for the title), `buildingKey` (indexes into `buildingHelp.{key}` for the description), and `img` (building thumbnail path). Layout: uppercase building name title, decorative rule, horizontal body with large thumbnail image (9rem) alongside description paragraph, and a "CLOSE" button. Emits `close` on backdrop click, button press, or Escape key.

### Modal Help Modal (`help_modal.vue`)

Generic help modal for overlay-on-overlay display (z-index 110, above the parent modal's z-index 100). Takes `title` and `body` props (pre-translated strings). Layout: uppercase title, decorative rule, description paragraph, and a "CLOSE" button. Follows the same animation pattern as other modals (rAF-driven `visible` class). Escape key handler in capture phase with `stopImmediatePropagation` to close itself without affecting the parent modal. Used by `research_modal.vue` and `market_modal.vue` via their "?" help buttons. Parent modals also guard their own Escape handler to close the help modal first when open.

### Confirm Modal (`confirm_modal.vue`)

Reusable confirmation modal (same overlay pattern). Props: `titleKey` and `descriptionKey` (i18n keys), optional `confirmKey` (i18n key for confirm button text, default `'modal.confirm'`). Layout: uppercase title, decorative rule, description paragraph, and a side-by-side button row — subdued "CANCEL" (gold) and red-styled "CONFIRM". Emits `confirm` or `close`. Used by `game_screen.vue` for quit confirmation, restart confirmation, and the "Clear all" past events action.

### Market Modal (`market_modal.vue`)

Centered overlay (same pattern as other modals) opened from the market building card. Injects `ui` and `actions`. A "?" help button (`.modal-help-btn`) sits left of the close button and opens `ModalHelpModal` with market help text. Displays a "Market" title, a resource summary bar showing current amounts for all tradeable resources and gold (gold separated by a subtle left border), current trade fee percentage, and a scrollable list of trade rows (one per tradeable resource: Food, Wood, Stone, Copper, Iron). Each row shows the resource icon and name, current gold price per 100 units, a sell button (+gold gain in green), and a buy button (-gold cost). Buy/sell buttons use `.btn-gold`; disabled when unaffordable or storage cap would overflow. Insufficient amounts shown in red (`rgba(196, 80, 80, 1)`). Calls `state.executeTrade(resource, direction)` on click. Emits `close` on backdrop click, close button, or Escape key. Visibility controlled by `showMarketModal` ref in `game_screen.vue`; opened via `inject('openMarketModal')` in `market_card.vue`.

### Challenge Detail Modal (`challenge_detail_modal.vue`)

Centered overlay opened when the player clicks a challenge future event. Injects `ui`. Displays the active challenge info: challenge number, requirements checklist (each requirement shown with a check/cross icon indicating whether it is currently met), and a countdown timer when the challenge is started. Emits `close` on backdrop click, close button, or Escape key. Visibility controlled by `showChallengeModal` ref in `game_screen.vue`; opened via the `action` field on challenge events.

### Challenge Success Modal (`challenge_success_modal.vue`)

Blocking overlay (no close button, no Escape, no backdrop dismiss) shown when a challenge is completed successfully. Injects `ui` and `actions`. Displays two blessing choices side-by-side, each with an image, description, and effect details. The player must select one blessing. On selection, calls `actions.selectBlessing(index)`. Game is paused while this modal is visible. Controlled by `ui.challengeModal === CHALLENGE_MODAL_REWARD`.

### Challenge Failure Modal (`challenge_failure_modal.vue`)

Blocking overlay (no Escape, no backdrop dismiss) shown when a challenge fails. Injects `ui` and `actions`. Displays the punishment type with image and lists all penalty effects (faith loss, resource loss, worker loss, building level loss, productivity penalties). Has a single "Accept Punishment" button that calls `actions.acknowledgePunishment()`. Game is paused while visible. Controlled by `ui.challengeModal === CHALLENGE_MODAL_FAILURE`.

### Challenge Win Modal (`challenge_win_modal.vue`)

Blocking overlay shown when all 10 challenges are completed. Displays a victory message announcing the portal is activated. Offers "Continue" (resume playing) and "Quit" (return to home screen) buttons. Emits `continue` or `quit`. Controlled by `ui.challengeModal === CHALLENGE_MODAL_WIN`.

### Game Header (`game_screen.vue`)

Top bar divided into 4 sections separated by decorative vertical dividers:

1. **Year & Season** — year label (`Josefin Sans`, small uppercase, muted) with numeric value (`Azeret Mono`), season emoji, and season progress bar
2. **Resources** — preceded by a **productivity card** (`.productivity-box`, always visible) showing the current productivity ratio as a percentage with a fill bar (green at 100%, red when penalized; `.productivity-box--penalized` adds red-tinted border/background). Followed by resource boxes iterated via `HEADER_RESOURCES` constant (`v-for` loop). Only resources unlocked by the current HQ type are shown (controlled by `HQ_RESOURCE_UNLOCKS` in `constants.js`). Each resource rendered as a `.resource-box` (bordered container from `styles.css`) with icon image + `current/max` value (unbounded resources like knowledge and faith show only `current`). Bounded resources (food, wood, stone, copper, iron, gold) have a 3px progress bar at the bottom showing capacity fill percentage — green when production is positive, red when zero or negative. Production rate is not shown inline; instead, hovering a resource box reveals a rich HTML tooltip (`.resource-tooltip`) displaying the resource name, colored per-minute rate (green/red), and a time estimate ("Full in MM:SS" or "Empty in MM:SS") when the rate is nonzero. `UNBOUNDED_RESOURCES` set in `constants.js` controls which resources skip the progress bar and "full in" estimate.
3. **Colony** — population, idle workers, territory each shown as icon image + value (flex: 1, centered). The idle workers indicator includes a compact red dismiss button (`.dismiss-btn`, styled like `.worker-btn--minus`) that permanently removes idle workers to reduce consumption. Ctrl+click dismisses up to `BULK_WORKER_AMOUNT` (10). Disabled when no idle workers.
4. **Menu button** — hamburger icon (inline SVG), opens pause modal

Resource/colony items use `<img>` icons from `public/img/` (no text labels). Values use `Azeret Mono` (numeric font). All values sourced from `State` (see below), which initializes from `src/js/engine/constants.js` (factories) using values from `src/js/engine/balancing.js`.

**Keyboard**: Escape key toggles the pause modal (ignored when an `INPUT` or `TEXTAREA` is focused). F9 triggers a manual save (with a flash indicator). F3 toggles the performance overlay.

### Building Grid (`game_screen.vue`)

Main content area displaying all 20 buildings in a 4-column layout. Each column represents a building category (Colony, Economy, Religion, Military) with a Josefin Sans uppercase header and vertically stacked building cards.

**Data source**: `BUILDING_GRID` constant from `constants.js` — array of column definitions, each with `headerKey` (i18n key) and `buildings` array of `{ key, img }` objects. `BUILDING_IMAGE_MAP` (also in `constants.js`) provides a flat key→image lookup derived from `BUILDING_GRID`, used for event icons. The `img` is a full path constant from `assets.js` (e.g. `IMG_BUILDING_HOUSE` → `'/img/buildings/misc/house.jpg'`). The `key` indexes into both `state.colony.buildings[key]` for the level and `'building.' + key` for the localized name.

**Dynamic component resolution**: `game_screen.vue` maps all 20 building keys to dedicated card components via `CARD_COMPONENTS` (e.g. `headquarters → HeadquartersCard`). Uses Vue's `<component :is>` in the grid loop.

**Building unlock restrictions**: Buildings are locked/unlocked based on the headquarters type. The `HQ_BUILDING_UNLOCKS` constant in `constants.js` maps each HQ type to the building keys it unlocks (per-tier, non-cumulative). Headquarters is always unlocked. `game_screen.vue` checks each building via `isBuildingLocked()`, which iterates tiers up to the current HQ type index. Locked buildings render as a disabled placeholder card (same shell as `.building-card` but with `opacity: 0.4`) with a centered grayscale lock icon and a "Locked" tooltip, instead of the real card component.

**Resource unlock restrictions**: `HQ_RESOURCE_UNLOCKS` in `constants.js` maps each HQ type to the resource keys it makes visible in the header bar (Camp: food, wood, faith; Settlement: stone; Village: knowledge, copper; Town: iron; City: gold). `game_screen.vue` filters `HEADER_RESOURCES` against unlocked resources for the current HQ type.

**Column headers**: Josefin Sans uppercase labels (1rem, brighter accent at 0.75 opacity) centered above each column with a bottom border separator and extra bottom spacing.

### Building Cards (`src/components/buildings/`)

Per-building card components. Each receives `buildingKey`, `img`, and `building` (model instance) props.

**`base_card.vue`** — Shared card layout: flex row (top-aligned) with thumbnail image (4.5rem) and a level badge overlay (bottom-right, semi-transparent black background, `Azeret Mono` 0.8rem) showing the numeric level, building name (`Jost`, 1.1rem). Cards use `--color-bg-surface` background with `--color-border` that intensifies on hover. Accepts optional `nameKey` prop to override the default localization key. Provides a default `<slot>` inside the action row for inline custom content (e.g. market/academy modal buttons). A `?` help icon button sits in the top-right corner of each card (circular, muted accent border, brightens on hover). Hovering shows a "Help" tooltip; clicking opens `BuildingHelpModal` with the building's name and description. Accepts `showLevel` prop (default `true`); when false, the level badge is hidden (used by HQ card). Accepts `showBuildAction` prop (default `true`); when true, shows an action row: a build button (build icon, "Build {Name}" tooltip) at level 0, or a level-up button (upgrade icon, "Increase level" tooltip) at level > 0. Both the slot and the action row render when level > 0. Clicking the button deducts the cost from colony resources and starts a construction timer. Cost is computed via the `building.levelUpCost` getter. During construction (`building.constructionRemaining > 0`), the button itself becomes the progress indicator: a semi-transparent gold `::before` overlay fills left-to-right (driven by `--progress` CSS variable), the icon is replaced by a MM:SS countdown, and the cost items hide. The card border subtly glows with the accent color while constructing. The level increments only when the timer reaches zero.

**`headquarters_card.vue`** — Wraps `BaseCard` with `:show-level="false"` (level badge hidden), passes a computed `nameKey` of `building.headquarters.${type}` to display the HQ type name (Camp, Settlement, etc.) instead of the generic building name. Injects `ui` and `actions` (provided by `game_screen.vue`) for reactive UI reads and player action dispatch. Displays two action buttons:
- **Expand Territory** — territory icon, "Expand territory" tooltip. Costs `hq.levelUpCost` (food + wood). Starts a construction timer; level increments on completion. Disabled when resources insufficient or HQ is busy (either timer active).
- **Upgrade** — costs `hq.upgradeCost`. Starts a construction timer; advances HQ type on completion. Hidden at max type (City). Disabled when resources insufficient or HQ is busy. Both action buttons become progress indicators (gold fill overlay + countdown) while their timer is active. The two timers are mutually exclusive.

**`house_card.vue`** — Thin wrapper around `BaseCard` with no custom content. Worker recruitment is handled by `worker_assignment_row.vue`.

Each action is a horizontal row: a square icon-only button (2.5rem × 2.5rem) with the action image (`worker.png`, `upgrade.png`, `territory.png`) + cost items displayed outside the button to its right. Buttons use the `.tooltip` class with localized `data-tooltip` for hover labels. Cost rendering iterates the `Cost.entries` getter (a `Map<string, number>` of non-zero resources).

**`worker_assignment_row.vue`** — Reusable component rendered by `base_card.vue` for `Producer` buildings (academy, temple, farm, woodcutter, quarry, copperMine, ironMine, goldMine) via `building.isProducer` flag. Displays a red minus button, worker icon with `current/max` count, and green plus button. Max workers = `level × WORKERS_PER_LEVEL` (5). Injects `ui` and `actions` to read `ui.idleWorkers` and dispatch worker assignment/unassignment. Minus disabled at 0 workers; plus disabled when at building capacity and no idle workers available and cannot recruit (no afford or at population cap). When pressed, plus uses an idle worker if available; otherwise recruits a new worker (spending `WORKER_RECRUIT_COST`) and assigns it directly. Ctrl+click (or Cmd+click on Mac) on plus/minus assigns/unassigns up to `BULK_WORKER_AMOUNT` (10) workers at once.

**Adding a new building card**: Create `{building}_card.vue` wrapping `BaseCard`, add custom content via the slot, and register it in the `CARD_COMPONENTS` map in `game_screen.vue`.

### Game State (`src/js/engine/state.js`)

Central state container instantiated once per game session. Plain JS class — **not** wrapped in `reactive()`. The engine operates on vanilla objects with zero Proxy overhead. `game_screen.vue` maintains a `shallowReactive` UI view model (`ui`) that is synced from the plain engine state via two functions: `syncTimers()` (fast-path, throttled to ~20fps via `UI_SYNC_INTERVAL` — updates only season elapsed, construction/research timers, event countdowns, challenge timers, and blessing/punishment timeouts) and `syncUI()` (full sync, called on every 1-second `gameTick` and after every player action — copies all resource/production/building/market/academy/challenge data). Constructor receives a `Meta` instance (first) and a `Colony` instance (second). Created by `app.vue` via either `State.fromJSON(savedData)` (load) or `new State(createInitialMeta(), createInitialColony())` (new game), then passed as `initialState` prop to `game_screen.vue`.

**Save/Load**: `State.toJSON()` → `Meta.toJSON()` + `Colony.toJSON()` (which calls `Season.toJSON()`, `Resources.toJSON()`, `Buildings.toJSON()` (iterates all 20 buildings' `toJSON()`), `Events.toJSON()`). `State.fromJSON(data)` reverses the process using `Meta.fromJSON()`, `Colony.fromJSON(data, BUILDING_CLASS_MAP)`, then calls `update(0)` to rehydrate derived fields; returns `null` on any error. Stored in `localStorage` via `storage.savedGame` getter/setter.

**Provide/inject**: `game_screen.vue` calls `provide('ui', ui)`, `provide('actions', actions)`, `provide('openResearchModal', fn)`, `provide('openMarketModal', fn)`, and `provide('openChallengeModal', fn)`. Components `inject('ui')` for reactive reads from the view model, `inject('actions')` to dispatch player actions (`levelUpBuilding`, `downgradeBuilding`, `expandTerritory`, `upgradeHeadquarters`, `recruitWorker`, `assignWorkers`, `unassignWorkers`, `startResearch`, `executeTrade`, `dismissEvent`, `dismissAllPast`, `selectBlessing`, `acknowledgePunishment`), `inject('openResearchModal')` to open the research modal (used by `academy_card.vue`), `inject('openMarketModal')` to open the market modal (used by `market_card.vue`), and `inject('openChallengeModal')` to open the challenge detail modal (used by event click handlers). Affordability checks use the `canAffordCost(resources, cost)` utility from `utils.js` instead of the `Resources.canAfford` method.

**Structure**: `state.meta.{ version, createdDateTime, updatedDateTime, challenges, gameSpeed, tutorial }`, `state.colony.{ year, season, idleWorkers (derived getter), resources, production, consumption, productivity, buildings, events }` (`season` is a `Season` model with `currentSeason`, `seasonElapsed`, and boolean getters `isWarm`/`isCold`). `productivity` — ratio (0 to 1) multiplied into all production rates; set to 0 when no workers exist; otherwise starts at 1 (100%) and is reduced when food/wood has negative net production, proportional to deficit ratio (uncovered consumption / total consumption) scaled by `SHORTAGE_MAX_PENALTY`; worst-of when both are negative; ephemeral, recalculated each tick. Method: `netProduction(resource)` — returns `production[resource] − (consumption[resource] ?? 0)`, used by `State.update()` for negative production detection.

- `resources` (`Resources`) — current amounts with public fields: `territory`, `workers`, `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`, `territoryBonus` (bonus territory slots granted by blessings, added to effective territory cap). Methods: `canAfford(cost)` (returns `true` if all cost fields are covered), `deduct(cost)` (subtracts cost fields in place).
- `production` (`Production`) — per-tick rates with public fields: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `faith`, `knowledge`.
- `consumption` (`Consumption`, `src/js/models/consumption.js`) — per-second worker upkeep with fields: `food`, `wood`. Ephemeral (recalculated each tick by `State.update()`, not persisted).
- Storage caps live on the buildings that own them: `buildings.storehouse.storageCap(storageBonus)` returns the shared cap for food/wood/stone/copper/iron/gold, `buildings.headquarters.territoryCap` returns territory cap, and `buildings.house.workersCap` (cached each tick) returns worker cap. Faith and knowledge are unbounded.
- `buildings` (`Buildings`) — container with public fields keyed by camelCase building name. Each field holds a class instance extending `Building` (base class with `level`, `constructionRemaining`, `constructionDuration`; getters `isUnbuilt`, `isConstructing`; methods `levelUp(cost, durationMult)` (starts timer with optional research multiplier, returns duration), `advance(delta)` (ticks timer, returns `true` on completion and increments level)) or `Producer` (extends `Building`, adds `workers` defaulting to 0; getters `maxWorkers`, `isEmpty`, `isFull`). `constructionRemaining > 0` means the building is under construction; `constructionDuration` stores the total build time for progress calculation. Getter `totalLevels` returns the sum of all building levels excluding headquarters (used as current territory count). Getter `pendingTerritory` returns the count of non-HQ buildings currently under construction (used to reserve territory). The 8 worker-assignable buildings (academy, temple, farm, woodcutter, quarry, copperMine, ironMine, goldMine) extend `Producer`; all others extend `Building` directly. `Headquarters` also has `type`, `upgradeRemaining`, `upgradeDuration` (for type upgrade timer), getters `isUpgrading`, `isMaxType`, `territoryCap`, `upgradeCost` (returns `Cost|null` based on current type), and `nextType` (returns next type string or `null`); methods `upgradeType(cost, durationMult)` (starts type upgrade timer with optional research multiplier, returns duration), `advanceUpgrade(delta)` (ticks upgrade timer, advances type on completion). All 20 building keys are defined as `BUILDING_*` enums in `enums.js` (e.g. `BUILDING_FARM`, `BUILDING_COPPER_MINE`) and used as computed-property keys throughout `constants.js`, `balancing.js`, and `game_screen.vue`. All 20 building classes have a getter `levelUpCost` that returns a `Cost` using `cost` and `multiplier` from `BUILDING_UPGRADES` (HQ: `cost × m^(level-1)`, others: `cost × m^level`). Individual building classes live in `src/js/models/buildings/`.
- `Cost` (`src/js/models/cost.js`) — multi-resource cost holder with properties: `food`, `wood`, `stone`, `copper`, `iron`, `gold`, `knowledge`. Getters: `entries` (returns a `Map<string, number>` of non-zero resources), `toSeconds` (derives build time in seconds from resource weights defined in `RESOURCE_TIME_WEIGHTS`, raised to `RESOURCE_TIME_EXPONENT`). Method: `multiplyFloor(factor)` (returns a new `Cost` with each resource multiplied by `factor` and floored).

All initial values declared via `createInitialMeta()` (a `Meta` instance) and `createInitialColony()` (a `Colony` instance) in `src/js/engine/constants.js`, using numeric values from `src/js/engine/balancing.js`. `BUILDING_CLASS_MAP` maps all 20 building keys to their class constructors.

### Player Actions (`State` methods in `src/js/engine/state.js`)

All game state mutations are centralised in `State`. Each method guards preconditions, applies the mutation, and calls `this.update(0)` to recalculate derived values.

- `levelUpBuilding(buildingKey)` — deducts `levelUpCost`, starts a construction timer (`constructionRemaining`). Territory is reserved immediately via `pendingTerritory`. Level increments when the timer reaches zero. Blocked when territory is full or already constructing.
- `downgradeBuilding(buildingKey)` — instantly reduces a producer building's level by 1, freeing a territory slot. Excess workers above the new capacity are returned to idle. Only allowed on `DOWNGRADABLE_BUILDINGS` (10 buildings: the 8 worker-assignable producers plus market and altar) and only when territory is full. Blocked when level is 0 or building is constructing.
- `expandTerritory()` — deducts `levelUpCost`, starts a construction timer. Level increments on completion. Blocked when HQ is busy (either timer active).
- `upgradeHeadquarters()` — deducts `upgradeCost`, starts a type upgrade timer (`upgradeRemaining`). HQ type advances on completion. Blocked when HQ is busy.
- `recruitWorker()` — delegates to `_recruit()` (increments `resources.workers`); `colony.idleWorkers` updates automatically (derived getter). Blocked when can't afford or at population cap.
- `assignWorkers(buildingKey, count)` — assigns up to `count` workers to the building. Uses idle workers if available, otherwise recruits via `_recruit()`. Plays sound and calls `update(0)` once at the end. Blocked per-iteration when building is full or when no idle workers and recruitment fails.
- `unassignWorkers(buildingKey, count)` — moves up to `count` workers (or all remaining) from the building back to idle. Calls `update(0)` once.
- `dismissWorkers(count)` — permanently removes up to `count` idle workers from the colony. Decrements `resources.workers`, dismisses population-limit event if below cap, calls `update(0)`.
- `_recruit()` — shared helper: deducts `WORKER_RECRUIT_COST`, increments `resources.workers`, plays sound, fires population-limit event if at cap. Returns `boolean`.
- `_playAssignSound(buildingKey)` — plays building-specific worker assignment sound (farm/academy/woodcutter/temple/mines).
- `startResearch(key)` — validates preconditions (not active/completed, academy level met, can afford), deducts cost, starts timer via `buildings.academy.start()`, creates a future event (`EVENT_TYPE_RESEARCH_COMPLETE`). Blocked when prerequisites not met or insufficient resources.
- `advanceResearch(delta)` — decrements `remainingSeconds` on all active researches. When a timer reaches zero, calls `academy.complete(key)`, dismisses the future event, and plays `SND_RESEARCH_COMPLETED`. Collects completed keys before processing to avoid mutating the Map during iteration.
- `executeTrade(resource, direction, amount)` — delegates to `Market.executeTrade(resource, direction, resources, storageCap, amount)`. Calls `this.update(0)` on success to recalculate derived values.
- `selectBlessing(blessingIndex)` — player action from the reward modal. Validates active challenge and modal state. Gets the chosen blessing, calls `challenges.complete(blessing)`, applies the blessing via `_applyBlessing()`, dismisses the challenge event. If all challenges are completed, shows the win modal; otherwise unpauses.
- `acknowledgePunishment()` — player action from the failure modal. Dismisses the challenge event, calls `challenges.fail(punishment)` (resets timers), applies the punishment via `_applyPunishment()`, unpauses.
- `continueAfterWin()` — player action from the win modal. Unpauses the game and clears the challenge modal.
- `advanceChallenges(delta)` — advances blessing/punishment timeouts, activates the next pending challenge if none is active, advances active challenge timers. When delay expires, transitions to `started` and fires a non-dismissable future event with `action: 'openChallengeModal'`. When timeout expires, resolves via `_resolveChallengeTimeout()`.
- `areChallengeRequirementsMet()` — checks all active challenge requirements (faith, building levels, resources, workers) against current colony state. Returns boolean.
- `_applyBlessing(blessing)` — applies instant blessing effects: `GIFT_FROM_THE_HEAVENS` grants resources (capped at storage), `HOLY_EXPANSION` adds to `resources.territoryBonus`.
- `_applyPunishment(punishment)` — applies instant punishment effects: removes fraction of faith, removes fraction of bounded resources, sacrifices workers, downgrades random building levels.
- `_sacrificeWorkers(count)` — removes workers: first from idle pool, then randomly unassigned from producer buildings. Clamped to available workers.
- `_buildingName(buildingKey)` — returns the localized display name for a building. For headquarters, resolves to the HQ type name; for others, uses `t('building.' + key)`.

### Events (`src/js/models/events/event.js`, `event_future.js`, `event_past.js`, `events.js`)

Event system for notifying the player of upcoming threats and past occurrences. Events live on `Colony.events` and support serialization via `toJSON()` for save/load.

**`Event`** — Abstract base class with common fields: `id` (auto-assigned), `type` (event type constant, e.g. `EVENT_TYPE_SEASON_CHANGED`, `EVENT_TYPE_BUILDING_UPGRADE`), `textKey` (i18n key), `icon` (full image path from `assets.js`, e.g. `IMG_RESOURCE_FOOD`), `params` (string array for positional i18n interpolation, default `[]`), `buildingKey` (building key for construction event lookup, default `null`), `researchKey` (research key for research event lookup, default `null`), `action` (string action identifier triggered on event click, default `null` — used by challenge events with value `'openChallengeModal'`). Method: `toJSON()` (serializes all fields).

**`EventFuture`** — Extends `Event`. Adds `remainingSeconds` (countdown until event fires). Method: `advance(delta)` (decrements `remainingSeconds`, clamped at 0). Overrides `toJSON()` to include `remainingSeconds`.

**`EventPast`** — Extends `Event`. No additional fields.

**`Events`** — Array-backed container with methods:
- `addFuture({ type, textKey, icon, params, buildingKey, researchKey, action, remainingSeconds })` — creates an `EventFuture` with countdown
- `addPast({ type, textKey, icon, params, buildingKey, researchKey })` — creates an `EventPast`
- `convertToPast(buildingKey, data)` — finds the future event matching `buildingKey`, removes it, and adds a past event with the given data
- `dismissFutureByBuildingKey(buildingKey)` — removes a future event by building key (used when non-HQ buildings complete construction)
- `dismissFutureByResearchKey(researchKey)` — removes a future event by research key (used when research completes)
- `dismissFutureByType(type)` — removes a future event by type (used when challenge events are dismissed)
- `dismiss(id)` — removes event by id (uses `splice` for Vue reactivity)
- `dismissPastByType(type)` — removes all past events matching the given type
- `dismissPastByTextKey(textKey)` — removes all past events matching the given i18n key (used for negative production recovery)
- `dismissAllPast()` — removes all past events
- `sortedFuture` (getter) — returns `EventFuture` items sorted by `remainingSeconds` ascending
- `sortedPast` (getter) — returns `EventPast` items sorted by `id` descending (most recent first)
- `advance(delta)` — decrements `remainingSeconds` on `EventFuture` items, clamps at 0 (does not auto-convert to past)
- `toJSON()` — serializes the events container (future, past, nextId) for persistence

Called from the `progressTick` loop (`requestAnimationFrame`, ~60 fps) in `game_screen.vue` via `state.advanceEvents(delta)`, alongside `advanceSeason`, `advanceConstruction`, `advanceResearch`, and `advanceChallenges`.

**UI**: Displayed as a 5th column in `game_screen.vue` alongside the 4 building columns (all `flex: 1`, equal width). Four sub-sections: "Active Blessings" (ongoing blessing effects with countdown timer, shown when any are active), "Active Punishments" (ongoing punishment effects with countdown timer, shown when any are active), "Upcoming" (future events with gold countdown timer), and "History" (past events, with a "Clear all" button to dismiss all at once). Event rows use the same style: icon + text + dismiss button, with a gold left-border accent. Future events additionally show a countdown timer. Empty state shown when no events exist.

### Tutorial System

Step-by-step guided tutorial for new players, active from game start until completion.

**Model** — `Tutorial` class (`src/js/models/tutorial.js`) with `currentStep` (number), `completed` (boolean), `dismissedModals` (Set<string>), `activeModal` (string, ephemeral — not persisted). Getter: `isActive`. Methods: `toJSON()`, static `fromJSON()`. Lives on `state.meta.tutorial`.

**Steps** — `TUTORIAL_STEPS` constant in `constants.js` — 15 sequential steps, each with `textKey` (i18n key), `building` (optional building key to highlight), and `check(state)` function that returns `true` when the step's objective is met. Steps guide the player through building a house, farm, and woodcutter, assigning workers, upgrading buildings, building an altar, expanding territory, and upgrading the headquarters.

**Modals** — `TUTORIAL_MODALS` constant in `constants.js` — 4 reactive modal definitions keyed by `TUTORIAL_MODAL_*` enums (`SEASON_CHANGED`, `NEGATIVE_PRODUCTION`, `HQ_UPGRADE`, `CHALLENGE_STARTED`). Each has `titleKey` and `bodyKey` for localization. Triggered by game state transitions (e.g. first season change, first challenge start) and shown once (tracked via `dismissedModals`).

**UI** — `TutorialBanner` (`src/components/tutorial/tutorial_banner.vue`) displays the current step at the bottom of the game screen with optional building icon and step counter. `TutorialModal` (`src/components/tutorial/tutorial_modal.vue`) shows educational popups triggered by state transitions. Both are rendered in `game_screen.vue` when the tutorial is active.

### Tick System (`State.update()` in `src/js/engine/state.js`)

Core game loop that generates resources over time. `game_screen.vue` runs a main `setInterval` (1 second, `TICK_INTERVAL`) that calls `state.update(deltaSec)` for production/consumption, and a `requestAnimationFrame` loop (~60 fps, `progressTick`) that calls `state.advanceSeason(delta)`, `state.advanceConstruction(delta)`, `state.advanceResearch(delta)`, `state.advanceEvents(delta)`, and `state.advanceChallenges(delta)` for smooth visual progress. Both use `performance.now()` for delta calculation. The main `gameTick` also calls all five progress methods (`advanceSeason`, `advanceConstruction`, `advanceResearch`, `advanceEvents`, `advanceChallenges`) as a fallback for backgrounded tabs where `requestAnimationFrame` pauses.

**Construction timers**: `advanceConstruction(delta)` runs inside the `requestAnimationFrame` loop (`progressTick`) for smooth visual progress (~60 fps). It decrements `constructionRemaining` on all buildings; when a timer reaches zero, the building's level increments and `constructionDuration` resets. For HQ territory expansion, the future event is converted to a past event via `events.convertToPast()`. For all other buildings, the future event is simply removed via `events.dismissFutureByBuildingKey(key)`. When a storehouse completes, all resource-limit past events are dismissed. When a house completes, all population-limit past events are dismissed. When a monument completes, `MONUMENT_FAITH_PER_LEVEL × newLevel` faith is added to `colony.resources.faith`. The HQ type upgrade timer (`upgradeRemaining`) is ticked separately; on completion, `hq.type` advances to the next tier (no event fired for type upgrades). The next `update()` call (1-second interval) picks up the new level for storage cap/production recalculation.

**Territory & storage cap recalculation**: Each tick recalculates `resources.territory` via `buildings.totalLevels + buildings.pendingTerritory` (sum of all building levels plus buildings under construction — each counts as one territory slot), then caches `buildings.house.workersCap` via `buildings.house.populationCap(habitationBonus)` (`level × (HOUSE_POPULATION_PER_LEVEL + habitationBonus)`, where `habitationBonus` is the cumulative flat bonus from completed Habitation researches). Territory cap is the sum of `buildings.headquarters.territoryCap` (`level × HQ_TERRITORY_PER_LEVEL`) and `resources.territoryBonus` (granted by the Holy Expansion blessing). All 6 resource caps (food, wood, stone, copper, iron, gold) via `buildings.storehouse.storageCap(storageBonus)` (`floor(STOREHOUSE_BASE_CAPACITY × STOREHOUSE_CAPACITY_MULTIPLIER^level × (1 + storageBonus))`, where `storageBonus` is the cumulative fractional bonus from completed Storage researches). All balancing values in `src/js/engine/balancing.js`. Building level-ups (except HQ) are blocked when `resources.territory >= headquarters.territoryCap + resources.territoryBonus`; HQ is exempt since it is the only building that increases max territory.

**Production formula**: Computed in `_computeProductionRates()` (state.js) in two stages. **Stage 1 — base rates**: for each building in `PRODUCTION_RATES` (balancing.js), base rate = `workers × config.rate` (or `level × config.rate` for passive buildings like altar). **Stage 2 — per-resource multipliers**: each resource starts with multiplier `1`, then research bonuses (`BONUS_FOOD_PRODUCTION`, `BONUS_MINING_PRODUCTION`, etc.), worker productivity (`BONUS_WORKER_PRODUCTIVITY` from Transportation research, bounded resources only), active blessing productivity boosts (e.g. `FERTILE_SOIL` for farms, `CELESTIAL_PROSPERITY` for all producers), active punishment productivity reductions (e.g. `CROP_FAILURE` for farms, `VOLCANO` for all producers), and season modifier (food only, `±SEASON_WARM/COLD_FOOD_MODIFIER`, amplified/softened by `FAVORABLE_WEATHER` blessing) are added additively. The final raw rate per resource is `baseRate × multiplier`. The productivity penalty (from `_computeGeneralProductivity`) is applied externally in `update()`: `finalRate = rawRate × productivity`. Rates are stored on `colony.production` (per-second) for UI display, then scaled by `deltaSec` when applied to `colony.resources`. Resources (except faith and knowledge, which are unbounded) are capped at `buildings.storehouse.storageCap(storageBonus)` after application.

**Worker consumption**: Computed before production in `update()`. Every worker (idle and assigned) consumes `WORKER_FOOD_CONSUMPTION × (1 - BONUS_FOOD_CONSUMPTION)` food/sec and `WORKER_WOOD_CONSUMPTION × (1 - BONUS_WOOD_CONSUMPTION)` wood/sec — both reduced by their respective research bonuses. Wood consumption is additionally scaled by seasonal modifier: `×(1 + SEASON_WARM_WOOD_MODIFIER)` (−20% in warm) and `×(1 + SEASON_COLD_WOOD_MODIFIER)` (+20% in cold). If resources are insufficient, they are clamped to 0. Skipped when `delta === 0` or no workers exist.

**General productivity**: Computed in `_computeGeneralProductivity()` (state.js). When food or wood has negative net production (tracked by `_resourcesNegativeProduction`, a one-tick-delayed edge-detection set), productivity is reduced proportionally to the deficit ratio: `1 - (deficit / consumption) × SHORTAGE_MAX_PENALTY`. Uses current-tick raw production rates (before penalty) and current-tick consumption rates to avoid a feedback loop where penalized production locks productivity at zero. The penalty applies to all resource production equally.

**Negative production detection**: After net production is finalized (including worker upkeep subtraction), a `_resourcesNegativeProduction` Set tracks which bounded resources currently have negative net production. When a resource transitions from non-negative to negative, a past event fires (using `RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG` from `constants.js`). When it recovers to non-negative, the corresponding past event is removed via `events.dismissPastByTextKey()` and the resource is removed from the set so future drops can re-trigger. This follows the same edge-detection pattern as `_resourcesAtCap`.

**Base rates** (per worker per second): farm→food 1.0, woodcutter→wood 0.5, quarry→stone 0.3, copperMine→copper 0.2, ironMine→iron 0.1, goldMine→gold 0.05, academy→knowledge 0.1, temple→faith 0.15. Altar→faith 0.1/level/sec (passive). All values defined in `src/js/engine/balancing.js`.

**Tooltips** — Colony items (population, idle workers, territory) use CSS-only tooltips (`.tooltip` class + `data-tooltip` attribute). Resource items use HTML-based rich tooltips (`.resource-tooltip` inside `.resource-box`) that display the resource name, colored production rate, and time estimate on hover. Both tooltip styles are defined in `src/assets/styles.css`.

### Localization (`src/js/i18n/`)

Each supported language has its own file (`ca.js`, `en.js`, `es.js`, `fr.js`, `it.js`) exporting a flat object with dot-notation keys (e.g. `'screen.home.newGame'`, `'resource.food'`, `'season.warm'`). At startup, `localized.js` reads `navigator.language`, resolves it to a supported locale (defaulting to English), and exports a `t(key, ...params)` helper that looks up strings from the resolved locale. When `params` are provided, positional placeholders (`{0}`, `{1}`, etc.) in the string are replaced with the corresponding values. Components import `t` from `localized.js` and use it in templates (`{{ t('key') }}`, `{{ t('key', param0) }}`) and bound attributes (`:alt="t('key')"`). No hardcoded display text in templates or JS.

### Assets (`src/js/engine/assets.js`)

Auto-generated by `scripts/generate-assets.js` (`npm run generate-assets`). Scans `public/img/`, `public/audio/sound/`, and `public/audio/music/` and exports named constants with prefixes: `IMG_` for images, `SND_` for sound effects, `MUS_` for music tracks. Also exports `IMG_RESOURCE_MAP` (resource key → image path) and `IMG_PUNISHMENT_MAP` (punishment type → image path) for dynamic image lookups. Do not edit `assets.js` manually.

### Format (`src/js/engine/format.js`)

Shared display formatters.

- `formatTime(totalSeconds)` — converts seconds to `MM:SS` or `HH:MM:SS` (hours only when ≥ 3600s). Uses `Math.ceil` rounding. Used by construction timers, research timers, event countdowns, and resource time estimates.
- `formatNumber(n)` — abbreviates large numbers with K/M/B/T suffixes (e.g. 1500 → "1.5K"). Used for resource amounts, worker counts, and territory display.
- `formatRate(ratePerSecond)` — formats a per-second production rate as a display string with localized unit suffix. Used for resource tooltip rates.

### Audio (`src/js/engine/audio.js`)

Singleton `Audio` class managing sound effects and background music. Preloads all audio files from `AUDIO_CONFIG` (in `constants.js`) at startup. Per-asset volume levels are configured in `AUDIO_CONFIG`. Preferences (music/sound enabled) are persisted via `Storage`. Registers a `visibilitychange` listener to auto-resume music when the tab becomes visible (workaround for iOS Safari suspending audio in background tabs). A `_gamePaused` flag prevents auto-resume from overriding intentional pauses by game logic.

**Methods**: `preload()`, `playSound(assetPath)` (one-shot effect), `playMusicPlaylist(tracks)` (sequential playlist, cycles back to first after last), `stopMusic()`, `pauseMusic()`, `resumeMusic()`, `setMusicEnabled(enabled)`, `setSoundEnabled(enabled)`.

**Helper**: `playTap()` — exported shortcut that plays the button tap sound effect (`SND_BUTTON_TAP`). Used by all interactive UI components.

### Storage (`src/js/engine/storage.js`)

Thin `localStorage` wrapper for persisting user preferences and game state. Exposes `musicEnabled` and `soundEnabled` as getter/setter pairs (default `true`). Used by `Audio` to persist toggle state across sessions. Also exposes `autosaveEnabled` (default `true`) and `autosaveInterval` (default `AUTOSAVE_DEFAULT_INTERVAL`, clamped to min/max bounds) getter/setter pairs for autosave configuration. Also exposes `tradeAmount` (default `MARKET_TRADE_AMOUNT`) for persisting the market trade lot size. Exposes `savedGame` getter/setter (JSON parse/stringify with error handling) and `deleteSavedGame()` for save/load persistence.

### Research System

Research is an academy-gated tech tree providing cumulative bonus modifiers.

**Model** — Research state is managed directly by the `Academy` class (`src/js/models/buildings/academy.js`), which extends `Producer` with `completed` (`Set<string>`), `active` (`Map<string, Research>`). Methods: `isCompleted(key)`, `isActive(key)`, `canResearch(key)` (requires level ≥ 1, not active, not completed), `start(key, duration)`, `complete(key)`, `completedBonuses(researchTree)` (aggregates `BONUS_*` values using the tree to find subcategory bonus definitions), `toJSON()`. Accessed via `colony.buildings.academy`.

**Enums** (`enums.js`) — `RESEARCH_CATEGORY_*` (5 categories: colony, disasters, resources, religion, military), `RESEARCH_SUBCATEGORY_*` (18 subcategories, e.g. transportation, construction, storage, habitation, floods, food production, defense, attack, warning), `RESEARCH_*` keys (5 tiers per subcategory, e.g. `RESEARCH_TRANSPORTATION_1` through `_5`), `BONUS_*` types (18, e.g. `BONUS_WORKER_PRODUCTIVITY`, `BONUS_CONSTRUCTION_TIME`, `BONUS_FOOD_PRODUCTION`, `BONUS_HABITATION`, `BONUS_UNIT_DEFENSE`).

**Definitions** (`balancing.js`) — `RESEARCH_COSTS` maps each `RESEARCH_*` key to a `Cost` instance. Duration is derived from the cost via `Cost.toSeconds`. Starting any research requires academy level ≥ 1 (flat check, not per-research). Bonuses are defined per subcategory in `RESEARCH_SUBCATEGORY_BONUSES` (also in `balancing.js`), mapping each `RESEARCH_SUBCATEGORY_*` to `{ type: BONUS_*, value: number, [flat: true] }`. Each tier within a subcategory costs progressively more resources.

**Tree** (`constants.js`) — `RESEARCH_TREE` is an ordered array of `{ category, subcategories: [{ key, researches: [research keys] }] }` used by the research modal for layout.

**Modal** (`research_modal.vue`) — Tabbed overlay with category tabs at top, scrollable subcategory sections below. Each subcategory displays a horizontal chain of research nodes connected by arrows. Node states: `completed` (gold border + checkmark), `active` (pulsing glow), `available` (brighter border), `locked` (dimmed). Each node shows name and resource cost icons. A "?" help button (`.modal-help-btn`) sits left of the close button and opens `ModalHelpModal` with research help text. Opened via `inject('openResearchModal')` from `academy_card.vue`. Emits `close` on backdrop click, close button, or Escape key.

### Challenges System

Sequential divine challenges forming the game's win condition. State lives on `state.meta.challenges`.

**Model** — `Challenges` container class (`src/js/models/challenges.js`) with fields: `pending` (array of `Challenge`), `active` (`Challenge` or `null`), `completed` (array of `Challenge`), `activeBlessings` (array of `Blessing`), `activePunishments` (array of `Punishment`). Getters: `totalCount`, `allCompleted`. Methods: `activate()` (moves first pending to active), `start()` (transitions active from `activated` to `started`), `complete(blessing)` (marks active complete, stores a copy of the blessing), `fail(punishment)` (resets challenge timers, stores a copy of the punishment so the countdown never drains the challenge's own punishment, which is reused on retry), `advance(delta)` (advances delay/timeout timers). Accessed via `state.meta.challenges`.

**Challenge** (`src/js/models/challenge.js`) — individual challenge with fields: `index`, `status` (`pending`/`activated`/`started`/`completed`), `delay`, `delayElapsed`, `timeout`, `timeoutElapsed`, `requirements` (`{ faith, altar, temple, monument, resources, workers }`), `blessings` (array of 2 `Blessing` choices), `punishment` (`Punishment`). Getters: `isDelayElapsed`, `isTimeoutElapsed`. Method: `reset()` (resets timers and status to `activated` for retry after failure).

**Blessing** (`src/js/models/blessing.js`) — reward with fields: `type` (blessing type enum), `timeout` (duration or `null` for instant), `productivity`, `resources`, `territory`, `construction`, `warm`, `cold` (all nullable, effect-specific).

**Punishment** (`src/js/models/punishment.js`) — penalty with fields: `type` (punishment type enum), `timeout` (duration or `null` for instant), `faith`, `productivityFarm`, `productivityWoodcutter`, `productivityMines`, `productivityGeneral`, `resources`, `workers`, `levels` (all nullable, effect-specific).

**Enums** (`enums.js`) — `CHALLENGE_STATUS_*` (4 statuses: pending, activated, started, completed), `CHALLENGE_*` keys (1–10), `CHALLENGE_MODAL_*` (reward, failure, win), `BLESSING_*` types (10: fertile soil, forest bloom, gift from the heavens, holy expansion, rich mines, celestial prosperity, rapid construction, favorable weather, wisdom of the gods, blessed markets), `PUNISHMENT_*` types (5: crop failure, wildfires, landslide, plague, volcano), `EVENT_TYPE_CHALLENGE_STARTED`.

**Definitions** (`src/data/challenges.json`) — 10 challenge definitions with escalating requirements, 2 blessing choices each, and typed punishments. Loaded by `createInitialChallenges()` in `constants.js`.

**UI field** — `state.challengeModal` (`null`/`CHALLENGE_MODAL_REWARD`/`CHALLENGE_MODAL_FAILURE`/`CHALLENGE_MODAL_WIN`) controls which blocking modal is shown. Game is paused while any challenge modal is visible.

## Visual Design

**Theme**: Earthy & Ancient — warm browns, parchment tones, and aged bronze accents, evoking a torchlit ancient settlement. Inspired by Forge of Empires, Tribal Wars 2, Goodgame Empire.

**Colors**:
- Background: `rgba(22, 18, 14, 1)` (deep umber, aged wood by torchlight)
- Raised surface: `rgba(30, 26, 20, 1)` (dark walnut)
- Panel surface: `rgba(39, 33, 25, 1)` (stone panel)
- Text: `rgba(228, 213, 188, 1)` (warm parchment cream)
- Accent: `rgba(184, 148, 62, 1)` (aged bronze)
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
  - `.action-row` — flex row for icon-button + cost display pairs. `.action-btn` (2rem square icon button), `.action-btn-icon` (1.25rem icon), `.action-cost` (cost container), `.action-cost-item` (icon + amount pair), `.action-cost-icon` (0.9rem resource icon), `.action-cost-amount` (0.75rem value text), `.action-cost-short` (red color `rgba(196, 80, 80, 1)` when unaffordable).
  - `.action-btn--constructing` — modifier that turns the action button into a progress indicator. Uses `::before` pseudo-element with `--progress` CSS variable for gold fill overlay (`transition: width 1s linear`). `.action-btn-time` (0.65rem numeric countdown inside the button).
  - `.slot-actions` — flex column wrapper for action groups inside building card slots. Uses `margin-top: auto` to bottom-align with thumbnail.
  - `.modal-close-x` — absolute-positioned close button (X icon) in top-right corner of modals (1.5rem square, red-tinted background, hover intensifies). Used by `research_modal.vue` and `market_modal.vue`.
  - `.modal-help-btn` — circular "?" help button positioned left of the close button (1.5rem, accent-colored border, hover brightens). Used by `research_modal.vue` and `market_modal.vue` to open `ModalHelpModal`.
  - `.card-modal-btn` — small icon-only button used inside building card slots to open a modal (e.g. academy research, market trading). Uses `margin-left: auto` to align right. `.card-modal-btn-icon` (1.1rem icon).
  - `.worker-slot-row` — flex row wrapper (inside `.slot-actions`) that places `WorkerAssignmentRow` for `Producer` buildings.
  - `.worker-row` — flex row for worker assignment controls. `.worker-btn` (2rem square ghost button), `.worker-btn--minus` (red `rgba(196, 80, 80, 1)`), `.worker-btn--plus` (green `rgba(80, 168, 80, 1)`), `.worker-count` (icon + text, 0.95rem), `.worker-count-icon` (1.4rem worker icon).
  - `.production-rate` — per-minute rate indicator (0.8rem numeric font). `.production-rate--positive` (green `rgba(80, 168, 80, 1)`), `.production-rate--negative` / `.production-rate--zero` (red `rgba(196, 80, 80, 1)`).
  - `.resource-box` — bordered container for header resource items (subtle bronze gradient, `position: relative`). `.resource-row-top` (flex row for icon + value). `.resource-icon` (1.25rem icon). `.resource-value` (0.8rem `Azeret Mono` numeric amount, tabular-nums, right-aligned, 6ch min-width). `.resource-value--alert` (red `rgba(192, 57, 43, 1)` when at storage cap), `.resource-value--zero` (red `rgba(196, 80, 80, 1)` when empty). `.resource-bar` (4px progress track at bottom), `.resource-bar-fill--positive` (green), `.resource-bar-fill--negative` (red). `.resource-tooltip` (HTML-based rich tooltip with flex-column layout), `.resource-tooltip-rate` (monospace rate), `.resource-tooltip-time` (subdued time estimate). `.resource-tooltip-grid` (2-column CSS grid for colon-aligned label/value pairs), `.resource-tooltip-label` (right-aligned label in first column), `.resource-tooltip-value` (value in second column), `.resource-tooltip-full` (full-width row spanning both columns), `.resource-tooltip-label--spaced` / `.resource-tooltip-value--spaced` (top margin before producing/consuming groups).