# Challenges System - Implementation Plan

## Context

The core narrative driver that ties everything together. The gods test the colony's worthiness to pass through the portal. The gods send sequential challenges to prove the player's faith. Completing all challenges is the win condition (portal activates, player goes home). Challenges consume faith and resources, creating tension between economic growth and divine demands.

More context in @docs/specs.md and @docs/architecture.md

## Data structure
- Remove the existing field in Meta: `numberOfChallenges`
- Add a new `challenges` property of type `Challenges` (new class) to Meta, which will contain:
  - pending: array of objects of type `Challenge` (new class)
  - active: object of type `Challenge` (or null if no active challenge)
  - completed: array of objects of type `Challenge`
  - activeBlessings: array of objects of type `Blessing` (see below)
  - activePunishments: array of objects of type `Punishment` (see below)

- The `Challenge` class will have these properties:
  - `index`: challenge number (starting from 1)
  - `name`: challenge name (string)
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
  - `blessings`: array of objects of type `Blessing`
    - `type`: see blessing enum
    - `timeout`: duration of the blessing effect (in seconds, can be null for instant effects)
    - `productivity`: percentage increase to productivity (e.g., 0.2 for 20% boost, can be null)
    - `resources`: amount of resources granted (can be null)
    - `territory`: number of territory slots granted (can be null)
    - `construction`: percentage decrease to construction time (e.g., 0.5 for 50% faster, can be null)
  - `punishment`: object of type `Punishment`
    - `type`: see punishment enum
    - `timeout`: duration of the punishment effect (in seconds, can be null for instant effects)
    - `productivity`: percentage decrease to productivity (e.g., 0.2 for 20% reduction, can be null)
    - `resource`: fraction of stored bounded resources lost (e.g., 0.3 for 30% loss, can be null)
    - `worker`: number of workers lost (can be null)

## Blessings types
* `FERTILE_SOIL`: Increases food productivity
* `FOREST_BLOOM`: Increases wood productivity
* `GIFT_FROM_THE_HEAVENS`: Receive a fixed amount of resources
* `HOLY_EXPANSION`: Receives fixed amount of territory slots
* `RICH_MINES`: Increases minerals productivity (only if it has mines)
* `CELESTIAL_PROSPERITY`: Improves general productivity
* `RAPID_CONSTRUCTION`: Buildings constructed faster
* `FAVORABLE_WEATHER`: Cold season becomes less harsh, warm season becomes more productive
* `WISDOM_OF_THE_GODS`: Increases knowledge productivity (only if it has academy)
* `BLESSED_MARKETS`: No trading fees (only if it has market)

## Future blessings (not in initial implementation, but design for them now)
* `CELESTIAL_FORTIFICATION`: Buildings more resilient to attacks and disasters (only if it has military)
* `TEMPORARY_PEACE`: No enemy raids (only if it has military)
* `SANCTIFIED_HERO`: Gives a special military unit (only if it has military)
* `DIVINE_PROTECTION`: No natural disasters

## Punishment types
* `CROP_FAILURE`: Reduces food productivity
* `WILDFIRES`: Reduces wood productivity
* `PLAGUE`: Reduces population
* `LANDSLIDE`: Destroys buildings and reduces population
* `VOLCANO`: Reduces productivity, destroys buildings, and reduces population

## Design Decisions

- **Sequential**: One challenge active at a time. Complete/fail → next one activates after a delay
- **Timed**: Challenges have countdown timers
- **Blessings**: One-time resource grants scaling with difficulty. Some blessings have more probability to appear at the beginning. But less probability to appear in the next one.
- **Punishments**: Lose a fraction of stored resources, workers, building levels and 50% of stored faith
- **Recover relic**: Skipped for now (military not implemented)
- **Activation trigger**: First challenge activates immediately when the game starts
- **Non-dismissable**: Challenge countdown events cannot be dismissed by the player

## Challenge Definitions
All defined in @todo/challanges.json

## How it works
1. When the game starts, the first challenge in the list of pending is activated immediately (and it's removed from the pending array).
2. Once a challange is activated, the `delayElapsed` property starts counting up in the game loop. When it reaches the `delay`, the future event is triggered, and the player is notified about the active challenge. This event cannot be dismissed by the player. But it can be clicked to open the challenge modal and see the details of the active challenge.
3. Once the challenge is active, the `timeoutElapsed` property starts counting up in the game loop. The player must meet the requirements before `timeoutElapsed` reaches `timeout`.
4. Once the time limit is reached, it triggers the challenge calculation.
5. If the player meets the requirements, the challenge is moved to the `completed` array, and the requirements are deducted from the colony (e.g., faith, resources, workers). After that, a new modal is shown to the player, showing the available rewards from completing the challenge. While this modal is open, the game is paused. The modal cannot be dismissed by clicking outside or with a close button. The player has to choose one of the available blessings as a reward. Once the player chooses a blessing, the reward is applied to the colony. If more challenges are available in the pending array, go to step 1. If no more challenges are available, the win modal is shown, announcing that the portal is activated and the player goes home.
6. If the player does not meet the requirements, a new modal is shown explaining what punishment will be applied to the colony. While this modal is open, the game is paused. This modal cannot be dismissed by clicking outside. It only has a button to acknowledge the punishment and continue. Once the player acknowledges, the punishment is applied to the colony (e.g., lose resources, workers, building levels, and 50% of stored faith). After that, the challenge is reset (delay and timeout timers are reset to 0), but kept as the active challenge.

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
