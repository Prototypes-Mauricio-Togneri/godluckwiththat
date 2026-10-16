### [a/null-and-numeric-hazards/economy-formulas/float-product-floored-without-tolerance] Costs, storage cap and market payouts lose one unit to floating-point rounding

- **Location:** `src/js/models/cost.js:74-85` (`multiplyFloor`). Related: `src/js/models/buildings/storehouse.js:24-25`, `src/js/engine/utils.js:58` (`marketTradeQuote`), `src/components/buildings/base_card.vue:82-83`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** High. Every player who does any of the following hits it:
  - Upgrades a quarry to level 2, or a temple, iron mine, wall, market, tower, archery or barracks to level 3.
  - Builds storehouse level 3, or reaches storehouse level 2 with three Storage researches.
  - Trades at the market at certain prices. Most cases are buys at a 13–16% fee; some are sells at a 30% fee.
- **Defect:** Some results that should be exact whole numbers are computed as floats slightly below the whole number and then floored. They come out one lower than the documented formulas in `specs.md`: `floor(cost × multiplier^level)`, `floor(500 × 1.2^level × (1 + bonus))`, and the market fee rule ("buy costs lot prices × 1.30, sell returns lot prices × 0.70 (rounded down)", with the fee lowered 1% per market level).
- **Trigger:**
  - Temple at level 2: the level-3 cost is wood 97 / stone 48 instead of 98 / 49, because `Math.pow(1.4, 2)` is `1.9599999999999997`.
  - Quarry at level 1: the level-2 cost is wood 62 instead of 63, because `45 * 1.4` is `62.99999999999999`.
  - Storehouse level 3: cap 863 instead of 864.
  - A level-1 market selling 100 stone at price 93 (reached after nine single sales from 120): the lot total of 90 × 0.7 pays 62 instead of 63.
  - A level-15 market (16% fee) buying 100 food at price 97: 100 × 1.16 costs 115 instead of 116.
- **Evidence / verification:**
  - `Math.floor(50 * Math.pow(1.4, 2))` evaluates to 97.
  - The game only offers trades of 100, 1,000, 10,000 … units (1, 10, 100 … lots). Through the real `marketTradeQuote`, all reachable prices up to 1,000 (including prices rebuilt from the 20 floor), fee levels 1–26, and 1 or 10 lots: 308 payouts differ from exact integer arithmetic, all by exactly 1 gold. 263 are buys 1 gold cheap (fees 16%, 15%, 13%). 45 are sells 1 gold short (fees 30% and 7%).
  - The UI and the engine use the same functions, so the shown and charged values agree. The unit tests compute expected values with the same float expressions, so they pass.
  - Scope, checked against exact integer arithmetic for all 20 buildings at levels 0–40: building costs differ only for quarry at level 1 and for the seven buildings above at level 2 (×1.4 multiplier on bases divisible by 25). The storehouse differs at level 3 (also 1079 instead of 1080 with five Storage tiers) and at level 2 with three Storage tiers (827 instead of 828).
- **Suggested fix:** Use integer arithmetic where possible, for example `Math.floor(total * (100 ± feePercent) / 100)` in the market quote, with the fee percent passed in or recovered as `Math.round(fee * 100)`. Otherwise add a small tolerance before flooring (`Math.floor(x + 1e-9)`) in `multiplyFloor`, `storageCap` and the market quote. Both versions match exact results for every market price, fee level and 1–1,000 lots. Apply the same change to the copied storage formula in `base_card.vue:82-83`, or call `storageCap` there. Otherwise its "+capacity" tooltip will disagree with the real cap.

### [b/resource-and-configuration-parity/audio-assets/sound-effects-exceed-bitrate-rule] Six sound effects break the 56 kbps rule

