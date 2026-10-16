### [a/logic-errors/tutorial/concurrent-modal-trigger-dropped] A tutorial popup triggered while another is open is dropped, not queued

- **Location:** `src/js/engine/state.js:1354-1363`. Related:
  - `src/components/screens/game_screen.vue:1224-1230`: the progress timers run back to back with no pause check between them, both in the frame loop (`:1298`) and in catch-up. `:1246-1257`: catch-up checks the pause only at the start of each step, not between the production update and the timers.
  - `state.js:248`, `:558`, `:610`, `:703`: the negative-production, season, HQ-upgrade and challenge-started triggers, in the order they run within a step.
  - `src/js/i18n/en.js:441`: camp-specific text.
  - `src/js/models/tutorial.js:37`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low
- **Defect:**
  - When two first-time triggers land in the same frame, or the same background catch-up step (up to 5 s of game time), the later one is neither shown nor recorded.
  - It fires on that event's next occurrence. For the HQ-upgrade popup that is the next HQ upgrade (settlement→village), where its text ("Your camp has been upgraded to a settlement") is wrong.
  - Tutorial completion requires every popup to have been dismissed. Completion, the `tutorial_complete` analytics event and the device-wide "tutorial done" flag therefore wait for the next HQ upgrade. If the player never upgrades the HQ again, they never happen, and a new game started in the meantime replays the tutorial.
  - The HQ popup cannot be dropped on every HQ upgrade. Only the negative-production and season popups are checked before it in a step; the challenge popup is checked after it, so a challenge starting in the same step is the one dropped. Play stays paused until a popup is dismissed, so each of the two can drop it at most once, and it shows by village→town at the latest. In a new game only the season popup is still pending by then, so in practice it shows on settlement→village.
- **Trigger:**
  - The first season change (at 5 min of game time) and the camp→settlement upgrade complete in the same frame (about 17–50 ms of game time, depending on speed), or in the same catch-up step in a hidden tab or on the first frame back from one (1–5 s). Camp→settlement can finish from about 2.5 min and takes 10 s to build, so hitting the 5-min flip is chance.
  - The negative-production variant (a hidden-tab step where `update()` fires that popup and the same step completes the HQ upgrade) does not happen in a new game. That popup fires on the player's first worker assignment, a click about 1 s into play, long before the 300 wood the HQ upgrade costs can be produced.
- **Evidence / verification:**
  - Scratch test: a season flip and an HQ upgrade in one frame left the season popup active, and the HQ popup was neither shown nor recorded as dismissed. With all steps done, the tutorial did not complete. The next HQ upgrade (settlement→village) then showed the camp popup, and only then did the tutorial complete.
  - Scratch test: a 5 s catch-up step with the season flip 3 s in and the HQ upgrade finishing 4.5 s in also dropped the HQ popup.
  - Scratch test: a challenge start and an HQ upgrade in the same frame showed the HQ popup and dropped the challenge popup.
  - Scratch run of fast play from a new game: negative-production popup at 1 s, challenge popup at 30 s, camp→settlement done at 155 s, season popup at 300 s.
  - Refutation: rare, because the two must land in one frame or step. The other popups re-fire naturally.
- **Suggested fix:** Smallest fix: in the per-second tutorial check, show the HQ popup when the HQ is past camp and that popup hasn't been dismissed. It then appears on the first tick after the other popup is dismissed, while its camp→settlement text is still true (scratch-tested; existing engine tests pass). The general fix is a saved queue of pending popups, shown one after another while the game stays paused; it needs de-duplication (food and wood can both fire negative production in one update) and the same load-time check as the active popup. Don't make the HQ trigger camp-only on its own: a dropped popup would then block completion forever.

### [a/boundary-and-encoding-cases/events/event-params-stored-pre-translated] Countdown events keep the language they were created in

