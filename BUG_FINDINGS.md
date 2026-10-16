### [a/null-and-numeric-hazards/economy-formulas/float-product-floored-without-tolerance] Costs, storage cap and market payouts lose one unit to floating-point rounding

- **Location:** `src/js/models/cost.js:74-85` (`multiplyFloor`). Related: `src/js/models/buildings/storehouse.js:24-25`, `src/js/engine/utils.js:58` (`marketTradeQuote`), `src/components/buildings/base_card.vue:82-83`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** High. Every player who does any of the following hits it:
  - Upgrades a temple, iron mine, wall, market, tower, archery or barracks to level 3.
  - Builds storehouse level 3.
  - Sells at the market at certain prices.
- **Defect:** Some results that should be exact whole numbers are computed as floats slightly below the whole number and then floored. They come out one lower than the documented formulas in `specs.md`: `floor(cost × multiplier^level)`, `floor(500 × 1.2^level × (1 + bonus))`, and "sell returns lot prices × 0.70 (rounded down)".
- **Trigger:**
  - Temple at level 2: the level-3 cost is wood 97 / stone 48 instead of 98 / 49, because `Math.pow(1.4, 2)` is `1.9599999999999997`.
  - Storehouse level 3: cap 863 instead of 864.
  - A level-1 market selling 5 lots of food at price 43: a lot total of 170 × 0.7 pays 118 instead of 119.
- **Evidence / verification:**
  - `Math.floor(50 * Math.pow(1.4, 2))` evaluates to 97.
  - Enumerated reachable market states through the real `marketTradeQuote`: base price ± 3k, fee levels 1–26, 1–10 lots. 271 payouts differ from exact integer arithmetic. Most are sells 1 gold short; some are buys 1 gold cheap.
  - The UI and the engine use the same functions, so the shown and charged values agree. The unit tests compute expected values with the same float expressions, so they pass.
  - The refutation pass confirmed the scope. Building costs are affected only at level 2 with ×1.4 multipliers on bases divisible by 25. The storehouse is affected at level 3 (also 1079 instead of 1080 with five Storage tiers).
- **Suggested fix:** Use integer arithmetic where possible, for example `Math.floor(total * (100 ± feePercent) / 100)` in the market quote. Otherwise add a small tolerance before flooring (`Math.floor(x + 1e-9)`) in `multiplyFloor`, `storageCap` and the market quote.

### [b/resource-and-configuration-parity/audio-assets/sound-effects-exceed-bitrate-rule] Six sound effects break the 56 kbps rule

- **Location:** `public/audio/sound/headquarters_upgraded.mp3`. Related: `public/audio/sound/market_exchange.mp3`, `notification_alert.mp3`, `research_completed.mp3`, `territory_expanded.mp3`, `worker_farm.mp3`, `docs/audio.md:3`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** High. Every player downloads these files when audio is preloaded.
- **Defect:** `docs/audio.md` requires sound effects at 56 kbps. These six are variable bitrate: 134, 172, 85, 132, 116 and 122 kbps respectively. They ship about twice as large as the rule allows, roughly 100 KB extra in total.
- **Trigger:** Any game start (audio preload).
- **Evidence / verification:**
  - Measured with `ffprobe` stream bitrates and frame-size histograms. For example, 73 of the 86 frames in `headquarters_upgraded` are 417 bytes, which is 128 kbps.
  - The other 13 sounds are 56 kbps and the 4 music tracks are 96 kbps.
  - Refutation: these six files predate the rule (2026-02-21 to 02-24) and were skipped by the re-encode commits 5b45c52a and e7d88e78. Nothing in the build re-encodes audio.
- **Suggested fix:** Re-encode the six files at a constant 56 kbps.

### [a/state-and-lifecycle/game-loop/pause-transitions-misaccount-time] Closing a tutorial or challenge popup credits up to 3 s of paused time