- **Location:** `public/audio/sound/headquarters_upgraded.mp3`. Related: `public/audio/sound/market_exchange.mp3`, `notification_alert.mp3`, `research_completed.mp3`, `territory_expanded.mp3`, `worker_farm.mp3`, `docs/audio.md:3`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** High. Every player downloads these files when audio is preloaded.
- **Defect:** `docs/audio.md` requires sound effects at 56 kbps. These six are variable bitrate: 134, 172, 85, 132, 116 and 122 kbps respectively. They ship about twice as large as the rule allows, roughly 80 KB extra in total.
- **Trigger:** Any game start (audio preload).
- **Evidence / verification:**
  - Measured with `ffprobe` stream bitrates and frame-size histograms. For example, 73 of the 89 frames in `headquarters_upgraded` are 417 bytes, which is 128 kbps.
  - The six files total 150,511 bytes. Test copies re-encoded at 56 kbps (outside the repo) total 69,199 bytes, so about 81 KB is extra.
  - The other 13 sounds are 56 kbps and the 4 music tracks are 96 kbps.
  - Refutation: these six files predate the rule (content from 2026-02-21 to 02-24; `worker_farm.mp3` is an unchanged 2026-03-01 rename of `worker_food.mp3`). The rule was added on 2026-02-28 (ba49c897) and the re-encode commits 5b45c52a and e7d88e78 skipped them. Nothing in the build re-encodes audio.
- **Suggested fix:** Re-encode the six files at a constant 56 kbps.

### [a/state-and-lifecycle/game-loop/pause-transitions-misaccount-time] Closing a tutorial or challenge popup credits up to 3 s of paused time

- **Location:** `src/components/screens/game_screen.vue:1152` (`dismissTutorialModal`). Related:
  - `game_screen.vue:980-987`: the blessing and punishment actions. They clear the pause in `src/js/engine/state.js:881` and `:903`.
  - `game_screen.vue:1264-1268` and `:1283-1286`: the paused branches of the two loops.
  - `game_screen.vue:1137-1144`: the win-continue handler, which does reset correctly.
  - `game_screen.vue:1390-1418`: the pause menu.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. It happens on every tutorial popup, every challenge result and every pause-menu open, a handful of times per game.
- **Defect:**
  - While paused, the 1 s tick refreshes the loop timestamps only once per second, and the frame loop never refreshes them. Three unpause paths do not reset them: dismissing a tutorial popup, choosing a blessing, and accepting a punishment.
  - The first tick and frame after unpausing therefore credit up to 1 s × game speed (at most 3 s) of paused time. That time goes to production, seasons, construction, research, and challenge and blessing/punishment timers. `specs.md` says effect timers only tick while the game is running.
  - Most of these popups open between ticks. Season change, challenge start and result, and headquarters upgrade come from the frame loop, and the negative-production popup can come from a player action. The first paused tick then overwrites the tick timestamp and drops up to 1 s × speed of production earned before the pause. So production is off by up to ±3 s per popup, while the progress timers only gain.
  - Opening the pause menu drops up to 1 s × speed of production accrued since the last tick, although the frame loop already credited construction and seasons for that time.
- **Trigger:** A tutorial popup opens. 0.9 s after the last paused tick, the player dismisses it. The next frame advances every timer by about 0.9 s × speed that elapsed while the game was paused.
- **Evidence / verification:**
  - Traced. The win-continue handler and the pause-menu close explicitly reset all three timestamps, which shows the intended contract. The other three paths that clear the pause do not.
  - A fake-clock re-run of the two loops at speed 3 confirmed it. Progress timers gain up to 2.7 s per popup. Production ends between −2.4 s and +2.4 s, depending on where the pause starts and ends within the tick. With only a reset on unpause, production still comes up to 2.7 s short per popup and per pause-menu open.
  - The refutation pass confirmed the behavior, with negligible impact per occurrence.
- **Suggested fix:** Freeze the clocks instead of refreshing them. The paused branches of both loops, and the pause-menu open, should only record when the pause began. One helper, called from every path that clears `state.paused` (including the pause-menu close), shifts `lastTickTime` and `lastProgressTickTime` forward by the paused duration and sets `lastUISyncTime` to now. This drops exactly the paused time and keeps the production earned between the last tick and the pause. Resetting the timestamps to now on unpause is not enough on its own: it removes the gain but keeps the drop before the pause.

