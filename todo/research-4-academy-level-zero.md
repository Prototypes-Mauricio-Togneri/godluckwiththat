# Research when the Academy drops to level 0

Source: [research.md](./research.md) → TODO item 4: "Decide what happens to active researches when the Academy is downgraded to level 0 — today they keep running and complete".

## Goal

Decide what happens to running research, and to bonuses from completed research, when the Academy reaches level 0, then implement that decision. Three outcomes are wanted: the Academy must stay built for as long as research runs, the involuntary (punishment) case must stay fair, and the player must be able to see what happened.

## Current state

### Ways to reach level 0

Only three statements in the codebase lower a building level, all in `src/js/engine/state.js`. They belong to two paths.

1. **Player downgrade.** `downgradeBuilding()` (`state.js:1087-1107`) does `level -= 1` (`:1100`) and caps workers at the new capacity, which is 0 at level 0. It works only on the 10 buildings in `DOWNGRADABLE_BUILDINGS` (`src/js/engine/constants.js:267-278`, the Academy included), only when territory is full, and never while the building is constructing. The card adds a further condition before it shows the button: the largest resource in the territory expansion cost must exceed the storage cap, meaning the player cannot expand (`src/components/buildings/base_card.vue:140-144`). There is no confirmation: one click applies it (`base_card.vue:156-162`, button at `:195`).
2. **Punishment.** `_applyPunishment()` (`state.js:966-1025`) removes `levels` random levels, one at a time, from eligible downgradable buildings. A building is eligible at level > 1, or at level 1 while constructing. A level-1 building under construction is destroyed: its construction is cancelled with no refund, its workers drop to 0, it goes to `level = 0` and its future event is removed (`:1006-1013`). A plain hit (`:1016`) leaves the construction timer running. So an Academy that is upgrading from level 2 or higher can also reach 0 in a multi-level punishment: one hit takes it from 2 to 1, and a second hit destroys it because it is still constructing. Punishments that remove levels (`src/data/challenges.json`): challenge 1 Crop Failure (2 levels), challenge 5 Volcano (10), challenge 10 Volcano (30). A punishment never destroys a level-1 Academy that is not constructing.

### What happens today at level 0

- **Running research.** `academy.active` is a `Map<key, Research{duration, remainingSeconds}>` (`src/js/models/buildings/academy.js:20-24, 143-162`). `toJSON()` saves it (`:118-134`) and the constructor restores it (`:17-25`). `State.advanceResearch()` (`state.js:620-651`) ticks every entry without checking the level. On completion it calls `academy.complete(key)`, removes the research's future event and plays the completion sound.
- **The Upcoming countdown runs separately.** `startResearch()` (`state.js:1244-1271`) creates a future event for each research, with its own `remainingSeconds`. `State.advanceEvents()` (`:658-663`) calls `Events.advance()` (`src/js/models/events/events.js:218-222`), which calls `EventFuture.advance()` (`event_future.js:29-33`). That chain ticks the event on its own, stops it at 0 and never converts it to a past event. Today the two timers match only because they get the same delta in the same step. If research stopped but its row kept ticking, the row would sit at 0:00.
- **Who drives them.** `advanceProgress()` (`src/components/screens/game_screen.vue:1280-1286`) runs season, then construction, research, challenges and events. The rAF loop calls it, and for background tabs and gaps `catchUp()` (`:1294-1315`) calls it in steps of at most 5 game seconds. Nothing is simulated offline when a save loads: the game resumes from its saved timers. Paused time (modals, pause menu) is never credited.
- **Bonuses.** `completedBonuses()` (`academy.js:88-112`) does not check the level, so every completed bonus keeps applying at level 0.
- **Starting research** is blocked at level 0 (`canResearch()`, `academy.js:60-62`).
- **What the player sees.** At level 0 the Academy card looks unbuilt: grey image, build button only. The research button sits in a card slot that renders only when the building is built (`base_card.vue:215`). The research modal closes itself when the Academy drops below level 1 (`game_screen.vue:1487-1491`). The Upcoming list keeps showing "Researching X" with a running countdown. When it ends, the sound plays, the row disappears and the bonus applies, all without an Academy.

### How other buildings behave at level 0

- **Worker buildings** (farm, mines, temple, Academy): capacity is `level × 5`, so workers drop to 0 and production stops. Production also skips level 0 explicitly (`state.js:450`).
- **Altar:** produces `level × rate` faith, so none at level 0.
- **Market:** refuses trades below level 1 (`src/js/models/buildings/market.js:80`) but keeps its prices, and trading resumes when it is rebuilt. This is the closest precedent: the building stops working and its state is kept.
- No building loses anything except its own construction, and only to a punishment.
- No timer is paused anywhere today. Every countdown ticks at the same rate, and `Events` relies on that to keep the Upcoming list sorted by inserting each new row at its sorted position (`events.js:199-211`, `sortedFuture` at `:182-184`).