- **Location:** `src/components/screens/game_screen.vue:1152` (`dismissTutorialModal`). Related:
  - `game_screen.vue:980-987`: the blessing and punishment actions.
  - `game_screen.vue:1207-1211` and `:1238-1240`: the paused branches of the two loops.
  - `game_screen.vue:1137-1144`: the win-continue handler, which does reset correctly.
  - `game_screen.vue:1343-1354`: the pause menu.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. It happens on every tutorial popup and every challenge result, a handful of times per game.
- **Defect:**
  - While paused, the 1 s tick refreshes the loop timestamps only once per second, and the frame loop never refreshes them. Three unpause paths do not reset them: dismissing a tutorial popup, choosing a blessing, and accepting a punishment.
  - The first tick and frame after unpausing therefore credit up to 1 s × game speed (at most 3 s) of paused time. That time goes to production, seasons, construction, research, and challenge and blessing/punishment timers. `specs.md` says effect timers only tick while the game is running.
  - Opening the pause menu drops up to 1 s × speed of production accrued since the last tick, although the frame loop already credited construction and seasons for that time.
- **Trigger:** A tutorial popup opens. 0.9 s after the last paused tick, the player dismisses it. The next frame advances every timer by about 0.9 s × speed that elapsed while the game was paused.
- **Evidence / verification:** Traced. The win-continue handler explicitly resets all three timestamps, which shows the intended contract. The refutation pass confirmed the behavior, with negligible impact per occurrence.
- **Suggested fix:** Add one helper that resets `lastTickTime`, `lastProgressTickTime` and `lastUISyncTime`, and call it from every path that clears `state.paused`. Credit the partial tick before stopping the loops when the pause menu opens.

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

- **Location:** `src/js/i18n/en.js:88`; the same key is at line 88 in `ca.js`, `es.js`, `fr.js` and `it.js`. Related: `src/js/models/buildings/academy.js:60-62`, `src/components/modals/research_modal.vue:39-55`, and the research section of `docs/specs.md`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Every player who opens the research help sees it.
- **Defect:** The help says "Only one research can be active per category." In fact several researches in the same category tab can run at once, one per subcategory chain. `specs.md` and the code both say so.
- **Trigger:** Open Research and press "?". Then start Transportation 1 and Construction 1 together: both run.
- **Evidence / verification:**
  - There is no category check in `canResearch`, `startResearch` or the modal's node-status logic.
  - Refutation: the headquarters help wording ("Each level unlocks new buildings") was also examined. It is defensible, because the HQ level is never shown, so it is excluded.
- **Suggested fix:** Change the sentence to "one per research line (subcategory)" in all five locales.

### [a/logic-errors/perf-overlay/frame-time-uses-scaled-game-delta] Performance overlay shows the wrong frame time at 2x/3x and an inflated FPS after F3

- **Location:** `src/components/screens/game_screen.vue:1282` (`perfFrameTimeSum += delta * 1000`). Related: `game_screen.vue:1270` (stale-data reset), `game_screen.vue:1331-1340` (F3 toggle), `game_screen.vue:1192` (overlay visible by default).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. The overlay is visible to every player by default, and speed 2x/3x is a header control.
- **Defect:**
  - The frame-time sum uses game time multiplied by speed, so "Frame" reads 2–3× the real frame time at 2x/3x: about 33 ms or 50 ms instead of 16.6 ms.
  - The stale-data reset is also speed-scaled, so at 3x it trips on a 334 ms stall.
  - While the overlay is hidden with F3, the counters keep accumulating. Re-enabling resets only the sample start, so the first FPS reading counts every frame since it was hidden.
- **Trigger:** Set speed to 3x and read "Frame". Or press F3 twice, 30 s apart, and read the first FPS.
- **Evidence / verification:** Traced. FPS itself uses real elapsed time, and `docs/performance.md` defines Frame as the average time between frames. The refutation pass confirmed it; gameplay is unaffected.
- **Suggested fix:** Accumulate real elapsed milliseconds between frames, and reset all counters when F3 re-enables the overlay.

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