### [a/state-and-lifecycle/workers/population-warning-not-cleared-on-cap-increase] "Population limit reached" stays after Habitation research raises the cap

- **Location:** `src/js/engine/state.js:1379-1387` (recruiting adds the warning only if none exists). Related:
  - `state.js:636-643`: research completion runs `update(0)`.
  - `state.js:127`: the cap is recomputed.
  - The warning is only dismissed at `state.js:594-595`, `:834-836` and `:1180-1182`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Any player who completes a Habitation tier while at the population cap is affected.
- **Defect:** The warning is not removed when the cap rises, so the event log keeps saying the limit is reached while recruiting works again. When the player reaches the new cap, no new warning or alert sound fires, because the stale warning still exists.
- **Trigger:** House level 1 (cap 10): recruit to 10 and the warning appears. Complete Habitation 1: the cap becomes 11 but the warning stays. Recruit the 11th worker: no new alert.
- **Evidence / verification:**
  - Reproduced with a scratch test in an isolated copy: the cap went from 10 to 11, the warning stayed, and the warning count was still 1 after recruiting the 11th worker.
  - Refutation: the player can dismiss the line by hand, and there is no gameplay effect.
- **Suggested fix:** In `update()`, dismiss the population-limit event when workers drop below `house.workersCap`, using the same edge detection as the storage-cap events.

### [b/contract-mismatches/localization/research-help-states-wrong-limit] Research help says one research per category; the game allows one per subcategory

- **Location:** `src/js/i18n/en.js:88`; the same key is at line 88 in `ca.js`, `es.js`, `fr.js` and `it.js`. Related: `src/js/models/buildings/academy.js:60-62`, `src/js/engine/state.js:1231-1258`, `src/components/modals/research_modal.vue:39-56`, `docs/specs.md:262-264`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Every player who opens the research help sees it.
- **Defect:** The help says "Only one research can be active per category." All five locales say "per category". In fact several researches in the same category tab can run at once, one per subcategory chain. `specs.md` and the code both say so.
- **Trigger:** Open Research and press "?". Then, in the Colony tab, start Wheel (Transportation tier 1) and Woodworking (Construction tier 1) together: both run.
- **Evidence / verification:**
  - There is no category check in `canResearch`, `startResearch` or the modal's node-status logic. The only limit is per subcategory: the modal locks the next tier until the previous one completes.
  - Scratch test in an isolated copy: with academy level 1 and enough resources, Wheel, Woodworking and Compass (all in the Colony tab) were active at the same time.
  - Refutation: the headquarters help wording ("Each level unlocks new buildings") was also examined. It is defensible, because the HQ level is never shown, so it is excluded.
- **Suggested fix:** In all five locales, change the sentence to say that several researches can run at once, but only one per research line (for example Transportation), because each line's tiers unlock in order.

### [a/logic-errors/perf-overlay/frame-time-uses-scaled-game-delta] Performance overlay shows the wrong frame time at 2x/3x and an inflated FPS after F3

- **Location:** `src/components/screens/game_screen.vue:1329` (`perfFrameTimeSum += delta * 1000`). Related: `game_screen.vue:1217` and `game_screen.vue:1293` (`delta` comes from `gameDelta`, which multiplies by game speed), `game_screen.vue:1317` (stale-data reset), `game_screen.vue:1378-1387` (F3 toggle), `game_screen.vue:1194` (overlay visible by default).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. The overlay is visible to every player by default, including production builds, and speed 2x/3x is a header control.
- **Defect:**
  - The frame-time sum uses game time multiplied by speed, so "Frame" reads 2–3× the real frame time at 2x/3x: about 33 ms or 50 ms instead of 16.6 ms.
  - The stale-data reset is also speed-scaled, so at 3x it trips on any frame gap over about 333 ms (500 ms at 2x). At 1x it only trips on gaps over 1 s.
  - While the overlay is hidden with F3, the counters keep accumulating. Re-enabling resets only the sample start, so the first FPS reading counts every frame since it was hidden.