## Decisions

### (a) Running research at level 0

| Option                        | What it does                                                                 | What it costs                                                                                                                                                                                                                          |
|-------------------------------|------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Keep running (today)          | Nothing changes                                                              | The Academy only matters at the moment research starts. A player can start every line (up to 15 at once, one per line), then downgrade the Academy to free its slots while all of them finish                                    |
| **Pause until rebuilt to ≥ 1** | Timers freeze at level 0 and resume with the same remaining time once the Academy is back at level 1 | Small: two checks, one sort call and a "Paused" label. Nothing new to save, no resources move                                                                                                                                  |
| Cancel, full refund           | Removes the research and returns its cost                                    | Refunded food, wood, stone and so on are capped at storage, and the downgrade button only appears when storage is already too small, so part of the refund is often silently lost. Downgrade becomes an "undo research" button. Needs refund, cancel and notification code |
| Cancel, partial refund        | Same, but returns a fraction                                                 | Same as above, plus a new balancing number, and a real loss on an involuntary punishment                                                                                                                                              |
| Cancel, no refund             | Removes the research                                                         | Harsh: a Volcano could wipe a tier-5 iron and gold cost on top of the destroyed Academy upgrade, and the downgrade button becomes a trap                                                                                              |

- **Fairness.** The punishment path is involuntary and already costs the Academy upgrade, and pausing takes no resources on top of that. The downgrade path is a deliberate choice to free a slot. With a pause, that choice costs research time, plus the slot needed to rebuild, but never the research itself.
- **Exploits.** Pausing gives no gain and no way to move resources around. Keep-running is the only option the player can exploit: strip the Academy once research has started.
- **Consistency.** A pause matches the market precedent (stops working, keeps its state) and the worker buildings (no output at level 0).
- **Cost.** It is the cheapest option that changes behavior. Because "paused" is worked out from the Academy's level, neither path to level 0 needs touching and nothing has to be saved or migrated.

**Recommendation: pause.** The lead's tentative pick holds up against the code.

A sixth option, blocking the downgrade while research runs, only covers the downgrade path. It is covered under (c).

### (b) Completed bonuses at level 0

| Option                         | What it does                       | What it costs                                                                                                                                                                                                                                                                                                                      |
|--------------------------------|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Keep applying**              | Nothing changes                    | Nothing. Specs call research "permanent bonuses" (`docs/specs.md:296`), and so does the in-game help text (`modal.researchHelp.body`)                                                                                                                                                                                              |
| Suspend until rebuilt to ≥ 1   | All research bonuses are off at level 0 | The code is one line in `completedBonuses()`, but the side effects are large. Losing the Storage bonus lowers the cap, and `update()` cuts stock down to it: a permanent loss, at the very moment the player downgraded because storage was too small. Losing Habitation drops the population cap below the current workers. Losing Expansion raises an expansion cost the player already cannot afford |

The consistency argument for suspending ("other buildings give nothing at level 0") is about a building's ongoing work, such as workers and trading, and pausing research already covers that. Completed research is knowledge already gained. **Recommendation: keep applying.**

### (c) Downgrade warning

No building's downgrade asks for confirmation or warns today.

| Option                                         | What it does                                                                                                                          | What it costs                                                                                                                                                                   |
|------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Nothing                                        | No warning; the Upcoming rows switch to "Paused" right after                                                                          | No code, but the player only learns about the pause after clicking                                                                                                              |
| **Second tooltip line**                        | When the Academy is at level 1 with research running, its downgrade tooltip adds "Active research will pause until rebuilt"          | One computed value and one text key. No extra click. It reuses the multi-line tooltip the level-up button already has. The downgrade tooltip appears after a delay, so a fast click can miss it |
| Confirmation in the game's own `ConfirmModal` (`src/components/modals/confirm_modal.vue`, already used by Clear history, Restart and Quit) | Stops the action until the player confirms                                                                      | One extra click, 3 text keys × 5 locales, and modal state inside `base_card.vue`. This codebase only uses it for destructive actions, and a pause loses nothing                     |
| Block the downgrade while research runs        | Same idea as the existing "not while constructing" rule                                                                               | A stuck player (territory full, cannot expand) cannot free the Academy slot until long researches finish, and the punishment path still needs the pause                         |

**Recommendation: second tooltip line.** The warning should match the consequence, and a pause loses nothing: the research resumes once the Academy is rebuilt.