- **Location:** `src/js/engine/state.js:694-698` (challenge name). Related: `state.js:1050` (building name), `state.js:1149` (HQ name), `state.js:1252` (research name), `src/js/models/events/event.js:46` (parameters saved verbatim), `state.js:1433-1455` (load restores events unchanged), `src/components/screens/game_screen.vue:1675-1676` (template translated at display time).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs the browser language to change between saving and loading while a construction, research or challenge countdown is running.
- **Defect:** Event parameters are stored as already-translated strings and saved that way, while the event template is translated when displayed. After loading under another browser language, upcoming events show mixed languages, for example "Upgrading granja".
- **Trigger:** Play in Spanish with a construction in progress, save, switch the browser to English, reload, then Continue.
- **Evidence / verification:** Scratch test: a farm build, a woodcutter upgrade, an HQ upgrade, a research and a started challenge created under Spanish, saved, then loaded under English showed "Building granja", "Upgrading leñador", "Upgrading campamento", "Researching rueda" and "Challenge 1/10: Prueba de Devoción". The language is chosen once at startup from the browser language only, with no in-game setting or stored preference (`src/js/i18n/localized.js:21-22`). Saves live only in this browser's local storage. Refutation: only upcoming (countdown) events carry parameters; no past event is created with parameters, and the countdown events are removed when the construction, research or challenge ends, so the mix is temporary.
- **Suggested fix:** When a save is loaded, rebuild the parameters of upcoming events in the current language from what each event already stores: the building key (for the HQ, the name of its current type), the research key, or the challenge number in the first parameter. Lowercase building and research names as at creation, but not challenge names, and skip events without parameters such as territory expansion. The language can only change on a reload, so this alone is complete, needs no save-format change and repairs old saves; a scratch version fixed the test above and passed the existing state and serialization tests. Storing translation keys instead also works but touches the four creation sites and the display, and still needs an old-save fallback.

### [a/boundary-and-encoding-cases/asset-generator/windows-path-separators-drop-images] The asset generator drops every image on Windows

- **Location:** `scripts/generate-assets.js:57` and `:78` (`split('/')`). Related: `scripts/generate-assets.js:44` (`relative()`), `:120` (emitted image path), `:197` (success log).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. Only a contributor running `npm run generate-assets` with Windows Node is affected (WSL runs Linux Node and is not). The docs tell contributors to rerun it after adding or removing any file in `public/` (`docs/javascript.md:24`).
- **Defect:** On Windows, `path.relative()` returns backslash paths, so no image matches a known group. Every `IMG_` constant and both image maps are left out, while the script still reports success and counts the dropped images in its total. Sounds and music are unaffected because their folders are flat. The next build fails on missing exports.
- **Trigger:** Run `npm run generate-assets` on Windows.
- **Evidence / verification:**
  - Simulated, not run on Windows: a repo copy where `relative()` returns Windows-style paths and file names are parsed with the Windows path rules. The generated file kept only the 19 `SND_` and 4 `MUS_` constants and dropped all 51 images. The script exited 0 and logged "74 assets".
  - `vite build` on that copy then failed with 63 `MISSING_EXPORT` errors, for example `IMG_BUILDING_ACADEMY` imported by `src/js/engine/constants.js`.
  - Lint and all 735 tests still pass on that copy, so the lint and test run that `AGENTS.md` asks for after changes does not catch it. Only the build does.
  - `src/js/engine/assets.js` is committed, so this only happens when someone regenerates on Windows. Deploy and `npm run check` run the build, so the broken file cannot ship unnoticed.
  - There is no separator normalization or platform guard (no glob library; it walks folders with `readdirSync`), and the docs do not claim Windows support.
- **Suggested fix:** Normalize the relative path to `/` where it is collected (`:44`), for example `relative(base, full).split(sep).join('/')` with `sep` imported from `node:path`, not just at the two `split('/')` calls. That way the group lookup and the emitted `/img/...` path both use `/`, and sound and music paths are covered too. Simulated with Windows paths, this produces a file identical to the committed one. Normalizing only at the split calls would emit paths like `'/img/other\upgrade.png'`, which is a JavaScript syntax error. Optionally, exit with an error when an image is in a folder with no known group, so a silent drop cannot recur.