- **Trigger:** Set speed to 3x and read "Frame". Or press F3 twice, 30 s apart, and read the first FPS.
- **Evidence / verification:** Traced. FPS itself uses real elapsed time, and `docs/performance.md` defines Frame as the average time between frames. A scratch copy of the sampling code read Frame 16.6 / 33.3 / 49.9 ms at 1x / 2x / 3x, and FPS 1920 on the first reading after F3 hid the overlay for 30 s. The refutation pass confirmed it; gameplay is unaffected.
- **Suggested fix:** Add the real gap since the previous frame (`now - lastProgressTickTime`, read before it is updated) to the frame-time sum. On a frame that resumes from a background tab, add 0 as today. Drop the `delta > 1` reset condition, because the resumed check already covers real gaps over 1 s. Reset all counters when F3 re-enables the overlay.

### [a/logic-errors/settings/sound-toggle-feedback-inverted] In-game settings plays the tap when muting sound and stays silent when unmuting

- **Location:** `src/components/modals/settings_modal.vue:26-30`. Related: `src/components/screens/settings_screen.vue:23-27`, `src/js/engine/audio.js:50`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Anyone who toggles sound from the pause menu sees it.
- **Defect:** The tap sound plays before sound is enabled or disabled. Turning sound off plays a tap, and turning it on is silent. The home-screen settings do it in the correct order.
- **Trigger:** Pause, open Settings, then toggle Sound effects.
- **Evidence / verification:** The order is visible in the code, and the sound player returns early when sound is disabled. The refutation pass confirmed it.
- **Suggested fix:** Play the tap after enabling or disabling sound, as `settings_screen.vue` does.

### [a/error-handling/save-load/unreadable-save-silently-replaced-by-new-game] Loading an unreadable save silently starts a new colony

- **Location:** `src/components/screens/game_screen.vue:1071-1077` (`loadGame`). Related: `src/app.vue:20-32` (new-game fallback and analytics), `src/js/engine/state.js:1433-1454` (restoring returns null on any error), `src/js/models/meta.js:38`, `src/js/engine/storage.js:70-76` (autosave default).
- **Severity:** Low
- **Confidence:** Medium
- **Likelihood:** Low. It needs a save that is valid JSON but cannot be rebuilt: one written 2026-03-07 to 03-14, before saves contained challenges, or after any future format change, since there is no save migration.
- **Defect:**
  - Pause → Load only checks that a save exists, then tears down the current game.
  - When the restore fails, `app.vue` creates a brand-new colony without telling the player. Analytics logs it only as a new game, so the failed load is never recorded.
  - The unreadable save stays in storage, so Continue and Load keep producing new colonies.
- **Trigger:** A save from before 2026-03-14 is in localStorage.
  1. Continue silently starts a new colony (`app.vue` documents this fallback as intended).
  2. The player plays without saving (autosave is off by default).
  3. Pause → Load replaces the current progress with another fresh colony.
- **Evidence / verification:**
  - Reproduced with saves written by the old code itself. The current code restores early-game saves from the last commit of each day 2026-03-07 to 03-13 as null ("Cannot read properties of undefined (reading 'pending')"). Saves from ef99097b and from the last commit of each later day through 10-15 restore.
  - The saved-game storage key has existed since 66740929 (2026-03-07); challenge data in saves since ef99097b (2026-03-14).
  - Saves carry a version field, but it has always been 1 (`src/js/engine/constants.js:867`), including across the 03-14 format break, and nothing reads it.
  - In the code, autosave is off by default. `docs/architecture.md:247` wrongly says it defaults to on.
  - Refutation:
    - A save that is not valid JSON reads as null and disables Load.
    - Any save made during the session overwrites the bad one.
    - Load always discards unsaved progress anyway. The defect is the silent failure, where keeping the current game would be expected.
