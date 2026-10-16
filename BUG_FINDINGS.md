### [a/null-and-numeric-hazards/economy-formulas/float-product-floored-without-tolerance] Costs, storage cap and market payouts lose one unit to floating-point rounding

- **Location:** `src/js/models/cost.js:74-85` (`multiplyFloor`). Related: `src/js/models/buildings/storehouse.js:24-25`, `src/js/engine/utils.js:58` (`marketTradeQuote`), `src/components/buildings/base_card.vue:82-83`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** High. Every player who does any of the following hits it:
  - Upgrades a quarry to level 2, or a temple, iron mine, wall, market, tower, archery or barracks to level 3.
  - Builds storehouse level 3, or reaches storehouse level 2 with exactly three Storage researches.
  - Trades at the market at certain prices. For 100- and 1,000-unit trades, most cases are buys at a 13%, 15% or 16% fee; some are sells at a 30% fee.
- **Defect:** Some results that should be exact whole numbers are computed as floats slightly below the whole number and then floored. They come out one lower than the documented formulas in `specs.md`: `floor(cost × multiplier^level)`, `floor(500 × 1.2^level × (1 + bonus))`, and the market fee rule ("buy costs lot prices × 1.30, sell returns lot prices × 0.70 (rounded down)", with the fee lowered 1% per market level).
- **Trigger:**
  - Temple at level 2: the level-3 cost is wood 97 / stone 48 instead of 98 / 49, because `Math.pow(1.4, 2)` is `1.9599999999999997`.
  - Quarry at level 1: the level-2 cost is wood 62 instead of 63, because `45 * 1.4` is `62.99999999999999`.
  - Storehouse level 3: cap 863 instead of 864.
  - A level-1 market selling 100 stone at price 93 (reached after nine single sales from 120): the lot total of 90 × 0.7 pays 62 instead of 63.
  - A level-15 market (16% fee) buying 100 food at price 97: 100 × 1.16 costs 115 instead of 116.
- **Evidence / verification:**
  - `Math.floor(50 * Math.pow(1.4, 2))` evaluates to 97.
  - The game only offers trades of 100, 1,000, 10,000 … units (1, 10, 100 … lots). Every whole price from 20 to 1,000 is reachable for at least one resource (including prices rebuilt from the 20 floor). Through the real `marketTradeQuote`, over those prices, fee levels 1–26, and 1 or 10 lots: 115 payouts differ from exact integer arithmetic, all by exactly 1 gold. 98 are buys 1 gold cheap (fees 16%, 15%, 13%). 17 are sells 1 gold short (fees 30% and 7%). Counted again for each resource over its own reachable prices, that is 308 (263 buys, 45 sells). Bigger trades are hit too: 545 cases at 100 lots and 1,451 at 1,000 lots, which also include 17% buys and 6% sells.
  - The UI and the engine use the same functions, so the shown and charged values agree. The unit tests compute expected values with the same float expressions, so they pass.
  - Scope, checked against exact integer arithmetic for all 20 buildings at levels 0–40: building costs differ only for quarry at level 1 and for the seven buildings above at level 2 (×1.4 multiplier on bases divisible by 25). The storehouse differs at level 3 (also 1079 instead of 1080 with five Storage tiers) and at level 2 with three Storage tiers (827 instead of 828).