### (d) How the paused state is shown

At level 0 the research modal is closed and the card's research button is hidden, so the Upcoming list is the only place left that shows research.

| Option                                                                 | What it does                                                                                              | What it costs                                                                                                                                                                                                                                       |
|------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Keep the rows, freeze them, show "Paused" instead of the time**      | Each research row stays in Upcoming with a muted "Paused" label                                           | The player sees each research. "Paused" is worked out from the Academy's level, so nothing new is saved. Frozen rows break the time order of the Upcoming list while other rows keep ticking; this is cosmetic and one re-sort on rebuild fixes it |
| Remove the rows and add one History warning, then re-create the rows on rebuild | Adds "Research paused until the Academy is rebuilt", which clears itself like the storage-cap and territory warnings | The list order stays intact and an existing pattern is reused. It needs code at both level-0 paths and on rebuild, a new event type, and a cleanup on load for old saves. Rows that vanish can read as "research lost"                  |

Optional add-ons for either option: a build-tooltip line at level 0 ("Rebuild to resume N paused researches") and a sentence in `modal.researchHelp.body`. Neither is needed. **Recommendation: keep the rows with a "Paused" label.**

## Implementation steps (pause · keep bonuses · tooltip line · "Paused" label)

1. **Academy getter.** In `src/js/models/buildings/academy.js`, after `canResearch()`:
   ```js
     /**
      * Whether running researches are paused (academy downgraded or destroyed to level 0).
      * @returns {boolean} True while the academy is below level 1
      */
     get isResearchPaused() {
       return this.level < 1
     }
   ```
   Leave `canResearch()` alone. It could reuse the getter, but that refactor is not needed here.

2. **Freeze research timers.** In `State.advanceResearch()` (`state.js:624`):
   ```js
       if (academy.active.size === 0 || academy.isResearchPaused) {
         return
       }
   ```

3. **Freeze the matching Upcoming rows.** Give `Events.advance()` (`events.js:213-222`) a flag. Research rows are recognised by `researchKey`, as `dismissFutureByResearchKey()` and `State._relocalizeFutureEvents()` already do:
   ```js
     /**
      * Decrements remaining seconds on future events.
      * Clamps at 0 — does not auto-convert to past.
      * @param {number} delta - Seconds elapsed since last tick
      * @param {boolean} [researchPaused=false] - Skip research countdowns (academy at level 0)
      */
     advance(delta, researchPaused = false) {
       for (const event of this.future) {
         if (researchPaused && event.researchKey !== null) {
           continue
         }
         event.advance(delta)
       }
     }
   ```
   `State.advanceEvents()` (`state.js:662`) then calls `this.colony.events.advance(delta, this.colony.buildings.academy.isResearchPaused)`. Within a step, construction runs before research and events in `advanceProgress()`, so both checks see the same level. Research and its row therefore always stop and resume together, during catch-up as well.

4. **Restore the list order on rebuild.** Add `Events.sortFuture()`, then update the `sortedFuture` JSDoc (`events.js:177-184`) to say the list can go out of order while research is paused:
   ```js
     /**
      * Re-sorts future events by remaining seconds ascending, after some countdowns
      * stood still while others kept ticking (paused research).
      */
     sortFuture() {
       this.future.sort((first, second) => first.remainingSeconds - second.remainingSeconds)
     }
   ```
   Call it from `advanceConstruction()` by extending the storehouse/house/monument chain (`state.js:591-598`). `BUILDING_ACADEMY` is already imported there:
   ```js
             } else if (key === BUILDING_ACADEMY && building.level === 1) {
               // Paused research resumes; its rows stood still meanwhile, so restore the upcoming order
               this.colony.events.sortFuture()
             }
   ```

5. **Paths to level 0.** No change to `downgradeBuilding()` or `_applyPunishment()`: the pause is worked out from the level. The research modal already closes itself.

6. **Save and load.** Nothing to save or migrate. Research and its row both save their frozen `remainingSeconds`, and the pause is recomputed from the saved level. Older saves with a level-0 Academy and running research load as paused; their rows were in step with the research until then.