- **Location:** `src/components/screens/game_screen.vue:1071-1077` (`loadGame`). Related: `src/app.vue:20-31` (new-game fallback), `src/js/engine/state.js:1433-1454` (restoring returns null on any error), `src/js/models/meta.js:38`.
- **Severity:** Low
- **Confidence:** Medium
- **Likelihood:** Low. It needs a save that is valid JSON but cannot be rebuilt: one written 2026-03-07 to 03-14, before saves contained challenges, or after any future format change, since there is no save migration.
- **Defect:**
  - Pause → Load only checks that a save exists, then tears down the current game.
  - When the restore fails, `app.vue` creates a brand-new colony without telling the player, and analytics logs it as a new game.
  - The unreadable save stays in storage, so Continue and Load keep producing new colonies.
- **Trigger:** A save from before 2026-03-14 is in localStorage.
  1. Continue silently starts a new colony (`app.vue` documents this fallback as intended).
  2. The player plays without saving (autosave is off by default).
  3. Pause → Load replaces the current progress with another fresh colony.
- **Evidence / verification:**
  - Scratch test: restoring a current save with its challenges data removed returns null.
  - The saved-game storage key has existed since 66740929 (2026-03-07); challenge data in saves since ef99097b (2026-03-14).
  - Refutation:
    - A save that is not valid JSON reads as null and disables Load.
    - Any save made during the session overwrites the bad one.
    - Load always discards unsaved progress anyway. The defect is the silent failure, where keeping the current game would be expected.
- **Suggested fix:** In `loadGame`, try restoring the save first. If it fails, keep the current game and show a "Load failed" message, optionally offering to delete the unreadable save.

### [a/state-and-lifecycle/modals/keyboard-reaches-controls-behind-blocking-modals] Keyboard input acts on the game behind blocking modals and can unpause under them

- **Location:** `src/components/screens/game_screen.vue:1343-1352`: the pause-menu watch unpauses unconditionally. Related: no modal moves or traps focus (`tutorial_modal.vue` and the challenge success, failure and win modals); the menu button is at `game_screen.vue:1549`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs keyboard use (Enter, Space or Tab) after a mouse click, in a browser that focuses clicked buttons (Chrome and Edge; Firefox on Windows and Linux).
- **Defect:**
  - Overlays block only the mouse. Focus stays on the last clicked game button.
  - Enter or Space then activates that button behind the modal, for example assign worker, level up or game speed.
  - Tab can reach the header menu button and open the pause menu underneath a tutorial popup or a challenge-result modal.
  - Pressing Resume runs the pause watch, which sets `state.paused = false` and restarts the loops while the blocking modal is still on screen.
- **Trigger:**
  1. Click the speed-up button.
  2. Wait for the "Divine challenge" tutorial popup.
  3. Press Enter: speed changes from 2x to 3x.
  4. Tab to the menu button and press Enter, then Tab to Resume and press Enter. The game now runs under the popup.
- **Evidence / verification:**
  - Reproduced in headless Chrome 152 against a local build, in an isolated profile:
    - The speed label went from 2x to 3x after Enter.
    - The pause menu rendered under the tutorial popup.
    - After Resume, the challenge countdown went from 04:59 to 04:50 in 3 s at 3x while the popup was still displayed.
  - Refutation:
    - The blocking modals deliberately swallow Escape, but Tab and Enter are not handled.
    - The same path works under the challenge reward, failure and win modals. There the challenge timers stay frozen, but production, seasons and construction run.
- **Suggested fix:** Move focus into each blocking modal on mount and restore it on unmount, or make the game board `inert` while any modal is open. In the pause watch, unpause only when no tutorial or challenge modal is active.

### [a/state-and-lifecycle/market/blessed-markets-flag-stale-after-expiry] The Blessed Markets 0% fee lasts up to one tick after the blessing expires