### [b/contract-mismatches/documentation/architecture-and-spec-drift] Architecture and spec docs misstate four shipped rules

- **Location:** `docs/architecture.md:247` (autosave "default `true`", interval "clamped"). Related:
  - `docs/architecture.md:96` and `:132`: expansion cost.
  - `docs/architecture.md:205`: worker upkeep.
  - `docs/specs.md:120` and `docs/architecture.md:93` (base card description): downgrade condition.
  - Code: `src/js/engine/storage.js:10` and `:70-93`, `src/js/engine/state.js:1104` and `:1283-1288`, `src/components/buildings/headquarters_card.vue:49-52`, `state.js:141-192` and `:386-391`, `src/components/buildings/base_card.vue:133-144` and `:195`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It affects developers who rely on the docs.
- **Defect:**
  1. Autosave defaults to off, and the stored interval is not clamped when read or written. Only the settings +/- buttons clamp it. The doc says autosave defaults to on and the interval is clamped. The class comment in `storage.js:10` also says values default to enabled. The settings UI correctly shows the autosave switch off.
  2. Expanding territory charges the research-discounted expansion cost, not the plain level-up cost the doc names. The HQ card also shows the discounted cost.
  3. Wood upkeep combines research and season reductions additively, not multiplicatively. The tests assert additive. The same paragraph says upkeep is computed before production. The code computes production rates first (`:141-144`), then upkeep rates (`:150-153`), adds production to stock (`:177-184`), then deducts upkeep (`:189-192`).
  4. The downgrade button also requires the largest single resource in the expansion cost to exceed storage capacity, so it only appears when expanding is impossible (deliberate since 66bccc57). `specs.md` says downgrading is available whenever territory is full. The base card description in `architecture.md` does not mention the downgrade button at all. `architecture.md:131` is accurate: it describes the engine action, which checks only for full territory.
- **Trigger:** Anyone implementing or testing from these docs, for example relying on the documented autosave default.
- **Evidence / verification:** Compared each doc line with the code listed above. Git history shows the autosave doc line (5cfe21e2) never matched the code (3f4ce254). The getter has not changed since. Refutation: in every case the code is internally consistent (UI, engine and tests agree), so the docs are the wrong side. The only code comment that disagrees is the stale `storage.js:10` class comment. Additive wood upkeep is pinned by `tests/engine/state.test.js:2927`; making it multiplicative fails that test. The expansion discount is not effectively tested: the discount test (`:556-572`) only asserts less-or-equal and the expand test (`:4517-4538`) only asserts resources dropped, so removing the discount still passes every expansion test (checked in a scratch copy). The autosave getters (storage is mocked in `state.test.js`) and the downgrade button condition have no tests.
- **Suggested fix:** Update the statements to match the code: autosave default off and no clamping in storage, expansion charging the discounted cost, additive wood stacking and the real upkeep order, and the extra downgrade-button condition in `specs.md:120` and the base card description. Fix the `storage.js:10` comment too. If autosave-on-by-default was the intent, change the getter to treat a missing value as on. Clamping the interval on read is optional hardening and does not depend on that choice.

### [a/boundary-and-encoding-cases/keyboard/escape-key-repeat-toggles-pause] Holding Escape flickers the pause menu open and closed