7. **UI.** Use the `frontend-design` skill (`docs/ui.md`).
   - `game_screen.vue`, in `syncEvents()` (`:824-842`) and in the "Event countdowns" block of `syncTimers()` (`:530-542`): compute `const researchPaused = state.colony.buildings.academy.isResearchPaused` once, and add `paused: researchPaused && event.researchKey !== null` to each row object.
   - Upcoming row template (`:1743`): when `event.paused` is set, render `t('events.paused')` instead of `formatTime(event.remainingSeconds)`, with a muted modifier class (for example `event-countdown--paused`; colors must use `rgba()`).
   - Optional: skip the "Research timers" block of `syncTimers()` (`:512-527`) while paused (`&& !buildings.academy.isResearchPaused`). The timers are frozen, so rebuilding `ui.academy` 20 times a second is wasted work (`docs/performance.md`).
   - `base_card.vue`: replace the fixed downgrade tooltip (`:195`) with a computed one. For the Academy at level 1 with `ui.academy.activeKeys.size > 0`, it appends `'\n' + t('building.downgradePausesResearch')` and adds the `tooltip--multiline` class, following the `hasMultilineTooltip` pattern (`:123`). `BUILDING_ACADEMY` is already imported.

8. **Text.** Add both keys to all five locale files (`src/js/i18n/en.js`, `es.js`, `fr.js`, `it.js`, `ca.js`) next to their neighbours (`docs/localization.md`). Escape apostrophes with `\'`. The translations below are suggestions to check:

   | Key                                                         | en                                        | es                                                        | fr                                                                   | it                                                            | ca                                                  |
   |-------------------------------------------------------------|-------------------------------------------|-----------------------------------------------------------|----------------------------------------------------------------------|---------------------------------------------------------------|-----------------------------------------------------|
   | `events.paused` (after `events.future`)                     | Paused                                    | En pausa                                                  | En pause                                                             | In pausa                                                      | En pausa                                            |
   | `building.downgradePausesResearch` (after `building.downgrade`) | Active research will pause until rebuilt | La investigación en curso se pausará hasta reconstruirla | Les recherches en cours seront suspendues jusqu\'à la reconstruction | Le ricerche in corso saranno sospese fino alla ricostruzione | La recerca en curs es pausarà fins a reconstruir-la |

   Do not reuse `modal.pause.title`. That is the pause-menu title and reads differently in fr and es.

## Alternatives sketch

- **Keep running:** no code change. Document the behavior in `docs/specs.md` and close the TODO, optionally blocking the downgrade while research runs (see (c)).
- **Cancel with full or partial refund:** add a helper, called after both level-0 statements (`state.js:1012`, `:1100`), that loops over `academy.active`. It refunds `RESEARCH_COSTS[key]` (times a new fraction in `balancing.js`, floored), capping capped resources at the storage limit, then calls `academy.active.delete(key)` and `events.dismissFutureByResearchKey(key)` and adds a History event. The downgrade then really needs the `ConfirmModal`. Add tests for the storage cap.
- **Cancel without refund:** the same helper without the refund. A confirmation becomes mandatory.
- **Suspend bonuses (b):** `completedBonuses()` returns `{}` below level 1, checked before the cache. Both level changes are already followed by `update(0)`. Then decide what happens to stock above the lowered storage cap and to workers above the lowered population cap, and test every place that reads the bonuses: `update`, `expansionCost`, `_constructionDurationMult`, `executeTrade`, `_applyBlessing` and `syncResources` in `game_screen.vue`.
- **Display with a History warning (d, second option):** add a new `EVENT_TYPE_RESEARCH_PAUSED` in `enums.js`. A helper called after both level-0 statements removes the research rows and adds the warning once. When the Academy finishes rebuilding in `advanceConstruction()`, re-create the rows from `academy.active` with the same `addFuture` call as `startResearch()`, and dismiss the warning. `State.fromJSON` drops stale research rows from old saves loaded at level 0. Steps 3 and 4 and the label in step 7 are then not needed.

## Tests

`tests/models/buildings/academy.test.js`, new `describe('isResearchPaused')`:
- true at level 0, false at levels 1 and 3.

`tests/models/events/events.test.js`, in `advance` plus a new `describe('sortFuture')`:
- `advance(5, true)` leaves a row with a `researchKey` unchanged and still ticks a building row.
- `advance(5)` still ticks research rows, so the default behaviour is unchanged.
- `sortFuture()` orders rows by `remainingSeconds` ascending.

