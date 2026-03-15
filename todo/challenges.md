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
    - `resources`: object with resource type keys and amounts granted (can be null)
    - `territory`: number of territory slots granted (can be null)
    - `construction`: percentage decrease to construction time (e.g., 0.5 for 50% faster, can be null)
    - `warm`: fraction of improvement during warm season (e.g., 0.5 for 50% improvement, can be null)
    - `cold`: fraction of improvement during cold season (e.g., 0.5 for 50% improvement, can be null)
  - `punishment`: object of type `Punishment`
    - `type`: see punishment enum
    - `timeout`: duration of the punishment effect (in seconds, can be null for instant effects)
    - `faith`: fraction of stored faith lost (e.g., 0.5 for 50% loss, always 0.5 for now)
    - `productivity`: percentage decrease to productivity (e.g., 0.2 for 20% reduction, can be null)
    - `resources`: fraction of stored bounded resources lost (e.g., 0.3 for 30% loss, can be null)
    - `workers`: number of workers lost (can be null)
    - `levels`: number of building levels lost. For each number, a building is chosen at random and we remove one level from it (it's like a building downgrade). A building can be selected if it is from the `DOWNGRADABLE_BUILDINGS` list AND meets one of these conditions: (a) its level is greater than 1, or (b) its level is 1 and it is currently under construction (in this case, the construction is interrupted — the pending level increment is lost and the building is effectively destroyed). Excess workers above the new capacity are returned to idle. If no eligible buildings remain, the remaining downgrades from this property are skipped.

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