- **Location:** `src/components/screens/game_screen.vue:1367-1373`. Related: `src/components/screens/game_screen.vue:1390-1418` (pause watcher), `src/js/engine/escape_stack.js:12-18`, `src/components/modals/pause_modal.vue` (registers no Escape handler).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low
- **Defect:** Every auto-repeated Escape key event that reaches the game screen toggles the pause menu. Holding Escape, for example to close several modals, flips the menu repeatedly and leaves it in an arbitrary state. Each flip stops and restarts the game loops and the autosave countdown.
- **Trigger:** Open the research modal and hold Escape for about 1 s. The first press closes the research modal, and every repeat after that toggles the pause menu. Holding Escape with no modal open does the same.
- **Evidence / verification:** Traced. The shared modal Escape stack runs first, in the capture phase. It closes the research modal and stops that event, so the first press does not toggle pause. Once the research modal unmounts, its handler is gone and each repeat reaches the game screen's toggle. Neither handler checks `event.repeat`. Reproduced in headless Chrome: repeated Escape key presses alternated the pause state false, true, false, true, so the menu ends open or closed depending on whether the number of key events was odd or even. No timers leak (after a long hold, production and timers both run at the normal rate) and the autosave time is kept. The 1-second production tick never fires in the short unpaused gaps, so their production is lost while construction and season timers still advance. Measured over a 3 s hold at 1x speed: production got 0 game seconds while the timers advanced about 1.1 s. The loss is small; it scales with game speed (at most 3x). Adding the repeat check in a scratch copy kept the menu in the state set by the first press, and the research modal still closed on the first press without opening the menu.
- **Suggested fix:** Ignore auto-repeated Escape presses (`event.repeat`) in the game screen's pause toggle only. Leave the modal Escape stack as it is, so holding Escape still closes stacked modals one per repeat.

### [a/state-and-lifecycle/market-research-modals/stale-modal-after-building-destroyed] Market and research modals stay usable after a punishment destroys their building

- **Location:** `src/components/modals/market_modal.vue:142-159`. Related: `src/components/modals/research_modal.vue:70-76`, `src/js/engine/state.js:891-905` and `:976-1007`, `src/js/models/buildings/market.js:67`, `src/js/models/buildings/academy.js:61`, `src/components/screens/game_screen.vue:1421-1425` and `:1750-1758`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs four things together:
  - The modal is open when the challenge times out. The game keeps running under these modals, and the failure modal then covers the screen until the player accepts the punishment.
  - A challenge fails with a punishment that removes building levels (challenges 1, 5 and 10: 2, 10 and 30 levels). A failed challenge is retried, so it can fail again.
  - The building is a market or academy that is upgrading. A building that is not upgrading stops at level 1. The market unlocks only at the last headquarters tier (city), the academy at the third (village).
  - The random picks hit that building once per level it has (once at level 1). Each pick is uniform over the eligible buildings, so a level-1 one is hit often (about 65% with nine other eligible buildings and 10 picks).
- **Defect:** These modals do not pause the game, and nothing closes them when a punishment drops a mid-upgrade market or academy to level 0. The punishment is applied when the player accepts the failure modal, which then closes and leaves the old modal in place, although the building card no longer offers it. Afterwards, buy and sell buttons stay enabled and play the exchange sound, but the engine rejects the trade. Research nodes still look available and play the tap sound, but starting them does nothing.
- **Trigger:** Market at level 1 upgrading to level 2, market modal open, challenge 5 fails (volcano, 10 levels lost), the random pick hits the market, and the player accepts the punishment.
- **Evidence / verification:**
  - Traced. Only the challenge detail modal is closed automatically when a challenge resolves. The market and research modals are shown only from their own open flags, and the failure modal opens on top of them.
  - Reproduced with a scratch vitest. A level-3 upgrading market hit by a 10-level punishment ends at level 0 and a sell is rejected. An idle level-1 market stays at level 1. Through the real fail-and-accept flow, a level-1 upgrading market (challenge 5) and academy (challenge 1) end at level 0, and a trade or research that succeeds at level 1 is rejected.
  - Reproduced in headless Chrome with a crafted save (city headquarters, market and academy at level 1 mid-upgrade, challenge 1 seconds from failing). After accepting the punishment, the market modal was still open with every trade button enabled. A sell and a buy each played the exchange sound and left all resources unchanged. In the research modal, clicking an available, affordable node played the tap sound and started nothing. Both building cards had lost their modal buttons.
  - There is no state corruption, because the engine's own checks hold.
- **Suggested fix:** Close the market or research modal when its building's level drops below 1, for example with a watch in the game screen next to the one that closes the challenge detail modal. That alone removes both symptoms. Optionally, also play the trade sound only after the engine accepts the trade. This needs the trade action to report whether it succeeded.
