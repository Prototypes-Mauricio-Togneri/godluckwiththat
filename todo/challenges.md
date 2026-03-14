# Challenges System - Implementation Plan

## Context

The gods send sequential challenges to prove the player's faith. Completing all challenges is the win condition (portal activates, player goes home). Challenges consume faith and resources, creating tension between economic growth and divine demands.

## Data structure
- Remove the existing field in Meta: `numberOfChallenges`
- Add a new `challenges` property of type `Challenges` (new class) to Meta, which will contain:
  - pending: array of objects of type `Challenge` (new class)
  - active: object of type `Challenge` (or null if no active challenge)
  - completed: array of objects of type `Challenge`

- The `Challenge` class will have these properties:
  - `index`: challenge number (starting from 1)
  - `delay`: time since it's active until the player is informed about it (in seconds)
  - `delayElapsed`: time elapsed since it became active (in seconds)
  - `timeout`: time limit to complete the challenge (in seconds)
  - `timeoutElapsed`: time elapsed since activation (in seconds)
  - `requirements`: object defining the challenge requirements
    - `faith`: required faith amount (can be null)
    - `altar`: required altar level (can be null)
    - `temple`: required temple level (can be null)
    - `monument`: required monument level (can be null)
    - `resources`: object with resource type keys and required amounts (can be null)
    - `workers`: required number of workers (can be null)
  - `blessings`: object of type `Blessing`
    - `type`: see blessing enum
    - `timeout`: duration of the blessing effect (in seconds, can be null for instant effects)
    - `resources`: amount of resources granted (can be null)
    - `territory`: number of territory slots granted (can be null)
    - `productivity`: percentage increase to productivity (e.g., 0.2 for 20% boost, can be null)
  - `punishment`: object of type `Punishment`
    - `type`: see punishment enum (e.g., resource loss, worker loss, event)
    - `timeout`: duration of the punishment effect (in seconds, can be null for instant effects)
    - `resourceLossFraction`: fraction of stored bounded resources lost (e.g., 0.3 for 30% loss, can be null)
    - `workerLoss`: number of workers lost (can be null)

## Blessings types
* `FERTILE_SOIL`: Increases food productivity
* `FOREST_BLOOM`: Increases wood productivity
* `RICH_MINES`: Increases minerals productivity
* `WISDOM_OF_THE_GODS`: Increases knowledge productivity
* `GIFT_FROM_THE_HEAVENS`: Receive a fixed amount of resources
* `HOLY_EXPANSION`: Receives fixed amount of territory slots
* `CELESTIAL_PROSPERITY`: Improves general productivity
* `BLESSED_MARKETS`: No trading fees
* `DIVINE_PROTECTION`: No natural disasters
* `FAVORABLE_WEATHER`: Winter becomes less harsh, with reduced wood consumption and higher-than-usual food production
* `SANCTIFIED_HERO`: Gives a special military unit
* `TEMPORARY_PEACE`: No enemy raids
* `CELESTIAL_FORTIFICATION`: Make buildings more resilient to attacks and disasters
* `RAPID_CONSTRUCTION`: Buildings constructed faster

## Punishment types
* `CROP_FAILURE`: Reduces food productivity
* `WILDFIRES`: Reduces wood productivity
* `PLAGUE`: Reduces population
* `LANDSLIDE`: Destroys buildings and reduces population
* `VOLCANO`: Reduces productivity, destroys buildings, and reduces population

## Design Decisions

- **Sequential**: One challenge active at a time. Complete/fail → next one activates after a delay
- **Timed**: Challenges have countdown timers
- **Rewards (blessings)**: One-time resource grants scaling with difficulty. Some blessings have more probability to appear at the beginning. But less probability to appear in the next one.
- **Punishments**: Lose resources AND workers (both). Fraction of stored bounded resources + some workers die
- **Recover relic**: Skipped for now (military not implemented)
- **Activation trigger**: First challenge activates immediately when the game starts
- **Non-dismissable**: Challenge countdown events cannot be dismissed by the player

## Challenge Definitions (Escalating)

- **1. Build Altar**
  - Level 3, 10 min
  - Blessings: [Fertile soil, Forest bloom, Rich mines]
  - Punishment: lose 30% of all stored bounded resources + 3 workers die + CROP_FAILURE event for next 2 minutes
- **2. Accumulate Faith** — 500 faith, 15 min
- **3. Build Temple** — Level 2, 12 min
- **4. Accumulate Faith** — 1000 faith, 15 min
- **5. Build Monument** — Level 2, 15 min
- **6. Accumulate Faith** — 2000 faith, 20 min
- **7. Ritual** — 500 food, 300 wood, 5 workers, 30 min

