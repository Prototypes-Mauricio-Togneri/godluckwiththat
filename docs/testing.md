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

| File             | Covers                                                                                                                                            |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `enums.test.js`  | All exported enum values match expected strings                                                                                                   |
| `format.test.js` | `formatTime`, `formatNumber`, `formatNumberFull`, `formatMinutes`, `formatRate`                                                                   |
| `utils.test.js`  | `canAffordCost`                                                                                                                                   |
| `state.test.js`  | Game state machine: tick logic, season transitions, building construction, worker recruitment, trading, challenge lifecycle, tutorial progression |

### Models (`tests/models/`)

| File                 | Covers                                                                    |
|----------------------|---------------------------------------------------------------------------|
| `colony.test.js`     | Constructor, `idleWorkers`, `fromJSON`/`toJSON` round-trip                |
| `buildings.test.js`  | `totalLevels`, `totalAssignedWorkers`, `pendingTerritory`, serialization  |
| `resources.test.js`  | Constructor defaults, `canAfford`, `deduct`, serialization                |
| `cost.test.js`       | Constructor defaults, `entries` (caching), `multiplyFloor`, `toSeconds`   |
| `season.test.js`     | `isWarm`/`isCold`, `advance` (flipping, carry-over), serialization        |
| `blessing.test.js`   | Constructor, optional fields, `fromJSON`/`toJSON`                         |
| `punishment.test.js` | Constructor, serialization                                                |
| `challenge.test.js`  | Constructor, `isDelayElapsed`, `isTimeoutElapsed`, `reset`, serialization |
| `challenges.test.js` | Collection-level logic                                                    |
| `meta.test.js`       | Meta/prestige model                                                       |
| `tutorial.test.js`   | Tutorial step progression                                                 |

### Buildings (`tests/models/buildings/`)

Every building class has its own test file. Tests verify:

- **`levelUpCost`**: returns a `Cost` instance, matches the `baseCost * multiplier ^ level` formula from `balancing.js`, increases with level
- **Building-specific getters**: e.g. `storageCap`, `populationCap`, `maxWorkers`, `productionRate`
- **Serialization**: `toJSON` snapshots

The base classes `building.test.js` and `producer.test.js` cover shared behavior: `isUnbuilt`, `isConstructing`, `levelUp`, `advance` (construction tick), and worker-related fields.

### Events (`tests/models/events/`)

| File                   | Covers                                               |
|------------------------|------------------------------------------------------|
| `event.test.js`        | Constructor, required/optional fields, serialization |
| `event_future.test.js` | Future event model                                   |
| `event_past.test.js`   | Past event model                                     |
| `events.test.js`       | Event collection                                     |

### i18n (`tests/i18n/`)

| File                | Covers                                                                                                   |
|---------------------|----------------------------------------------------------------------------------------------------------|
| `localized.test.js` | Language resolution (browser language, region suffix, fallback to English), `t()` parameter substitution |

## What Is Not Tested

| Area                           | Reason                                                                                                              |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------|
| Vue components (`.vue` files)  | UI is thin — rendering, props, emits. Logic lives in models/engine. No component test setup (no `@vue/test-utils`). |
| `assets.js`                    | Auto-generated file (`npm run generate-assets`). Excluded from coverage.                                            |
| `audio.js`                     | Browser Audio API wrapper. Mocked in tests that depend on it. Excluded from coverage.                               |
| `main.js`                      | App bootstrap (Vue mount, game loop `requestAnimationFrame`). Excluded from coverage.                               |
| `storage.js`                   | `localStorage` wrapper. Mocked in tests that depend on it. Excluded from coverage.                                  |
| Locale files (`i18n/*.js`)     | Static key-value data. Validated indirectly through `localized.test.js`. Excluded from coverage.                    |
| `balancing.js`, `constants.js` | Declarative config. Validated indirectly through model and state tests that consume them.                           |
| E2E / integration              | No browser-level tests. Game is manually tested in the browser.                                                     |

## Coverage

Coverage is collected with the `v8` provider and reported as `text` (terminal) and `html` (browsable report in `coverage/`).

**Included**: all files under `src/js/**/*.js`.

**Excluded** (in `vitest.config.js`):
- `src/js/engine/assets.js`
- `src/js/engine/audio.js`
- `src/js/engine/main.js`
- `src/js/engine/storage.js`
- `src/js/i18n/*.js` (all locale files)

## Test Patterns

### Factory Helpers (`tests/helpers/factories.js`)

Reusable factory functions (`createCost`, `createResources`, `createSeason`, `createBuilding`, `createProducer`, `createHeadquarters`, `createBlessing`, `createPunishment`, `createChallenge`, `createChallenges`, `createTutorial`) provide sensible defaults with an `overrides` parameter for per-test customization.

### Mocking

- **`localized.js`** is mocked to return raw keys (`t: (key) => key`) so tests do not depend on translation content.
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