- **Suggested fix:** In `loadGame`, try restoring the save first. If it fails, keep the current game and show a "Load failed" message, optionally offering to delete the unreadable save.

### [a/state-and-lifecycle/modals/keyboard-reaches-controls-behind-blocking-modals] Keyboard input acts on the game behind blocking modals and can unpause under them

- **Location:** `src/components/screens/game_screen.vue:1398-1416`: on Resume, the pause-menu watch unpauses and restarts the loops. It checks only for the quit and restart confirmations, not for a tutorial or challenge modal. Related: no modal moves or traps focus (`tutorial_modal.vue` and the challenge success, failure and win modals); the menu button is at `game_screen.vue:1596`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. Enter or Space only works after a mouse click, in a browser that focuses clicked buttons (Chrome and Edge; Firefox on Windows and Linux). Tab needs no click, but the player has to navigate on purpose.
- **Defect:**
  - Overlays block only the mouse. Focus stays on the last clicked game button.
  - Enter or Space then activates that button behind the modal, for example assign worker, level up or game speed.
  - Tab can reach the header menu button and open the pause menu underneath a tutorial popup or a challenge-result modal.
  - Pressing Resume runs the pause watch, which sets `state.paused = false` and restarts the loops while the blocking modal is still on screen.
- **Trigger:**
  1. Start a new game on a device that has not finished the tutorial, and click the speed-up button.
  2. Wait for the "Divine challenge" tutorial popup.
  3. Press Enter: speed changes from 2x to 3x.
  4. Tab to the menu button and press Enter, then Tab to Resume and press Enter. The game now runs under the popup.
- **Evidence / verification:**
  - Reproduced in headless Chrome 152 against a local build, in an isolated profile:
    - The speed label went from 2x to 3x after Enter.
    - The pause menu rendered under the tutorial popup.
    - After Resume, the challenge countdown went from 04:59 to 04:50 in 3 s at 3x while the popup was still displayed.
  - Refutation:
    - Escape cannot cause this. The challenge modals swallow it and the tutorial popup closes on it. No key listener handles Tab, Enter or Space.
    - All modals share one stacking level and the pause menu comes earlier in the page, so it always renders under the tutorial and challenge modals.
    - The same path works under the challenge reward, failure and win modals. There the challenge timers stay frozen, but production, seasons and construction run.
- **Suggested fix:** While a modal is open, make everything except the topmost modal `inert`, including the header with the menu and speed buttons. Alternatively, move focus into each modal on mount, keep Tab inside it and restore focus on unmount; moving focus alone still lets Tab leave the modal. In the pause watch, still restart the loops on Resume but leave `state.paused` true while a tutorial or challenge modal is active. If the restart is skipped as well, the game stays frozen after that modal is dismissed.

### [a/state-and-lifecycle/market/blessed-markets-flag-stale-after-expiry] The Blessed Markets 0% fee lasts up to one tick after the blessing expires

- **Location:** `src/js/engine/state.js:133` (the flag is only set in `update()`). Related: `state.js:670` and `state.js:913-923` (expiry happens in the frame loop), `state.js:1266-1277` (the trade runs before `update`), `src/js/models/buildings/market.js:50-55`, `src/components/screens/game_screen.vue:807-819` (the UI fee is copied from the same flag).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs a trade less than 1 s of real time after the blessing expires, at any game speed. Only the first trade benefits, because that trade's own `update(0)` refreshes the flag.
- **Defect:** The blessing is removed in the frame loop, but the market's fee flag is only refreshed by the next 1 s update. A trade in that window is charged a 0% fee.
- **Trigger:** Choose Blessed Markets (challenge 5 or 10), then buy right after its 120 s timer ends.
- **Evidence / verification:**
  - Scratch test at a level-1 market: buying 100 food right after expiry cost 103 gold, against 133 normally. The flag was false again right after that trade.
  - Refutation: the UI quote is also stale, so the player is charged what is shown, and the error favors the player. Other blessing effects are computed live. The trade size is whatever the amount selector allows, so the one free trade can be large.