## Implementation Steps

### Step 1: Enums (`src/js/engine/enums.js`)
- Challenge states: `CHALLENGE_STATE_LOCKED`, `_ACTIVE`, `_COMPLETED`, `_FAILED`
- Challenge types: `CHALLENGE_TYPE_BUILD_ALTAR`, `_BUILD_TEMPLE`, `_BUILD_MONUMENT`, `_ACCUMULATE_FAITH`, `_RITUAL`, `_RECOVER_RELIC`
- Challenge keys: `CHALLENGE_1` through `CHALLENGE_8`
- Event types: `EVENT_TYPE_CHALLENGE_ACTIVE`, `_CHALLENGE_COMPLETED`, `_CHALLENGE_FAILED`

### Step 2: Challenges Model (`src/js/models/challenges.js`)
New `Challenges` class (lives on `meta`):
- State: `currentIndex`, `states` map, `completedCount`, `activeRemainingSeconds`, `activeDurationSeconds`, `allCompleted`
- Methods: `activate(duration)`, `complete()`, `fail()`, `advance(delta)`
- Getters: `currentKey`, `currentState`, `isActive`, `progress`
- Serialization: `toJSON()` / `fromJSON()`

### Step 3: Balancing (`src/js/engine/balancing.js`)
- `CHALLENGE_DEFINITIONS`: Array of 8 challenge configs (key, type, target, timeLimit, reward Cost, punishment, workerCost)
- `CHALLENGE_ACTIVATION_DELAY`: Seconds between challenge completion/failure and next activation
- `CHALLENGE_PUNISHMENT_RESOURCE_FRACTION`: 0.3 (30% resource loss)
- `CHALLENGE_PUNISHMENT_WORKER_LOSS`: Base worker loss per failure (e.g., 2-3, scaling)

### Step 4: Constants & Meta Update
- `src/js/engine/constants.js`: Import challenge definitions, add `createInitialChallenges()` factory
- `src/js/models/meta.js`: Add `challenges` property, update `toJSON`/`fromJSON`

### Step 5: State Logic (`src/js/engine/state.js`)
- `checkChallenges()`: Called in gameTick. Auto-activates next challenge at game start (or after delay), checks passive completion conditions (build level, faith amount)
- `advanceChallenges(delta)`: Called in progressTick. Decrements timer, handles expiry → fail
- `submitRitual()`: Player action for ritual-type challenges. Deducts resources + workers
- `_applyReward(reward)`: Adds resources to colony
- `_applyPunishment(punishment)`: Removes fraction of bounded resources + kills workers

### Step 6: Event Integration
- Challenge activated → `addFuture` with countdown (non-dismissable)
- Challenge completed → convert to `addPast` success event
- Challenge failed → convert to `addPast` failure event
- Add `dismissable` flag to Event base class (default `true`, challenges set `false`)

### Step 7: UI - Header Indicator (`game_screen.vue`)
- Challenge progress display in header (e.g., "3/8")
- Clickable to open challenge modal
- Add `syncChallenges()` to sync pattern

### Step 8: UI - Challenge Modal (`src/components/modals/challenge_modal.vue`)
- Current challenge: name, description, objective, timer, progress bar
- Ritual submit button with cost display (reuse `.action-row` pattern)
- Challenge history: completed/failed list with status icons
- Overall progress: X/8

### Step 9: Localization (`src/js/i18n/*.js`)
- Challenge system keys: title, states, objective templates, event messages
- Per-challenge names and descriptions (8 challenges × 5 locales)

### Step 10: Win Screen
- Simple modal when `allCompleted = true` announcing the portal activates

## Critical Files
- `src/js/engine/enums.js` — new enums
- `src/js/engine/balancing.js` — challenge definitions & values
- `src/js/engine/constants.js` — factory function
- `src/js/models/challenges.js` — new model (create)
- `src/js/models/meta.js` — add challenges property
- `src/js/engine/state.js` — game loop integration, player actions
- `src/js/models/events/event.js` — add dismissable flag
- `src/components/screens/game_screen.vue` — header indicator, sync, modal wiring
- `src/components/modals/challenge_modal.vue` — new modal (create)
- `src/js/i18n/en.js` (+ es, fr, ca, it) — localization keys

## Verification
1. Start new game → first challenge activates immediately
2. Build altar to level 3 → challenge 1 completes, reward granted, past event appears
3. Let a timed challenge expire → punishment applied (resources + workers lost), failure event, next challenge activates
4. Submit a ritual → resources + workers deducted, challenge completes
5. Complete all 8 → win modal appears
6. Save mid-challenge → load → timer persists correctly
7. Run `npm run lint -- --fix` → no errors