- **Location:** `src/js/engine/state.js:133` (the flag is only set in `update()`). Related: `state.js:913-923` (expiry happens in the frame loop), `state.js:1266-1277` (the trade runs before `update`), `src/js/models/buildings/market.js:50-55`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs a trade less than 1 s after the blessing expires.
- **Defect:** The blessing is removed in the frame loop, but the market's fee flag is only refreshed by the next 1 s update. A trade in that window is charged a 0% fee.
- **Trigger:** Choose Blessed Markets (challenge 5 or 10), then buy right after its 120 s timer ends.
- **Evidence / verification:**
  - Scratch test: buying 100 food right after expiry cost 103 gold, against 133 normally.
  - Refutation: the UI quote is also stale, so the player is charged what is shown, and the error favors the player. Other blessing effects are computed live.
- **Suggested fix:** Derive the Blessed Markets state from the active blessings at trade time, or refresh the flag whenever an effect expires.

### [a/logic-errors/tutorial/concurrent-modal-trigger-dropped] A tutorial popup triggered while another is open is dropped, not queued

- **Location:** `src/js/engine/state.js:1354-1363`. Related:
  - `src/components/screens/game_screen.vue:1248-1252` and `:1213-1228`: no pause re-check between steps.
  - `state.js:610`: the HQ-upgrade trigger.
  - `src/js/i18n/en.js:441`: camp-specific text.
  - `src/js/models/tutorial.js:37`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low
- **Defect:**
  - When two first-time triggers land in the same frame, or the same background tick (up to 5 s of game time), the second is neither shown nor recorded.
  - It fires on that event's next occurrence. For the HQ-upgrade popup that is the next HQ upgrade, where its text ("Your camp has been upgraded to a settlement") is wrong.
  - Tutorial completion requires every popup to have been dismissed, so completion and the `tutorial_complete` analytics event are delayed until then. If the drop happens on the last HQ upgrade, they never happen.
- **Trigger:** Either of these:
  - The first season change and the camp→settlement upgrade complete in the same frame.
  - In a hidden tab, the first food-shortage popup fires during `update()` and the same tick completes the HQ upgrade.
- **Evidence / verification:**
  - Scratch test: a season flip and an HQ upgrade in one frame left the season popup active, and the HQ popup was neither shown nor recorded as dismissed.
  - Refutation: rare, because both triggers must be first occurrences in one frame or tick. The other popups re-fire naturally.
- **Suggested fix:** Queue pending tutorial popups and show the next one when the current one is dismissed. Make the HQ text independent of the colony type, or trigger it only for camp→settlement.

### [a/boundary-and-encoding-cases/events/event-params-stored-pre-translated] Countdown events keep the language they were created in

- **Location:** `src/js/engine/state.js:694-698` (challenge name). Related: `state.js:1050` (building name), `state.js:1149` (HQ name), `state.js:1252` (research name), `src/js/models/events/events.js` (saved verbatim).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs the browser language to change between saving and loading.
- **Defect:** Event parameters are stored as already-translated strings and saved that way, while the event template is translated when displayed. After loading under another browser language, upcoming events show mixed languages, for example "Upgrading granja".
- **Trigger:** Play in Spanish with a construction in progress, save, switch the browser to English, reload, then Continue.
- **Evidence / verification:** Traced. The language is chosen once at startup from the browser language (`src/js/i18n/localized.js:21-22`). Refutation: only upcoming (countdown) events carry parameters, and they disappear on completion, so the mix is temporary.
- **Suggested fix:** Store translation keys (building, research and challenge identifiers) as parameters, and translate them when displaying.

### [a/boundary-and-encoding-cases/asset-generator/windows-path-separators-drop-images] The asset generator drops every image on Windows

- **Location:** `scripts/generate-assets.js:57` and `:78` (`split('/')`). Related: `scripts/generate-assets.js:44` (`relative()`), `:200` (success log).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. Only a contributor running `npm run generate-assets` on Windows is affected.
- **Defect:** On Windows, `path.relative()` returns backslash paths, so no image matches a known group. Every `IMG_` constant and both image maps are left out, while the script still reports success. Sounds and music are unaffected because their folders are flat. The next build fails on missing exports.
- **Trigger:** Run `npm run generate-assets` on Windows.
- **Evidence / verification:** Traced; not executed on Windows. There is no separator normalization or platform guard. The refutation pass confirmed it, and the docs do not claim Windows support.
- **Suggested fix:** Normalize paths to `/` before splitting, and fail loudly on unknown groups or duplicate constant names.

