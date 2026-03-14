# Challenges System - Implementation Plan

## Context

The core narrative driver that ties everything together. The gods test the colony's worthiness to pass through the portal. The gods send sequential challenges to prove the player's faith. Completing all challenges is the win condition (portal activates, player goes home). Challenges consume faith and resources, creating tension between economic growth and divine demands.

More context in @docs/specs.md and @docs/architecture.md

## Data structure
- Remove the existing field in Meta: `numberOfChallenges`
- Add a new `challenges` property of type `Challenges` (new class) to Meta, which will contain:
  - `pending`: array of objects of type `Challenge` (new class)
  - `active`: object of type `Challenge` (or null if no active challenge)
  - `completed`: array of objects of type `Challenge`
  - `activeBlessings`: array of objects of type `Blessing` (see below)
  - `activePunishments`: array of objects of type `Punishment` (see below)

- The `Challenge` class will have these properties:
  - `index`: challenge number (starting from 1)
  - `name`: challenge name (string)
  - `status`: challenge lifecycle state — one of `pending` (not yet activated), `activated` (delay counting, player not yet informed), `started` (player informed, timeout counting), `completed`
  - `delay`: time from activation until the player is informed (in seconds)
  - `delayElapsed`: time elapsed since activation (in seconds, counts while status is `activated`)
  - `timeout`: time limit to complete the challenge once started (in seconds)
  - `timeoutElapsed`: time elapsed since started (in seconds, counts while status is `started`)
  - `requirements`: object defining the challenge requirements
    - `faith`: required faith amount — consumed on completion (can be null)
    - `altar`: required altar level — checked only, not consumed (can be null)
    - `temple`: required temple level — checked only, not consumed (can be null)
    - `monument`: required monument level — checked only, not consumed (can be null)
    - `resources`: object with resource type keys and required amounts — consumed on completion (can be null)
    - `workers`: required number of workers — sacrificed on completion: first from idle pool, then randomly unassigned from producer buildings (buildings that can hold workers) (can be null)
  - `blessings`: array of objects of type `Blessing`
    - `type`: see blessing enum
    - `timeout`: duration of the blessing effect (in seconds, can be null for instant effects)
    - `productivity`: percentage increase to productivity (e.g., 0.2 for 20% boost, can be null)
    - `resources`: amount of resources granted (can be null)
    - `territory`: number of territory slots granted (can be null)
    - `construction`: percentage decrease to construction time (e.g., 0.5 for 50% faster, can be null)
    - `warm`: fraction of improvement during warm season (e.g., 0.5 for 50% improvement, can be null)
    - `cold`: fraction of improvement during cold season (e.g., 0.5 for 50% improvement, can be null)
  - `punishment`: object of type `Punishment`
    - `type`: see punishment enum
    - `timeout`: duration of the punishment effect (in seconds, can be null for instant effects)
    - `faith`: fraction of stored faith lost (e.g., 0.5 for 50% loss, always 0.5 for now)
    - `productivity`: percentage decrease to productivity (e.g., 0.2 for 20% reduction, can be null)
    - `resource`: fraction of stored bounded resources lost (e.g., 0.3 for 30% loss, can be null)
    - `worker`: number of workers lost (can be null)
    - `levels`: number of building levels lost. For each number, a building is chosen at random and we remove one level from it (it's like a building downgrade). Only buildings that that have the level bigger than 1 can be selected. Only buildings from the `DOWNGRADABLE_BUILDINGS` list can be selected. If no more buildings cab be selected to downgrade, we skip the remaining number from this property.

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
- **Punishments**: Lose a fraction of stored resources, workers, building levels and 50% of stored faith
- **Recover relic**: Skipped for now (military not implemented)
- **Activation trigger**: First challenge activates immediately when the game starts
- **Non-dismissable**: Challenge countdown events cannot be dismissed by the player

## Challenge Definitions
All defined in @todo/challenges.json

## How it works
1. When the game starts, the first challenge in the list of pending is activated immediately (and it's removed from the pending array).
2. Once a challange is activated, the `delayElapsed` property starts counting up in the game loop. When it reaches the `delay`, the future event is triggered, and the player is notified about the active challenge. This event cannot be dismissed by the player. But it can be clicked to open the challenge modal and see the details of the active challenge.
3. Once the challenge is active, the `timeoutElapsed` property starts counting up in the game loop. The player must meet the requirements before `timeoutElapsed` reaches `timeout`.
4. Once the time limit is reached, it triggers the challenge calculation.
5. If the player meets the requirements, the challenge is moved to the `completed` array, and the requirements are deducted from the colony (e.g., faith, resources, workers). After that, a new modal is shown to the player, showing the available rewards from completing the challenge. While this modal is open, the game is paused. The modal cannot be dismissed by clicking outside or with a close button. The player has to choose one of the available blessings as a reward. Once the player chooses a blessing, the blessing is added to the field `activeBlessings`. If more challenges are available in the pending array, go to step 1. If no more challenges are available, the win modal is shown, announcing that the portal is activated and the player goes home.
6. If the player does not meet the requirements, a new modal is shown explaining what punishment will be applied to the colony. While this modal is open, the game is paused. This modal cannot be dismissed by clicking outside. It only has a button to acknowledge the punishment and continue. Once the player acknowledges, the punishment is applied to the colony (e.g., lose resources, workers, building levels, and 50% of stored faith). This punishment is added to the field `activePunishments`. After that, the challenge is reset (delay and timeout timers are reset to 0), but kept as the active challenge.

## Implementation Steps

### Step 1: Enums (`src/js/engine/enums.js`)
- Challenge status: `CHALLENGE_STATUS_PENDING`, `_ACTIVATED`, `_STARTED`, `_COMPLETED`
- Challenge keys: `CHALLENGE_1` through `CHALLENGE_10`
- Blessing types: `BLESSING_FERTILE_SOIL`, `_FOREST_BLOOM`, `_GIFT_FROM_THE_HEAVENS`, `_HOLY_EXPANSION`, `_RICH_MINES`, `_CELESTIAL_PROSPERITY`, `_RAPID_CONSTRUCTION`, `_FAVORABLE_WEATHER`, `_WISDOM_OF_THE_GODS`, `_BLESSED_MARKETS`
- Punishment types: `PUNISHMENT_CROP_FAILURE`, `_WILDFIRES`, `_PLAGUE`, `_LANDSLIDE`, `_VOLCANO`
- Event types: `EVENT_TYPE_CHALLENGE_STARTED`, `_CHALLENGE_COMPLETED`, `_CHALLENGE_FAILED`

### Step 2: Models (`src/js/models/`)

New `Challenges` class (`src/js/models/challenges.js`, lives on `meta`):
- Properties: `pending` (array of `Challenge`), `active` (`Challenge` or null), `completed` (array of `Challenge`), `activeBlessings` (array of `Blessing`), `activePunishments` (array of `Punishment`)
- Getters: `completedCount`, `totalCount`, `allCompleted`, `progress` (e.g. "3/10")
- Methods: `activate()` (moves first pending to active, sets status to `activated`), `start()` (sets active status to `started`), `complete(blessing)` (moves active to completed, adds blessing to `activeBlessings`), `fail(punishment)` (resets active timers to 0, sets status back to `activated`, adds punishment to `activePunishments`), `advance(delta)` (ticks delay/timeout on active challenge based on status)
- Serialization: `toJSON()` / `fromJSON()`

New `Challenge` class (`src/js/models/challenge.js`):
- Properties: `index`, `name`, `status`, `delay`, `delayElapsed`, `timeout`, `timeoutElapsed`, `requirements`, `blessings` (array of `Blessing`), `punishment` (`Punishment`)
- Methods: `reset()` (resets `delayElapsed` and `timeoutElapsed` to 0, sets status back to `activated`), `toJSON()` / `fromJSON()`

New `Blessing` class (`src/js/models/blessing.js`):
- Properties: `type`, `timeout`, `productivity`, `resources`, `territory`, `construction`
- Methods: `toJSON()` / `fromJSON()`

New `Punishment` class (`src/js/models/punishment.js`):
- Properties: `type`, `timeout`, `faith`, `productivity`, `resource`, `worker`, `levels`
- Methods: `toJSON()` / `fromJSON()`

### Step 3: Balancing (`src/js/engine/balancing.js`)
- `CHALLENGE_DEFINITIONS`: Array of 10 challenge definitions (matching the structure in `@todo/challenges.json`), each with index, name, delay, timeout, requirements, blessings, punishment
- `CHALLENGE_FAITH_LOSS_FRACTION`: 0.5 (50% faith loss on every punishment)

### Step 4: Constants & Meta Update
- `src/js/engine/constants.js`: Import challenge definitions, add `createInitialChallenges()` factory — builds a `Challenges` instance from `CHALLENGE_DEFINITIONS` with all challenges set to `pending` status
- `src/js/models/meta.js`: Replace `numberOfChallenges` with `challenges` property (type `Challenges`), update `toJSON`/`fromJSON`

### Step 5: State Logic (`src/js/engine/state.js`)
- `advanceChallenges(delta)`: Called in `progressTick`. Two-phase timer:
  1. While status is `activated`: increments `delayElapsed`. When `delayElapsed >= delay`, transitions to `started`, fires a non-dismissable future event with timeout countdown
  2. While status is `started`: increments `timeoutElapsed`. When `timeoutElapsed >= timeout`, triggers challenge resolution via `_resolveChallengeTimeout()`
- `_resolveChallengeTimeout()`: Checks if all requirements are met via `_checkRequirements()`. If met → `_completeChallenge()`. If not → `_failChallenge()`
- `_checkRequirements()`: Returns boolean — checks building levels (altar, temple, monument) exist at required level, faith >= required, each resource >= required amount, workers >= required count
- `_completeChallenge()`: Deducts requirements via `_deductRequirements()`, pauses game, shows completion modal with blessing choices. On blessing selection: adds blessing to `activeBlessings` (tracked only — game loop effects not implemented yet). If more pending challenges exist, activates next. If none remain, shows win modal
- `_deductRequirements()`: Deducts faith and resources from colony. Sacrifices workers via `_sacrificeWorkers(count)`
- `_sacrificeWorkers(count)`: Removes workers — first from idle pool (decrements `resources.workers`), then for remaining: picks a random producer building from `DOWNGRADABLE_BUILDINGS` that has workers > 0, decrements its `workers` and `resources.workers`
- `_failChallenge()`: Pauses game, shows failure modal. On acknowledgment: applies punishment via `_applyPunishment()`, resets challenge timers (delay and timeout back to 0, status back to `activated`)
- `_applyPunishment(punishment)`: Removes `CHALLENGE_FAITH_LOSS_FRACTION` (50%) of stored faith. Removes `punishment.resource` fraction of each bounded resource. Kills `punishment.worker` workers via `_sacrificeWorkers()`. Downgrades `punishment.levels` random building levels (picks random building from `DOWNGRADABLE_BUILDINGS` with level > 1, decrements its level, returns excess workers to idle — skips remaining if no eligible buildings). Adds punishment to `activePunishments`

### Step 6: Event Integration
- Challenge activated → no event (player not informed during delay phase)
- Challenge started (delay expired) → `addFuture` with timeout countdown (non-dismissable)
- Challenge completed → convert future to `addPast` success event
- Challenge failed → convert future to `addPast` failure event. After reset, a new future event fires when the delay expires again
- Add `dismissable` flag to `Event` base class (default `true`, challenge events set `false`)

### Step 7: UI - Header Indicator (`game_screen.vue`)
- Challenge progress display in header (e.g., "3/10")
- Clickable to open challenge modal
- Add `syncChallenges()` to sync pattern

### Step 8: UI - Challenge Modal (`src/components/modals/challenge_modal.vue`)
- Active challenge: name, requirements checklist (check/cross icons for met/unmet), countdown timer, progress bar
- Challenge history: completed list with chosen blessing icons
- Overall progress: X/10

### Step 9: UI - Challenge Reward Modal (`src/components/modals/challenge_reward_modal.vue`)
- Shows the blessing choices from the completed challenge
- Player must pick one — modal cannot be dismissed without choosing
- Game is paused while open

### Step 10: UI - Challenge Failure Modal (`src/components/modals/challenge_failure_modal.vue`)
- Shows punishment details that will be applied
- Single "Acknowledge" button — modal cannot be dismissed otherwise
- Game is paused while open

### Step 11: Localization (`src/js/i18n/*.js`)
- Challenge system keys: title, status labels, requirement templates, event messages
- Per-challenge names and descriptions (10 challenges × 5 locales)
- Blessing and punishment type names (10 blessings + 5 punishments × 5 locales)

### Step 12: Win Screen
- Simple modal when `allCompleted = true` announcing the portal activates

## Critical Files
- `src/js/engine/enums.js` — new enums (challenge status, keys, blessing/punishment types, event types)
- `src/js/engine/balancing.js` — challenge definitions & faith loss fraction
- `src/js/engine/constants.js` — `createInitialChallenges()` factory
- `src/js/models/challenges.js` — new `Challenges` container class (create)
- `src/js/models/challenge.js` — new `Challenge` class (create)
- `src/js/models/blessing.js` — new `Blessing` class (create)
- `src/js/models/punishment.js` — new `Punishment` class (create)
- `src/js/models/meta.js` — replace `numberOfChallenges` with `challenges` property
- `src/js/engine/state.js` — game loop integration, challenge resolution, player actions
- `src/js/models/events/event.js` — add `dismissable` flag
- `src/components/screens/game_screen.vue` — header indicator, sync, modal wiring
- `src/components/modals/challenge_modal.vue` — new modal (create)
- `src/components/modals/challenge_reward_modal.vue` — new modal (create)
- `src/components/modals/challenge_failure_modal.vue` — new modal (create)
- `src/js/i18n/en.js` (+ es, fr, ca, it) — localization keys

## Verification
1. Start new game → first challenge activates immediately (status: `activated`, delay counting)
2. Wait for delay to expire → future event appears (non-dismissable), status transitions to `started`, timeout counting
3. Build altar to level 3 before timeout → challenge completes, reward modal shows blessing choices, past event appears
4. Choose a blessing → blessing added to `activeBlessings`, next challenge activates
5. Let a challenge timeout expire without meeting requirements → failure modal shows, punishment applied (resources + workers + faith + building levels lost), challenge resets
6. Fail the same challenge again → punishment stacks (accumulates in `activePunishments`)
7. Complete all 10 → win modal appears
8. Save mid-challenge → load → both delay and timeout timers persist correctly, `activeBlessings` and `activePunishments` persist
9. Run `npm run lint -- --fix` → no errors
