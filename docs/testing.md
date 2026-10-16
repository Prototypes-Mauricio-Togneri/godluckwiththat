# Testing

## Framework

- **Runner**: [Vitest](https://vitest.dev/) (`vitest ^4.1`)
- **Coverage**: `@vitest/coverage-v8`
- **Config**: `vitest.config.js` merges the Vite config so `@` path aliases resolve in tests

## Commands

| Command                 | Description                       |
|-------------------------|-----------------------------------|
| `npm test`              | Run all tests once                |
| `npm run test:watch`    | Run tests in watch mode           |
| `npm run test:coverage` | Run tests with v8 coverage report |

## Test Scope

Tests cover the **engine layer** and **model layer** — pure JavaScript classes with no DOM or Vue dependency. The UI layer (Vue components) is not unit-tested.

### Engine (`tests/engine/`)

| File                | Covers                                                                                                                                            |
|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `analytics.test.js` | Firebase initialization (project config, localhost/127.0.0.1 exclusion, unsupported browser, failed init), `logGameStart`/`logTutorialComplete` event names and params, no events before `init`, logging failures swallowed |
| `enums.test.js`     | All exported enum values match expected strings (resources, HQ types, seasons, buildings, trade, challenge status, blessings, punishments, symbols) |
| `format.test.js`    | `formatTime`, `formatNumber`, `formatNumberFull`, `formatMinutes`, `formatRate`                                                                   |
| `utils.test.js`     | `canAffordCost`, `floorWithTolerance`, `storageCapacity`, `marketFeePercent`, `marketTradeQuote`                                                  |
| `balancing.test.js` | `BUILDING_UPGRADES` keys/values, season multiplier ranges, trade fee ranges                                                                      |
| `escape_stack.test.js` | Only the most recently pushed handler receives Escape and stops the event, Escape returns to the previous handler on removal (top or lower), other keys ignored, a single window listener attached while handlers exist, unknown removals ignored |
| `focus_stack.test.js` | Everything outside the topmost modal marked inert (not the modal or its ancestors, stopping at `<body>`), stacked and nested modals, removal order, elements added after opening marked too, focus returned to the previously focused element when the top modal closes, only its own marks cleared |
| `constants.test.js` | `BUILDING_CLASS_MAP` keys/values, consistency with `BUILDING_UPGRADES`, factory functions (`createInitialColony`, `createInitialColonyBasic`, `createInitialColonyAdvanced`, `createInitialMeta`, `createInitialChallenges`), `TUTORIAL_STEPS` check functions |
| `state.test.js`     | Game state machine (42 describe blocks, 247 tests): `constructor`, tick logic (`update`), `netProduction`, `expansionCost`, `advanceSeason`, `advanceConstruction`, `advanceResearch`, `advanceEvents`, `advanceChallenges`, `areChallengeRequirementsMet`, `selectBlessing`, `acknowledgePunishment`, `continueAfterWin`, `levelUpBuilding`, `recruitWorker`, `dismissWorkers`, `assignWorkers`, `unassignWorkers`, `startResearch`, `executeTrade`, `checkTutorial`, `expandTerritory`, `upgradeHeadquarters`, `downgradeBuilding`, serialization (`toJSON`/`fromJSON`), internal computations (`_computeGeneralProductivity`, `_computeSeasonMultipliers`, `_computeConsumptionRates`, `_computeProductionRates`, `_resolveChallengeTimeout`, `_deductRequirements`, `_completeChallenge`, `_failChallenge`, `_sacrificeWorkers`, `_advanceEffectTimeouts`, `_applyBlessing`, `_applyPunishment`, `_constructionDurationMult`, `_recruit`, `_triggerTutorialModal`, `_playAssignSound`, `_buildingName`) |

### Models (`tests/models/`)

| File                 | Covers                                                                    |
|----------------------|---------------------------------------------------------------------------|
| `colony.test.js`     | Constructor, `idleWorkers`, `fromJSON`/`toJSON` round-trip                |
| `buildings.test.js`  | `totalLevels`, `totalAssignedWorkers`, `pendingTerritory`, serialization  |
| `resources.test.js`  | Constructor defaults, `canAfford`, `deduct`                               |
| `cost.test.js`       | Constructor defaults, `entries` (caching), `multiplyFloor`, `toSeconds`   |
| `season.test.js`     | `isWarm`/`isCold`, `advance` (flipping, carry-over), serialization        |
| `blessing.test.js`   | Constructor, optional fields, `fromJSON`/`toJSON`                         |
| `punishment.test.js` | Constructor, serialization                                                |
| `challenge.test.js`  | Constructor, `isDelayElapsed`, `isTimeoutElapsed`, `reset`, serialization |
| `challenges.test.js` | `totalCount`, `allCompleted`, `activate`, `start`, `complete`, `fail`, `advance`, serialization |
| `meta.test.js`       | Constructor, `gameSpeed` defaults, `fromJSON`/`toJSON` round-trip         |
| `tutorial.test.js`   | Constructor defaults, `isActive`, `dismissedModals` serialization         |
| `production.test.js` | Constructor defaults and overrides                                        |
| `consumption.test.js`| Constructor defaults and overrides                                        |
| `serialization.test.js` | Robustness: missing fields, extra fields, null/undefined inputs for all model classes (Blessing, Punishment, Challenge, Challenges, Tutorial, Resources, Season, Meta, Buildings, Headquarters, Market, Events, EventFuture, EventPast, Colony) |

### Buildings (`tests/models/buildings/`)

Every building class has its own test file. Tests verify:

- **`levelUpCost`**: returns a `Cost` instance, matches the `baseCost * multiplier ^ level` formula from `balancing.js`, increases with level
- **Building-specific getters/methods**: e.g. `storageCap`, `populationCap`, `maxWorkers`, `effectiveTradeFee`, `buyPrice`/`sellPrice`, `executeTrade`, `upgradeCost`, `nextType`, `isUpgrading`, `territoryCap`
- **Serialization**: `toJSON` snapshots

Notable depth by file:

- `building.test.js` / `producer.test.js` — base classes: `isUnbuilt`, `isConstructing`, `levelUp`, `advance` (construction tick), worker fields (`maxWorkers`, `isEmpty`, `isFull`)
- `headquarters.test.js` — `isUpgrading`, `isMaxType`, `territoryCap`, `levelUpCost`, `upgradeCost`, `nextType`, `upgradeType`, `advanceUpgrade`, `toJSON`
- `market.test.js` — `effectiveTradeFee`, `executeTrade` (buy/sell success, rejection conditions, price clamping, multi-unit trades, per-lot price shifts, `blessedMarkets` bypass, rounding edge cases, no profitable round trips or split trades), `toJSON`
- `academy.test.js` — `Research` inner class (`constructor`, `advance`), `Academy` constructor (completed/active restoration), `isCompleted`, `isActive`, `canResearch`, `start`, `complete`, `completedBonuses` (aggregation, caching), `toJSON`
- `storehouse.test.js` — `storageCap` (base, level scaling, bonus, floor), `levelUpCost`
- `house.test.js` — `populationCap` (base, bonus, unbuilt), `levelUpCost`

### Events (`tests/models/events/`)

| File                   | Covers                                               |
|------------------------|------------------------------------------------------|
| `event.test.js`        | Constructor, required/optional fields, serialization |
| `event_future.test.js` | Constructor, `remainingSeconds`, `advance` (decrement, clamp), `toJSON` |
| `event_past.test.js`   | Constructor, inherits Event fields                                      |
| `events.test.js`       | `addFuture`, `addPast`, `convertToPast`, `dismissFutureByType`/`ByBuildingKey`/`ByResearchKey`, `dismiss`, `hasPastEvent`, `dismissPastByType`/`ByTextKey`, `dismissAllPast`, `advance`, `sortedFuture`/`sortedPast`, serialization |

### i18n (`tests/i18n/`)

| File                | Covers                                                                                                   |
|---------------------|----------------------------------------------------------------------------------------------------------|
| `localized.test.js`   | Language resolution (browser language, region suffix, fallback to English), `t()` parameter substitution |
| `locale_keys.test.js` | Key consistency across all locale files: every non-en locale has all en keys, no extra keys, no empty strings, all values are strings |

## What Is Not Tested

| Area                           | Reason                                                                                                              |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------|
| Vue components (`.vue` files)  | UI is thin — rendering, props, emits. Logic lives in models/engine. No component test setup (no `@vue/test-utils`). |
| `assets.js`                    | Auto-generated file (`npm run generate-assets`). Excluded from coverage.                                            |
| `audio.js`                     | Browser Audio API wrapper. Mocked in tests that depend on it. Excluded from coverage.                               |
| `main.js`                      | App bootstrap (Vue mount, game loop `requestAnimationFrame`). Excluded from coverage.                               |
| `storage.js`                   | `localStorage` wrapper. Mocked in tests that depend on it. Excluded from coverage.                                  |
| Locale files (`i18n/*.js`)     | Static key-value data. Validated indirectly through `localized.test.js`. Excluded from coverage.                    |
| E2E / integration              | No browser-level tests. Game is manually tested in the browser.                                                     |

## Coverage

Coverage is collected with the `v8` provider and reported as `text` (terminal) and `html` (browsable report in `coverage/`).

**Included**: all files under `src/js/**/*.js`.

**Excluded** (in `vitest.config.js`):
- `src/js/engine/assets.js`
- `src/js/engine/audio.js`
- `src/js/engine/main.js`
- `src/js/engine/storage.js`
- `src/js/i18n/ca.js`, `en.js`, `es.js`, `fr.js`, `it.js` (locale data files; `localized.js` is covered)

## Test Patterns

### Factory Helpers (`tests/helpers/factories.js`)

Reusable factory functions (`createCost`, `createResources`, `createSeason`, `createBuilding`, `createProducer`, `createHeadquarters`, `createBlessing`, `createPunishment`, `createChallenge`, `createChallenges`, `createTutorial`) provide sensible defaults with an `overrides` parameter for per-test customization.

### Building Keys (`tests/helpers/building_keys.js`)

Exports `VALID_BUILDING_KEYS` — a `Set` of all 20 `BUILDING_*` enum values. Used by `balancing.test.js` and `constants.test.js` to validate that config objects contain exactly the expected building keys.

### Mocking

- **`localized.js`** is mocked to return raw keys (`t: (key) => key`) so tests do not depend on translation content.
- **`analytics.js`** is mocked with `vi.fn()` stubs (`logTutorialComplete`) in state tests; `analytics.test.js` mocks `firebase/app` and `firebase/analytics` instead and stubs `window.location`.
- **`audio.js`** is mocked with `vi.fn()` stubs (`playSound`) so tests run without the Web Audio API.
- **`storage.js`** is mocked with default values so tests run without `localStorage`.
- Browser globals (`navigator.language`, `document.documentElement`) are stubbed via `vi.stubGlobal` in i18n tests.
- `vi.resetModules()` is used in i18n tests to re-evaluate module-level side effects between test cases.

### Setup File (`tests/helpers/setup.js`)

Pre-imports `balancing.js` to establish the correct module load order. `balancing.js` calls `new Cost()` at module scope; importing it first ensures `cost.js` receives a live binding for `RESOURCE_TIME_WEIGHTS` before `Cost` is instantiated.

### Conventions

- **File naming**: `<source_file>.test.js`, mirroring the `src/` directory structure under `tests/`.
- **Describe blocks**: top-level `describe` matches the class name; nested `describe` blocks match the method or getter name.
- **Assertions**: prefer `toBe` for primitives, `toBeInstanceOf` for type checks, `toEqual` for deep equality, `toBeGreaterThan` for ordering.
- **Serialization round-trips**: most model tests include a `fromJSON`/`toJSON` block that serializes and reconstructs, then asserts key fields are preserved.