- **Suggested fix:** Refresh the flag when an effect expires (for example call `update(0)` in `advanceChallenges` when a blessing is removed, as research completion does) and re-sync the market fee in the UI at the same moment, for example by adding blessing expiry to the progress loop's full-sync check (`game_screen.vue:1301`). Fixing only the engine side would show a 0% quote while charging the full fee for the same window.

### [a/logic-errors/tutorial/concurrent-modal-trigger-dropped] A tutorial popup triggered while another is open is dropped, not queued

- **Location:** `src/js/engine/state.js:1354-1363`. Related:
  - `src/components/screens/game_screen.vue:1246-1257` and `:1224-1230`: the pause is checked only at the start of each catch-up step. It is not checked between the production update and the progress timers, or between the timers.
  - `state.js:248`, `:558`, `:610`: the negative-production, season and HQ-upgrade triggers.
  - `src/js/i18n/en.js:441`: camp-specific text.
  - `src/js/models/tutorial.js:37`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low
- **Defect:**
  - When two first-time triggers land in the same frame, or the same background catch-up step (up to 5 s of game time), the second is neither shown nor recorded.
  - It fires on that event's next occurrence. For the HQ-upgrade popup that is the next HQ upgrade (settlement→village), where its text ("Your camp has been upgraded to a settlement") is wrong.
  - Tutorial completion requires every popup to have been dismissed. Completion, the `tutorial_complete` analytics event and the device-wide "tutorial done" flag therefore wait for the next HQ upgrade. If the player never upgrades the HQ again, they never happen, and a new game started in the meantime replays the tutorial.
  - The HQ popup cannot be dropped on every HQ upgrade. Each of the other three popups can collide with it at most once, because it must be dismissed before play resumes. There are four HQ upgrades, so the HQ popup shows by town→city at the latest.
- **Trigger:** Either of these:
  - The first season change (at 5 min of game time) and the camp→settlement upgrade complete in the same frame.
  - In a hidden tab, or on the first frame back from one, the first negative-production popup (food or wood) fires during `update()` and the same step completes the HQ upgrade.
- **Evidence / verification:**
  - Scratch test: a season flip and an HQ upgrade in one frame left the season popup active, and the HQ popup was neither shown nor recorded as dismissed. The next HQ upgrade (settlement→village) then showed the camp popup.
  - Scratch test: a 5 s step with negative food production and a completing HQ upgrade left the production popup active and dropped the HQ popup.
  - Refutation: rare, because both triggers must be first occurrences in one frame or step. The other popups re-fire naturally.
- **Suggested fix:** Queue pending tutorial popups, save the queue with the tutorial state, and show the next one when the current one is dismissed, keeping the game paused. Make the HQ text independent of the colony type, or trigger it only for camp→settlement. Without the queue, a camp-only trigger would let a dropped popup block completion forever.

### [a/boundary-and-encoding-cases/events/event-params-stored-pre-translated] Countdown events keep the language they were created in

- **Location:** `src/js/engine/state.js:694-698` (challenge name). Related: `state.js:1050` (building name), `state.js:1149` (HQ name), `state.js:1252` (research name), `src/js/models/events/event.js:46` (parameters saved verbatim), `src/components/screens/game_screen.vue:1675-1676` (template translated at display time).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs the browser language to change between saving and loading.
- **Defect:** Event parameters are stored as already-translated strings and saved that way, while the event template is translated when displayed. After loading under another browser language, upcoming events show mixed languages, for example "Upgrading granja".
- **Trigger:** Play in Spanish with a construction in progress, save, switch the browser to English, reload, then Continue.
- **Evidence / verification:** Traced. The language is chosen once at startup from the browser language only, with no in-game setting or stored preference (`src/js/i18n/localized.js:21-22`). Saves live only in this browser's local storage. Refutation: only upcoming (countdown) events carry parameters; no past event is created with parameters, and the countdown events are removed when the construction, research or challenge ends, so the mix is temporary.
- **Suggested fix:** Store translation keys (building, research and challenge identifiers; for the HQ, the key of its current type) as parameters, and translate and lowercase them when displaying. Old saves still hold translated text in these parameters, so fall back to the stored text when it is not a known key, or rebuild the names from the building and research keys the events already carry.

