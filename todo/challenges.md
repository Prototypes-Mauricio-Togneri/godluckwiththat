# Challenges System - Implementation Plan

## Context

The core narrative driver that ties everything together. The gods test the colony's worthiness to pass through the portal. The gods send sequential challenges to prove the player's faith. Completing all challenges is the win condition (portal activates, player goes home). Challenges consume faith and resources, creating tension between economic growth and divine demands.

More context in @docs/specs.md and @docs/architecture.md

## Data structure
- Add a new `challenges` property of type `Challenges` (new class) to Meta, which will contain:
  - `pending`: array of objects of type `Challenge` (new class)
  - `active`: object of type `Challenge` (or null if no active challenge)
  - `completed`: array of objects of type `Challenge`
  - `activeBlessings`: array of objects of type `Blessing` (see below)
  - `activePunishments`: array of objects of type `Punishment` (see below)

- The `Challenge` class will have these properties:
  - `index`: challenge number (starting from 1)
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
    - `resources`: object with resource type keys and amounts granted (can be null)
    - `territory`: number of territory slots granted (can be null)
    - `construction`: percentage decrease to construction time (e.g., 0.5 for 50% faster, can be null)
    - `warm`: fraction of improvement during warm season (e.g., 0.5 for 50% improvement, can be null)
    - `cold`: fraction of improvement during cold season (e.g., 0.5 for 50% improvement, can be null)
  - `punishment`: object of type `Punishment`
    - `type`: see punishment enum
    - `timeout`: duration of the punishment effect (in seconds, can be null for instant effects)
    - `faith`: fraction of stored faith lost (e.g., 0.5 for 50% loss, always 0.5 for now)
    - `productivityFarm`: fraction decrease to farm productivity (e.g., 0.2 for 20% reduction, can be null)
    - `productivityWoodcutter`: fraction decrease to woodcutter productivity (can be null)
    - `productivityMines`: fraction decrease to mining productivity — quarry + all mines (can be null)
    - `productivityGeneral`: fraction decrease to general productivity — all producers (can be null)
    - `resources`: fraction of stored bounded resources lost (e.g., 0.3 for 30% loss, can be null)
    - `workers`: number of workers lost (can be null)
    - `levels`: number of building levels lost. For each number, a building is chosen at random and we remove one level from it (it's like a building downgrade). A building can be selected if it is from the `DOWNGRADABLE_BUILDINGS` list AND meets one of these conditions: (a) its level is greater than 1, or (b) its level is 1 and it is currently under construction (in this case, the construction is interrupted — the pending level increment is lost and the building is effectively destroyed). Excess workers above the new capacity are returned to idle. If no eligible buildings remain, the remaining downgrades from this property are skipped.

## Blessings types

### Instant blessings (effects applied immediately, no ongoing effect)
* `GIFT_FROM_THE_HEAVENS`: Receive a fixed amount of resources
* `HOLY_EXPANSION`: Receives fixed amount of territory slots

### Ongoing blessings (effects applied continuously for a duration)
* `FERTILE_SOIL`: Increases food productivity
* `FOREST_BLOOM`: Increases wood productivity
* `RICH_MINES`: Increases minerals productivity (only if it has mines)
* `WISDOM_OF_THE_GODS`: Increases knowledge productivity (only if it has academy)
* `CELESTIAL_PROSPERITY`: Improves general productivity
* `RAPID_CONSTRUCTION`: Buildings constructed faster
* `FAVORABLE_WEATHER`: Cold season becomes less harsh, warm season becomes more productive
* `BLESSED_MARKETS`: No trading fees (only if it has market)

### Future blessings (not in initial implementation, but design for them now)
* `CELESTIAL_FORTIFICATION`: Buildings more resilient to attacks and disasters (only if it has military)
* `TEMPORARY_PEACE`: No enemy raids (only if it has military)
* `SANCTIFIED_HERO`: Gives a special military unit (only if it has military)
* `DIVINE_PROTECTION`: No natural disasters

## Punishment types
* `CROP_FAILURE`: Reduces food productivity
* `WILDFIRES`: Reduces wood productivity
* `LANDSLIDE`: Reduces mining productivity
* `PLAGUE`: Reduces population
* `VOLCANO`: Reduces productivity, destroys buildings, and reduces population

## Design Decisions

- **Sequential**: One challenge active at a time. Complete/fail → next one activates after a delay
- **Timed**: Challenges have countdown timers
- **Punishments**: Lose a fraction of stored resources, workers, building levels and a fraction of stored faith (defined per-punishment in `challenges.json`)
- **Recover relic**: Skipped for now (military not implemented)
- **Activation trigger**: First challenge activates immediately when the game starts
- **Non-dismissable**: Challenge countdown events are future events, which cannot be dismissed by the player

## Challenge Definitions
All defined in `src/data/challenges.json`

## How it works
1. When the game starts, the first challenge in the list of pending is activated immediately (and it's removed from the pending array).
2. Once a challenge is activated, the `delayElapsed` property starts counting up in the game loop. When it reaches the `delay`, the challenge status transitions to `started`, a future event is triggered, and the player is notified about the active challenge. This event cannot be dismissed by the player. But it can be clicked to open the challenge modal and see the details of the active challenge.
3. Once the challenge is started, the `timeoutElapsed` property starts counting up in the game loop. The player must meet the requirements before `timeoutElapsed` reaches `timeout`.
4. Once the time limit is reached, the game checks whether all requirements are met at that moment.
5. If the player meets the requirements, the challenge is moved to the `completed` array, and the requirements are deducted from the colony (e.g., faith, resources, workers). After that, a new modal is shown to the player, showing the available rewards from completing the challenge. While this modal is open, the game is paused. The modal cannot be dismissed by clicking outside or with a close button. The player has to choose one of the available blessings as a reward. Once the player chooses a blessing, the blessing is added to the field `activeBlessings` (tracked only — effects not applied, see note below). If more challenges are available in the pending array, go to step 1. If no more challenges are available, the win modal is shown, announcing that the portal is activated and the player goes home.
6. If the player does not meet the requirements, a new modal is shown explaining what punishment will be applied to the colony. While this modal is open, the game is paused. This modal cannot be dismissed by clicking outside. It only has a button to acknowledge the punishment and continue. Once the player acknowledges, the punishment is applied to the colony (lose resources, workers, building levels, and 50% of stored faith). The punishment is also added to the field `activePunishments` (tracked only — ongoing effects not applied, see note below). After that, the challenge is reset (delay and timeout timers are reset to 0), but kept as the active challenge.

## Design Rules

- **No stacking**: Two blessings (or punishments) of the same type cannot be active simultaneously. The player will never be offered a blessing that duplicates an already active one (handled by challenge data design — each challenge offers distinct blessing types)
- **Ongoing effect timeouts**: Only tick while the game is running (not during paused/modal states). Use the same `delta` from the game loop
- **RAPID_CONSTRUCTION**: Only affects constructions started while the blessing is active, not constructions already in progress
- **FAVORABLE_WEATHER formula**: Warm season modifiers are amplified by `(1 + warm)`, cold season modifiers are softened by `(1 - cold)`. Examples with `warm = 0.5, cold = 0.5`: warm food modifier `0.2 × 1.5 = 0.3` (+30% instead of +20%), warm wood modifier `-0.2 × 1.5 = -0.3` (-30% instead of -20%), cold food modifier `-0.2 × 0.5 = -0.1` (-10% instead of -20%), cold wood modifier `0.2 × 0.5 = 0.1` (+10% instead of +20%)
- **BLESSED_MARKETS**: Trade fee is 0% while active, overriding market level reduction
- **HOLY_EXPANSION**: Adds to a new `territoryBonus` field on `Resources`, which is added to `headquarters.territoryCap` when computing the effective territory cap. This is analogous to how `storageBonus` and `habitationBonus` work
- **Building downgrade during construction**: When a level-1 building under construction is destroyed, set `constructionRemaining = 0` and level to 0. Dismiss the future event for that construction via `events.dismissFutureByBuildingKey(key)`. Pending territory naturally decreases since `pendingTerritory` counts buildings with active construction
- **Worker sacrifice clamping**: If the colony has fewer total workers than `punishment.workers`, clamp to available workers (don't go negative)

## Implementation Steps

### Step 2a: Infrastructure + Instant Blessings

#### Infrastructure
- Add `territoryBonus` field to `Resources` (default 0, include in `toJSON()` / `fromJSON()`)
- Wire `territoryBonus` into territory cap: in `update()`, effective territory cap = `headquarters.territoryCap + resources.territoryBonus`
- Add timeout decrement logic: in `advanceChallenges(delta)` (or a new method), decrement `timeout` on each entry in `activeBlessings` and `activePunishments` by `delta`. Remove entries whose `timeout` reaches 0

#### Instant Blessings
- `_applyBlessing(blessing)`: Called from `selectBlessing()` (after the player chooses a reward and the blessing is added to `activeBlessings`). Handles instant-only effects:
  - `GIFT_FROM_THE_HEAVENS`: Grants `blessing.resources` amounts to colony resources (capped at storage cap)
  - `HOLY_EXPANSION`: Adds `blessing.territory` to `resources.territoryBonus`

### Step 2b: Ongoing Blessing Effects

Wire into `state.js` — each modifier reads from `meta.challenges.activeBlessings`:

- **Productivity modifiers** (in `update()`, after base production, before season modifiers):
  - `FERTILE_SOIL`: multiply farm production by `(1 + blessing.productivity)`
  - `FOREST_BLOOM`: multiply woodcutter production by `(1 + blessing.productivity)`
  - `RICH_MINES`: multiply quarry + all mine production by `(1 + blessing.productivity)`
  - `CELESTIAL_PROSPERITY`: multiply all producer production by `(1 + blessing.productivity)`
  - `WISDOM_OF_THE_GODS`: multiply academy production by `(1 + blessing.productivity)`
- **Weather** (in `update()`, when applying season modifiers):
  - `FAVORABLE_WEATHER`: multiply warm-season modifiers by `(1 + blessing.warm)`, cold-season modifiers by `(1 - blessing.cold)`
- **Construction speed** (in `levelUpBuilding()` and `expandTerritory()`):
  - `RAPID_CONSTRUCTION`: multiply construction duration by `(1 - blessing.construction)` (e.g., 0.5 → half the time). Only affects new constructions, not in-progress ones
- **Trade fee** (in `Market.executeTrade()` or fee calculation):
  - `BLESSED_MARKETS`: override fee to 0%

### Step 2c: Instant Punishment Effects

- `_applyPunishment(punishment)`: Called from `acknowledgePunishment()` (after the player clicks "Accept Punishment" and the punishment is added to `activePunishments`). Applies all instant effects:
  - Removes `punishment.faith` fraction of stored faith (e.g., 0.5 → lose 50%)
  - Removes `punishment.resources` fraction of each bounded resource (food, wood, stone, copper, iron, gold)
  - Kills `punishment.workers` workers via `_sacrificeWorkers()` (idle first, then randomly unassigned from producers; clamped to available workers)
  - Downgrades `punishment.levels` random building levels: for each level, picks a random building from `DOWNGRADABLE_BUILDINGS` that meets one of these conditions: (a) level > 1, or (b) level == 1 and currently under construction. If (a), decrements the building's level and returns excess workers above new capacity to idle. If (b), sets `constructionRemaining = 0`, level to 0, and dismisses the construction future event. Skips remaining downgrades if no eligible buildings

### Step 2d: Ongoing Punishment Effects

Wire into `state.js` — each modifier reads from `meta.challenges.activePunishments`. Uses the same production modifier system from Step 2b, but subtractive:

- **Productivity modifiers** (in `update()`, same location as blessing modifiers):
  - `CROP_FAILURE`: multiply farm production by `(1 - punishment.productivityFarm)`
  - `WILDFIRES`: multiply woodcutter production by `(1 - punishment.productivityWoodcutter)`
  - `LANDSLIDE`: multiply quarry + all mine production by `(1 - punishment.productivityMines)`
  - Punishments with `productivityGeneral` (PLAGUE, VOLCANO): multiply all producer production by `(1 - punishment.productivityGeneral)`

## Critical Files
- `src/data/challenges.json` — challenge definitions (source data)
- `src/js/engine/enums.js` — new enums (challenge status, keys, blessing/punishment types, event types)
- `src/js/engine/balancing.js` — (no challenge-specific constants; faith loss is per-punishment in `challenges.json`)
- `src/js/engine/constants.js` — `createInitialChallenges()` factory
- `src/js/models/challenges.js` — new `Challenges` container class (create)
- `src/js/models/challenge.js` — new `Challenge` class (create)
- `src/js/models/blessing.js` — new `Blessing` class (create)
- `src/js/models/punishment.js` — new `Punishment` class (create)
- `src/js/models/meta.js` — replace `numberOfChallenges` with `challenges` property
- `src/js/engine/state.js` — game loop integration, challenge resolution, player actions
- `src/js/models/events/event.js` — add `action` field
- `src/components/screens/game_screen.vue` — header indicator, sync, modal wiring
- `src/components/modals/challenge_modal.vue` — new modal (create)
- `src/components/modals/challenge_reward_modal.vue` — new modal (create)
- `src/components/modals/challenge_failure_modal.vue` — new modal (create)
- `src/js/i18n/en.js` (+ es, fr, ca, it) — localization keys