### [b/contract-mismatches/documentation/architecture-and-spec-drift] Architecture and spec docs misstate four shipped rules

- **Location:** `docs/architecture.md:247` (autosave "default `true`", interval "clamped"). Related:
  - `docs/architecture.md:96` and `:132`: expansion cost.
  - `docs/architecture.md:205`: wood consumption.
  - `docs/architecture.md:131` and `docs/specs.md:120`: downgrade condition.
  - Code: `src/js/engine/storage.js:70-93`, `src/js/engine/state.js:1104` and `:1283-1288`, `state.js:386-391`, `src/components/buildings/base_card.vue:132-143`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It affects developers who rely on the docs.
- **Defect:**
  1. Autosave defaults to off, and the stored interval is not clamped on read. The doc says autosave defaults to on and the interval is clamped. The settings UI correctly shows "off".
  2. Expanding territory charges the research-discounted expansion cost, not the plain level-up cost the doc names.
  3. Wood upkeep combines research and season reductions additively, not multiplicatively. The tests assert additive.
  4. The downgrade button also requires the expansion cost to exceed storage capacity (deliberate since 66bccc57). The docs say downgrading is available whenever territory is full.
- **Trigger:** Anyone implementing or testing from these docs, for example relying on the documented autosave default.
- **Evidence / verification:** Compared each doc line with the code listed above. Git history shows the autosave doc line (5cfe21e2) never matched the code (3f4ce254). Refutation: in every case the code is internally consistent and tested, so the docs are the wrong side.
- **Suggested fix:** Update the four statements to match the code. If autosave-on-by-default was the intent, change the getter to treat a missing value as on, and clamp the interval when reading it.

### [a/boundary-and-encoding-cases/keyboard/escape-key-repeat-toggles-pause] Holding Escape flickers the pause menu open and closed

- **Location:** `src/components/screens/game_screen.vue:1320-1326`. Related: `src/components/modals/pause_modal.vue` (registers no Escape handler).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low
- **Defect:** Every auto-repeated Escape key event toggles the pause menu. Holding Escape, for example to close several modals, flips the menu repeatedly and leaves it in an arbitrary state, stopping and restarting the loops each time.
- **Trigger:** Open the research modal and hold Escape for about 1 s.
- **Evidence / verification:** Reproduced in headless Chrome: repeated Escape key presses alternated the pause state false, true, false, true. The refutation pass confirmed it; the side effects stay balanced.
- **Suggested fix:** Ignore auto-repeated Escape presses (`event.repeat`) for the pause toggle.

### [a/state-and-lifecycle/market-research-modals/stale-modal-after-building-destroyed] Market and research modals stay usable after a punishment destroys their building

- **Location:** `src/components/modals/market_modal.vue:142-159`. Related: `src/components/modals/research_modal.vue:70-76`, `src/js/engine/state.js:993-1001`, `src/js/models/buildings/market.js:67`, `src/components/screens/game_screen.vue:1373-1377`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs four things together:
  - The modal is open.
  - A challenge fails with a punishment that removes building levels.
  - The random pick hits that building.
  - The building is a level-1 market or academy that is upgrading.
- **Defect:** These modals do not pause the game. Nothing closes them when a punishment drops a level-1, mid-upgrade market or academy to level 0. Afterwards, buy and sell still play the exchange sound but the engine rejects the trade. Research nodes still look available, but starting them does nothing.
- **Trigger:** Market at level 1 upgrading to level 2, market modal open, challenge 5 fails (volcano, 10 levels lost), and the random pick hits the market.
- **Evidence / verification:** Traced. Only the challenge detail modal is closed automatically when a challenge resolves. There is no state corruption, because the engine's own checks hold.
- **Suggested fix:** Close the market and research modals, or disable their actions, when the building's level drops below 1. Play the trade sound only after the engine accepts the trade.