### [a/boundary-and-encoding-cases/asset-generator/windows-path-separators-drop-images] The asset generator drops every image on Windows

- **Location:** `scripts/generate-assets.js:57` and `:78` (`split('/')`). Related: `scripts/generate-assets.js:44` (`relative()`), `:120` (emitted image path), `:197` (success log).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. Only a contributor running `npm run generate-assets` on Windows is affected.
- **Defect:** On Windows, `path.relative()` returns backslash paths, so no image matches a known group. Every `IMG_` constant and both image maps are left out, while the script still reports success and counts the dropped images in its total. Sounds and music are unaffected because their folders are flat. The next build fails on missing exports.
- **Trigger:** Run `npm run generate-assets` on Windows.
- **Evidence / verification:**
  - Simulated, not run on Windows: a repo copy with the relative paths rewritten to Windows form. The generated file kept only the 19 `SND_` and 4 `MUS_` constants and dropped all 51 images. The script exited 0 and logged "74 assets".
  - `vite build` on that copy then failed with `MISSING_EXPORT` errors, for example `IMG_BUILDING_ACADEMY` imported by `src/js/engine/constants.js`.
  - `src/js/engine/assets.js` is committed, so this only happens when someone regenerates on Windows. Deploy runs the build first, so the broken file cannot ship unnoticed.
  - There is no separator normalization or platform guard, and the docs do not claim Windows support.
- **Suggested fix:** Normalize the relative path to `/` where it is collected (`:44`), not just at the two `split('/')` calls. That way the group lookup and the emitted `/img/...` path both use `/`. Normalizing only at the split calls would emit paths like `'/img/other\upgrade.png'`, which is a JavaScript syntax error. Also fail loudly on unknown groups or duplicate constant names.

### [b/contract-mismatches/documentation/architecture-and-spec-drift] Architecture and spec docs misstate four shipped rules

- **Location:** `docs/architecture.md:247` (autosave "default `true`", interval "clamped"). Related:
  - `docs/architecture.md:96` and `:132`: expansion cost.
  - `docs/architecture.md:205`: worker upkeep.
  - `docs/specs.md:120` and `docs/architecture.md:93` (base card description): downgrade condition.
  - Code: `src/js/engine/storage.js:10` and `:70-93`, `src/js/engine/state.js:1104` and `:1283-1288`, `state.js:141-153` and `:386-391`, `src/components/buildings/base_card.vue:133-144`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It affects developers who rely on the docs.
- **Defect:**
  1. Autosave defaults to off, and the stored interval is not clamped when read or written. Only the settings +/- buttons clamp it. The doc says autosave defaults to on and the interval is clamped. The class comment in `storage.js:10` also says values default to enabled. The settings UI correctly shows the autosave switch off.
  2. Expanding territory charges the research-discounted expansion cost, not the plain level-up cost the doc names. The HQ card also shows the discounted cost.
  3. Wood upkeep combines research and season reductions additively, not multiplicatively. The tests assert additive. The same paragraph says upkeep is computed before production. The code computes production rates first, adds production to stock, then deducts upkeep.
  4. The downgrade button also requires the expansion cost to exceed storage capacity (deliberate since 66bccc57). `specs.md` says downgrading is available whenever territory is full. The base card description in `architecture.md` does not mention the downgrade button at all. `architecture.md:131` is accurate: it describes the engine action, which checks only for full territory.