`tests/engine/state.test.js`. Build the Academy with `createState({ colonyOverrides: { buildingOverrides: { academy: { level, active: [...] } } } })` as the existing `advanceResearch` tests do. Add its row with `state.colony.events.addFuture({ type: EVENT_TYPE_RESEARCH_COMPLETE, textKey: 'event.researchInProgress', icon: '', researchKey: 'foodProduction1', remainingSeconds: 10 })`. The completion-sound assertion needs `SND_RESEARCH_COMPLETED` added to the assets import.
- `advanceResearch`, level 0: `advanceResearch(100)` on a research with 10 s left leaves it at 10 s, still active, not completed, with no completion sound.
- `advanceResearch`, resume: after setting level 1, the same research counts down from 10 s and completes on time.
- `advanceEvents`, level 0: the research row stays at 10 while a building row ticks. At level 1 both tick.
- `downgradeBuilding`: Academy at level 1, territory full (same setup as the existing downgrade tests), research running. The Academy goes to level 0 with 0 workers, and the research stays active with an unchanged remaining time after `advanceResearch` and `advanceEvents`.
- `_applyPunishment`: the only eligible building is a level-1 constructing Academy (`_constructingKeys.add(BUILDING_ACADEMY)`, `levels: 1`) with research running. It goes to level 0 and the research is neither cancelled nor advanced. Second case: a level-2 constructing Academy with `levels: 2` also reaches 0 (the multi-level path).
- `advanceConstruction`: a level-0 Academy rebuilding (`constructionRemaining: 1`, key in `_constructingKeys`), research running, rows added out of time order. After completion, the research advances again and `events.future` is sorted.
- `toJSON / fromJSON`: a level-0 Academy with research and its row survives `State.fromJSON(state.toJSON())` with both `remainingSeconds` kept. It is still frozen after advancing and resumes once the level is set to 1.
- Bonuses (b): a level-0 Academy with `completed: ['foodProduction1']`, then `update(0)`: `productionMultipliers.food` still includes the +5%.

## Docs to update

- `docs/specs.md`:
  - Research section (after `:307`): new bullet. At level 0, whether from a downgrade or from a punishment destroying an upgrading Academy, running research pauses. Its timer and Upcoming row freeze and show "Paused", and it resumes with the same remaining time at level 1. Completed bonuses keep applying.
  - Downgrade bullet (`:147`): downgrading the Academy to 0 pauses running research.
  - Punishments (`:399`): a destroyed Academy pauses running research.
  - Future events (`:341`): research rows show "Paused" while the Academy is at level 0.
- `docs/architecture.md`:
  - `base_card.vue` (`:97`): second line on the Academy's downgrade tooltip.
  - `advanceResearch` (`:150`): does nothing while paused.
  - Events: `sortedFuture` note (`:188`), `advance(delta, researchPaused)` and `sortFuture()` (`:190`), "Paused" label in the UI paragraph (`:195`).
  - Construction timers (`:215`): Academy completion re-sorts the upcoming rows.
  - Research System model (`:283`): `isResearchPaused`.
- `todo/research.md`: remove the TODO line and add a Design bullet: "**Academy at level 0**: running researches pause and resume when it is rebuilt; completed bonuses stay".
- `docs/testing.md`: the `state.test.js` counts ("42 describe blocks, 256 tests") and the coverage lists for `academy.test.js` and `events.test.js`.

## Verification

1. Targeted runs:
   ```bash
   npx vitest run tests/models/buildings/academy.test.js tests/models/events/events.test.js
   npx vitest run tests/engine/state.test.js -t "advanceResearch|advanceEvents|advanceConstruction|downgradeBuilding|_applyPunishment|toJSON"
   ```
2. `npm run lint:fix`, then fix any remaining errors.
3. `npm test` (full suite, as `AGENTS.md` requires; this also runs `locale_keys.test.js` for the new keys).
4. Manual check (`npm run dev`):
   - Start a research and save from the pause menu.
   - In DevTools, edit localStorage `savedGame`: set `colony.buildings.academy.level` to `0` and `workers` to `0`. Reload and choose Continue.
   - The research row reads "Paused" and does not move.
   - Build the Academy. When construction finishes, the countdown resumes from the same time and the rows are in time order.
   - The downgrade tooltip needs a save with territory full and an expansion cost above the storage cap.

## Out of scope / risks

- **List order while paused.** Frozen rows sit among ticking rows, and new rows are inserted into a list that is no longer sorted, so Upcoming can be slightly out of time order. This is cosmetic and is fixed when the Academy is rebuilt.
- **Catch-up granularity.** If the Academy finishes rebuilding partway through a background catch-up step, research is credited for that whole step (at most 5 game seconds). Every other timer has the same granularity.
- **Trade-off on downgrade.** A player who downgraded the Academy to free its slot has to give a slot back to resume research. This is intended.
- **Planned disasters.** Earthquakes only take levels down to 1 (`todo/disasters.md`). Because the pause is worked out from the Academy's level, it would still apply automatically if that ever changed.
- **Separate TODO.** Prerequisite enforcement in `startResearch()` is tracked on its own in `todo/research.md`.
- **Unrelated spec mismatch.** `docs/specs.md:342` lists "research completed" as a History event, but finishing a research adds no past event (`state.js:636-640`).