- **Suggested fix:** Use integer arithmetic where possible, for example `Math.floor(total * (100 ± feePercent) / 100)` in the market quote, with the fee percent passed in or recovered as `Math.round(fee * 100)`. Otherwise add a small tolerance before flooring (`Math.floor(x + 1e-9)`) in `multiplyFloor`, `storageCap` and the market quote. Both versions match exact results for every market price from 20 to 9,999, every fee level (including the 0% blessing) and 1–1,000 lots. The tolerance also matches exact building costs and storage caps up to level 60. Apply the same change to the copied storage formula in `base_card.vue:82-83`, or move the formula into one shared helper that takes the level (the tooltip also needs the next level's cap, so the current `storageCap` method alone does not fit). Otherwise its "+capacity" tooltip will disagree with the real cap.

### [b/resource-and-configuration-parity/audio-assets/sound-effects-exceed-bitrate-rule] Six sound effects break the 56 kbps rule

- **Location:** `public/audio/sound/headquarters_upgraded.mp3`. Related: `public/audio/sound/market_exchange.mp3`, `notification_alert.mp3`, `research_completed.mp3`, `territory_expanded.mp3`, `worker_farm.mp3`, `docs/audio.md:3`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** High. Every game start preloads all sound effects, even with sound turned off (`src/app.vue:21`, `src/js/engine/audio.js:36-43`).
- **Defect:** `docs/audio.md` requires sound effects at 56 kbps. These six are variable bitrate: 134, 172, 85, 132, 116 and 122 kbps respectively. They ship about twice as large as the rule allows, roughly 80 KB extra in total.
- **Trigger:** Any game start (audio preload).
- **Evidence / verification:**
  - Measured with `ffprobe` stream bitrates and frame-size histograms. For example, 73 of the 89 frames in `headquarters_upgraded` are 417 bytes, which is 128 kbps.
  - The six files total 150,511 bytes. Test copies re-encoded at 56 kbps (outside the repo) total 69,199 bytes, so about 81 KB is extra. That is about 1% of the roughly 6.4 MB of audio preloaded at game start, almost all of it music, which is why severity is Low.
  - The other 13 sounds are 56 kbps and the 4 music tracks are 96 kbps.
  - Refutation: these six files predate the rule (content from 2026-02-21 to 02-24; `worker_farm.mp3` is an unchanged 2026-03-01 rename of `worker_food.mp3`). The rule was added on 2026-02-28 (ba49c897, then in `CLAUDE.md`; moved to `docs/audio.md` on 2026-03-21) and the re-encode commits 5b45c52a and e7d88e78 skipped them. Nothing in the build re-encodes audio, and no test checks bitrates.
- **Suggested fix:** Re-encode the six files at a constant 56 kbps, keeping their file names, for example `ffmpeg -i in.mp3 -map_metadata -1 -c:a libmp3lame -b:a 56k out.mp3` (this produced the 69,199-byte test copies).

### [a/state-and-lifecycle/game-loop/pause-transitions-misaccount-time] Closing a tutorial or challenge popup credits up to 3 s of paused time

- **Location:** `src/components/screens/game_screen.vue:1152` (`dismissTutorialModal`). Related:
  - `game_screen.vue:980-987`: the blessing and punishment actions. They clear the pause in `src/js/engine/state.js:881` and `:903`.
  - `game_screen.vue:1264-1268` and `:1283-1286`: the paused branches of the two loops.
  - `game_screen.vue:1137-1144`: the win-continue handler, which does reset the timestamps (no gain, but it keeps the drop described below).
  - `game_screen.vue:1390-1418`: the pause menu.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. It happens on every challenge result (at least 10 in a full game), every pause-menu open, and each of the four one-time tutorial popups (first game only, until the tutorial is completed on that device).
- **Defect:**
  - While paused, the 1 s tick refreshes the loop timestamps only once per second, and the frame loop never refreshes them. Three unpause paths do not reset them: dismissing a tutorial popup, choosing a blessing, and accepting a punishment.
  - The first tick and frame after unpausing therefore credit up to 1 s × game speed (at most 3 s) of paused time. That time goes to production, seasons, construction, research, and challenge and blessing/punishment timers. `specs.md` says effect timers only tick while the game is running.
  - Most of these popups open between ticks. Season change, challenge start and result, and headquarters upgrade come from the frame loop, and the negative-production popup can come from a player action. The first paused tick then overwrites the tick timestamp and drops up to 1 s × speed of production earned before the pause. So production is off by up to ±3 s per popup, while the progress timers only gain.
  - Opening the pause menu drops up to 1 s × speed of production accrued since the last tick, although the frame loop already credited construction and seasons for that time.
- **Trigger:** A tutorial popup opens. 0.9 s after the last paused tick, the player dismisses it. The next frame advances every progress timer, and the next tick adds production, for about 0.9 s × speed that elapsed while the game was paused.
- **Evidence / verification:**
  - Traced. The win-continue handler and the pause-menu close explicitly reset all three timestamps, which shows the intended contract. The other three paths that clear the pause do not.
  - A fake-clock re-run of the real loop code at speed 3, with the pause start and end swept across the tick, confirmed it. Progress timers gain up to about 2.9 s per popup. Production ends between about −2.9 s and +2.9 s, depending on where the pause starts and ends within the tick. With only a reset on unpause, production still comes up to about 3 s short per popup, and each pause-menu open loses up to about 2.9 s. The fix below brought both errors to zero (within one frame for popups opened by a player action).
  - In the same re-run, recording the pause start only at the next paused tick credited 180 game seconds of paused time when the popup fired in a background tab with once-a-minute ticks.
  - The refutation pass confirmed the behavior, with negligible impact per occurrence.
- **Suggested fix:** Freeze the clocks instead of refreshing them. The paused branches of both loops should leave the timestamps alone. Record when the pause began once, using the time of the step that set it: right after the catch-up and progress calls in both loops, at pause-menu open, and otherwise in the paused branches (for popups opened by a player action). One helper, called whenever the pause actually ends (tutorial dismiss with no challenge popup left, blessing, punishment, win-continue and pause-menu close), shifts `lastTickTime` and `lastProgressTickTime` forward by the paused duration and sets `lastUISyncTime` to now. This drops exactly the paused time and keeps the production earned between the last tick and the pause. Recording the start only in the paused branches is not enough: in a background tab, where the tick can fire once a minute, that credits up to a minute × speed of paused time. Resetting the timestamps to now on unpause is not enough either: it removes the gain but keeps the drop before the pause.

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
  - Reproduced with a scratch test in an isolated copy: the cap went from 10 to 11, the warning stayed through 5 normal ticks, and after recruiting the 11th worker the warning count was still 1 and no alert sound played.
  - Storage research does not have this problem: its "limit reached" warnings clear on their own in `update()` once the cap rises (also confirmed by a scratch test). Population is the only cap whose warning is not cleared this way.
  - Refutation: the player can dismiss the line by hand, the next House level-up also clears it, and there is no gameplay effect.
- **Suggested fix:** In `advanceResearch()`, after `update(0)`, dismiss the population-limit event when workers are below `house.workersCap`, using the same check already used after sacrificing or dismissing workers. Running that check in `update()` right after the cap is recomputed also works and covers any future way to raise the cap. No new tracking state is needed, because the warning's presence already serves as that state. Copying the storage-cap pattern would add a flag that has to be saved and loaded. A scratch run of each variant passed the full test suite (737 tests).

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
  - The text is what changed, not the design: the English help said "per subcategory" until commit `5cc6bb82` (2026-02-26) changed en/es/fr to "per category" with no code change. The code had no per-category limit then either, and the later `specs.md` line 264 (added 2026-03-01) says one per subcategory.
  - Refutation: the headquarters help wording ("Each level unlocks new buildings") was also examined. It is defensible, because the HQ level is never shown, so it is excluded.
- **Suggested fix:** In all five locales, change the sentence to say that several researches can run at once, but only one per research line (for example Transportation), because each line's tiers unlock in order.

### [a/logic-errors/perf-overlay/frame-time-uses-scaled-game-delta] Performance overlay shows the wrong frame time at 2x/3x and a wrong first FPS after F3, a pause or a tab switch

- **Location:** `src/components/screens/game_screen.vue:1329` (`perfFrameTimeSum += delta * 1000`). Related: `game_screen.vue:1217` and `game_screen.vue:1293` (`delta` comes from `gameDelta`, which multiplies by game speed), `game_screen.vue:1317` (stale-data reset), `game_screen.vue:1283-1286` (paused frames skip sampling), `game_screen.vue:1244` and `game_screen.vue:1266` (the 1 s tick refreshes `lastProgressTickTime` while the tab is hidden or the game is paused), `game_screen.vue:1378-1387` (F3 toggle), `game_screen.vue:1194` (overlay visible by default).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. The overlay is visible to every player by default, including production builds (the built bundle keeps it on), speed 2x/3x is a header control, and tutorial modals pause the game early on.
- **Defect:**
  - The frame-time sum uses game time multiplied by speed, so "Frame" reads 2–3× the real frame time at 2x/3x: about 33 ms or 50 ms instead of 16.6 ms at 60 Hz.
  - The stale-data reset is also speed-scaled, so at 3x it trips on any frame gap over about 333 ms (500 ms at 2x). At 1x it only trips on gaps over 1 s.
  - The reset misses the other ways sampling stops. Frames during a tutorial or challenge modal (game paused) are skipped but not discarded, and on a short tab switch the 1 s tick keeps `lastProgressTickTime` fresh, so the "resumed" check rarely fires. The first reading afterwards divides the few frames from before by the whole gap: FPS 0–6 at 1x, and at 2x/3x whenever the speed-scaled check does not happen to trip.
  - While the overlay is hidden with F3, the counters keep accumulating. Re-enabling resets only the sample start, so the first FPS reading counts every frame since it was hidden.
- **Trigger:** Set speed to 3x and read "Frame". Or press F3 twice, 30 s apart, and read the first FPS. Or, at 1x, dismiss a tutorial modal or come back from another tab, and read the first FPS.
- **Evidence / verification:** Traced. FPS itself uses real elapsed time, and `docs/performance.md` defines Frame as the average time between frames. A scratch copy of the real loop code on a fake 60 Hz clock read Frame 16.6 / 33.3 / 49.9 ms at 1x / 2x / 3x, and FPS about 1860–1920 on the first reading after F3 hid the overlay for 30 s. After a 30 s pause at 1x the first FPS read 0–2 in 28/28 runs. After 10 s in a background tab (1 s tick still firing, as under normal hidden-tab throttling) it read 0–6 in 27/28 runs. Using the gap since `lastProgressTickTime` fixed Frame and F3 but left the pause and tab-switch readings wrong at every speed, because the 1 s tick also writes that timestamp. The fix below read 60–61 FPS and 16.3–16.6 ms in all these cases. Gameplay is unaffected.
- **Suggested fix:** Keep the time of the previous animation frame in its own variable, updated on every frame including paused ones, and add the real gap since it to the frame-time sum. Replace the `resumed || delta > 1` reset with "that real gap is over 1 s", adding 0 for that frame as today. Also discard the sample while the game is paused, and reset all counters when F3 re-enables the overlay.

### [a/logic-errors/settings/sound-toggle-feedback-inverted] In-game settings plays the tap when muting sound and stays silent when unmuting

- **Location:** `src/components/modals/settings_modal.vue:26-30`. Related: `src/components/screens/settings_screen.vue:23-27`, `src/js/engine/audio.js:50`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Anyone who toggles sound from the pause menu hears it, every time.
- **Defect:** The tap sound plays before sound is enabled or disabled. Turning sound off plays a tap, and turning it on is silent. The home-screen settings do it in the correct order.
- **Trigger:** Pause, open Settings, then toggle Sound effects.
- **Evidence / verification:** The order is visible in the code, and the sound player returns early when sound is disabled. Disabling sound does not stop a tap that has already started, so the mute tap plays in full, and there is no audio-unlock or global click sound that changes this. The home-screen version, added three weeks after the modal, moves the tap after the change for this toggle only, so the modal is the stale copy, not a deliberate choice. A scratch test that runs both components' toggle with a mocked audio element counts 1 tap on mute and 0 on unmute for the modal, and 0 and 1 for the home screen.
- **Suggested fix:** Play the tap after enabling or disabling sound, as `settings_screen.vue` does.

### [a/error-handling/save-load/unreadable-save-silently-replaced-by-new-game] Loading an unreadable save silently starts a new colony

- **Location:** `src/components/screens/game_screen.vue:1071-1077` (`loadGame`). Related: `src/app.vue:20-32` (new-game fallback and analytics), `src/js/engine/state.js:1433-1455` (restoring returns null on any error), `src/js/models/meta.js:38`, `src/js/engine/storage.js:70-76` (autosave default).
- **Severity:** Low
- **Confidence:** Medium
- **Likelihood:** Low. It needs a save that is valid JSON but cannot be rebuilt. Today that means one written between 66740929 and ef99097b (2026-03-07 to 03-14), before saves contained challenges, and no build from that window is known to have reached players. Otherwise it needs a future format change, since there is no save migration.
- **Defect:**
  - Pause → Load only checks that a save exists, then tears down the current game.
  - When the restore fails, `app.vue` creates a brand-new colony without telling the player. Analytics logs it as a new game (by design, per `docs/architecture.md:243`), so failed loads are never recorded.
  - The unreadable save stays in storage, so Continue and Load keep producing new colonies.
- **Trigger:** A save written before ef99097b (2026-03-14) is in localStorage, realistically only in a developer's browser.
  1. Continue silently starts a new colony (`app.vue` documents this fallback as intended).
  2. The player plays without saving (autosave is off by default).
  3. Pause → Load replaces the current progress with another fresh colony.
- **Evidence / verification:**
  - Reproduced with saves written by the old code itself. The current code restores early-game saves from the last commit of each day 2026-03-07 to 03-13, and from 1f421b3e (03-14, just before ef99097b), as null ("Cannot read properties of undefined (reading 'pending')"). Saves from ef99097b and from the last commit of each later day through 10-15 restore, as does a late-game save from the deployed build.
  - The saved-game storage key has existed since 66740929 (2026-03-07); challenge data in saves since ef99097b (2026-03-14).
  - Deployment: the live site still serves the 2026-04-02 build (6d024a2f; Last-Modified 2026-04-02 19:31 GMT, matching the local Firebase deploy cache), which has the same Load and fallback code. The only other deploy on record (2026-02-06) predates saving. The repo cannot rule out a deploy in the 03-07 to 03-14 window.
  - Saves carry a version field, but it has always been 1 (`src/js/engine/constants.js:867`), including across the 03-14 format break, and nothing reads it.
  - In the code, autosave is off by default. `docs/architecture.md:247` wrongly says it defaults to on.
  - Refutation:
    - A save that is not valid JSON reads as null and disables Load.
    - Any save made during the session overwrites the bad one, and Restart deletes it.
    - Load always discards unsaved progress anyway. The defect is the silent failure, where keeping the current game would be expected.
- **Suggested fix:** In `loadGame`, restore the save first and hand the restored game to `app.vue`, so it is rebuilt only once. If it fails, keep the current game and show a "Load failed" message (like the existing "Save Failed" notice), optionally offering to delete the unreadable save.

### [a/state-and-lifecycle/modals/keyboard-reaches-controls-behind-blocking-modals] Keyboard input acts on the game behind blocking modals and can unpause under them

- **Location:** `src/components/screens/game_screen.vue:1398-1416`: when the pause menu closes, the pause-menu watch unpauses and restarts the loops. It checks only for the quit and restart confirmations, not for a tutorial or challenge modal. Both Resume and Save (`game_screen.vue:1014-1017`) close the menu this way. Related: no modal moves or traps focus (`tutorial_modal.vue` and the challenge success, failure and win modals); the menu button is at `game_screen.vue:1596`.
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. Enter or Space only works after a mouse click, in a browser that focuses clicked buttons (Chrome and Edge; Firefox on Windows and Linux). Tab needs no click (except in Safari, which skips buttons on Tab by default), but the player has to navigate on purpose to a pause menu hidden under the popup.
- **Defect:**
  - Overlays block only the mouse. Focus stays on the last clicked game button.
  - Enter or Space then activates that button behind the modal, for example assign worker, level up or game speed.
  - Tab can reach the header menu button and open the pause menu underneath a tutorial popup or a challenge-result modal.
  - Pressing Resume or Save runs the pause watch, which sets `state.paused = false` and restarts the loops while the blocking modal is still on screen. The docs say the game stays paused while these modals are visible.
- **Trigger:**
  1. Start a new game on a device that has not finished the tutorial, and click the speed-up button.
  2. Wait for the "Divine challenge" tutorial popup.
  3. Press Enter: speed changes from 2x to 3x.
  4. Tab to the menu button and press Enter, then Tab to Resume and press Enter. The game now runs under the popup.
- **Evidence / verification:**
  - Reproduced in headless Chrome 152 against a local build, in an isolated profile:
    - The speed label went from 2x to 3x after Enter.
    - The pause menu rendered under the tutorial popup.
    - After Resume, the challenge countdown dropped by 9 s (05:00 to 04:51) in 3 s at 3x while the popup was still displayed.
    - Under the challenge failure modal (reached by editing a save), the season bar stood still, then advanced 1.53% to 3.54% in 3 s at 2x after Resume, and the same after Save, with the modal still displayed.
  - Refutation:
    - Escape cannot cause this. The challenge modals swallow it and the tutorial popup closes on it. No window-level key listener handles Tab, Enter or Space; only the reward modal's blessing cards react to Enter and Space, and only when focused.
    - The pause menu has the same stacking level as the tutorial and challenge modals and comes earlier in the page, so it always renders under them. Settings, opened from that hidden menu, does show on top.
    - The same path works under the challenge reward, failure and win modals. There the challenge timers stay frozen, but production, seasons and construction run.
- **Suggested fix:** While a modal is open, make everything except the topmost modal `inert`, including the header with the menu and speed buttons. Alternatively, move focus into each modal on mount, keep Tab inside it and restore focus on unmount; moving focus alone still lets Tab leave the modal. As a backstop, in the pause watch still restart the loops when the menu closes but leave `state.paused` true while a tutorial or challenge modal is active. If the restart is skipped as well, the game stays frozen after that modal is dismissed.

### [a/state-and-lifecycle/market/blessed-markets-flag-stale-after-expiry] The Blessed Markets 0% fee lasts up to one tick after the blessing expires

- **Location:** `src/js/engine/state.js:133` (the flag is only set in `update()`). Related: `state.js:670` and `state.js:913-923` (expiry happens in the frame loop), `state.js:1266-1277` (the trade runs before `update`), `src/js/models/buildings/market.js:50-55`, `src/components/screens/game_screen.vue:807-819` (the UI fee is copied from the same flag).
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It needs a trade after the blessing expires but before the next 1 s update, a window of 0-1 s of real time at any game speed. Only the first trade benefits, because that trade's own `update(0)` refreshes the flag.
- **Defect:** The blessing is removed in the frame loop, but the market's fee flag is only refreshed by the next 1 s update. A trade in that window is charged a 0% fee.
- **Trigger:** Choose Blessed Markets (challenge 5 or 10), then buy right after its 120 s timer ends.
- **Evidence / verification:**
  - Scratch test at a level-1 market: buying 100 food right after expiry cost 103 gold, against 133 normally. The flag was false again right after that trade. With `update(0)` added on blessing removal in a scratch copy, the same trade cost 133 and the existing state and market tests still passed.
  - Refutation: the UI quote is also stale, so the player is charged what is shown, and the error favors the player. Other blessing effects are computed live. The trade size is whatever the amount selector allows, so the one free trade can be large.
- **Suggested fix:** Refresh the flag when an effect expires (for example call `update(0)` in `advanceChallenges` when a blessing is removed, as research completion does) and re-sync the market fee in the UI at the same moment, for example by adding blessing expiry to the progress loop's full-sync check (`game_screen.vue:1301`). Fixing only the engine side would show a 0% quote while charging the full fee for the same window.

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