- **Trigger:** Anyone implementing or testing from these docs, for example relying on the documented autosave default.
- **Evidence / verification:** Compared each doc line with the code listed above. Git history shows the autosave doc line (5cfe21e2) never matched the code (3f4ce254). The getter has not changed since. Refutation: in every case the code is internally consistent and matches its own comments, so the docs are the wrong side. Expansion cost and additive wood upkeep are covered by tests in `tests/engine/state.test.js`. The autosave getters and the downgrade button condition have no tests.
- **Suggested fix:** Update the statements to match the code: autosave default off and no clamping in storage, expansion charging the discounted cost, additive wood stacking and the real upkeep order, and the extra downgrade-button condition in `specs.md:120` and the base card description. Fix the `storage.js:10` comment too. If autosave-on-by-default was the intent, change the getter to treat a missing value as on. Clamping the interval on read is optional hardening and does not depend on that choice.

### [a/boundary-and-encoding-cases/keyboard/escape-key-repeat-toggles-pause] Holding Escape flickers the pause menu open and closed

- **Location:** `src/components/screens/game_screen.vue:1367-1373`. Related: `src/components/screens/game_screen.vue:1390-1418` (pause watcher), `src/js/engine/escape_stack.js:12-18`, `src/components/modals/pause_modal.vue` (registers no Escape handler).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low
- **Defect:** Every auto-repeated Escape key event that reaches the game screen toggles the pause menu. Holding Escape, for example to close several modals, flips the menu repeatedly and leaves it in an arbitrary state. Each flip stops and restarts the game loops and the autosave countdown.
- **Trigger:** Open the research modal and hold Escape for about 1 s. The first press closes the research modal, and every repeat after that toggles the pause menu. Holding Escape with no modal open does the same.
- **Evidence / verification:** Traced. The shared modal Escape stack runs first, in the capture phase. It closes the research modal and stops that event, so the first press does not toggle pause. Once the research modal unmounts, its handler is gone and each repeat reaches the game screen's toggle. Neither handler checks `event.repeat`. Reproduced in headless Chrome: repeated Escape key presses alternated the pause state false, true, false, true. No timers leak and the autosave time is kept. The 1-second production tick never fires in the short unpaused gaps, so their production is lost while construction and season timers still advance. The loss is small.
- **Suggested fix:** Ignore auto-repeated Escape presses (`event.repeat`) in the game screen's pause toggle only. Leave the modal Escape stack as it is, so holding Escape still closes stacked modals one per repeat.

### [a/state-and-lifecycle/market-research-modals/stale-modal-after-building-destroyed] Market and research modals stay usable after a punishment destroys their building

- **Location:** `src/components/modals/market_modal.vue:142-159`. Related: `src/components/modals/research_modal.vue:70-76`, `src/js/engine/state.js:976-1007`, `src/js/models/buildings/market.js:67`, `src/js/models/buildings/academy.js:61`, `src/components/screens/game_screen.vue:1421-1425` and `:1750-1758`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs four things together:
  - The modal is open.
  - A challenge fails with a punishment that removes building levels (challenges 1, 5 and 10: 2, 10 and 30 levels).
  - The building is a market or academy that is upgrading. A building that is not upgrading stops at level 1.
  - The random picks hit that building once per level it has (once at level 1).
- **Defect:** These modals do not pause the game. Nothing closes them when a punishment drops a mid-upgrade market or academy to level 0. Afterwards, buy and sell still play the exchange sound but the engine rejects the trade. Research nodes still look available, but starting them does nothing.
- **Trigger:** Market at level 1 upgrading to level 2, market modal open, challenge 5 fails (volcano, 10 levels lost), and the random pick hits the market.
- **Evidence / verification:**
  - Traced. Only the challenge detail modal is closed automatically when a challenge resolves. The market and research modals are shown only from their own open flags, and the failure modal opens on top of them.
  - Reproduced with a scratch vitest. A level-3 upgrading market hit by a 10-level punishment ends at level 0 and a sell is rejected. An idle level-1 market stays at level 1.
  - There is no state corruption, because the engine's own checks hold.
- **Suggested fix:** Close the market and research modals, or disable their actions, when the building's level drops below 1. Play the trade sound only after the engine accepts the trade. This needs the trade action to report whether it succeeded.
