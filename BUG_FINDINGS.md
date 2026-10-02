# Bug Findings

## Medium

### [a/state-and-lifecycle/challenges/punishment-object-shared-with-active-list] Repeated challenge failure applies a 0-second productivity punishment

- **Location:** `src/js/models/challenges.js:82`; related `src/js/engine/state.js:895`, `src/js/engine/state.js:913`, `src/components/screens/game_screen.vue:893`, `src/components/modals/challenge_failure_modal.vue:68`
- **Severity:** Medium
- **Confidence:** High
- **Likelihood:** Medium. Failing the same challenge twice in one session is a normal path for a struggling player, and every punishment with a duration is affected (challenges 1, 2, 4, 5, 6, 7, 9, 10).
- **Defect:** On failure, the challenge's own punishment object, not a copy, is pushed into the list of active punishments. The per-frame countdown mutates that shared object's `timeout` down to 0 and removes it. Nothing restores the duration when the challenge resets. Every later failure of the same challenge therefore pushes a punishment whose duration is already 0, and the next frame removes it. The timed productivity penalty (crop failure, wildfires, landslide, volcano) never applies. The failure modal also announces it as lasting "0 min". The partially or fully drained duration is saved, so the corruption survives reloads.
- **Trigger:** Fail challenge 1 (120 s crop failure) and acknowledge it. Play through the 30 s delay and 300 s timeout of the retry, by which point the punishment has expired. Fail it again.
- **Evidence / verification:** Reproduced with an isolated test in a disposable copy of the project, driving `advanceChallenges` and `acknowledgePunishment` on a fresh State. The first failure's punishment timeout was 120. The second failure's modal saw timeout 0, and the active list was empty after one 16 ms frame. Refutation: no copy is made in `Challenges.fail`, `State.acknowledgePunishment`, `Challenge.reset` or `createInitialChallenges`. Only a reload creates separate objects, and by then the drained timeout has already been saved. Existing tests cover only a single failure.
- **Suggested fix:** Push a fresh copy of the punishment when a challenge fails (e.g. `Punishment.fromJSON(punishment.toJSON())`). Never mutate the challenge's template punishment. Do the same for blessings for consistency.

### [b/validation-and-coercion/market/zero-fee-round-trip-arbitrage] Buying then selling under Blessed Markets creates gold from nothing

- **Location:** `src/js/models/buildings/market.js:84`; related `src/js/models/buildings/market.js:49`, `src/js/models/buildings/market.js:96`
- **Severity:** Medium
- **Confidence:** High
- **Likelihood:** Low. It requires picking the Blessed Markets blessing (challenges 5 and 10) and alternating buy/sell trades within its 120 s window.
- **Defect:** With the fee forced to 0%, a buy costs `price × lots`, raises the price by 3, and an immediate sell then pays `(price + 3) × lots` and restores the price. Every buy/sell pair nets `3 × lots` gold with no resource cost. The player can repeat this until gold hits the storage cap. The same arithmetic also yields profit at the 5% minimum fee near the 20-gold price floor (market level 26+).
- **Trigger:** Blessed Markets active, market level ≥ 1: buy 1000 food, sell 1000 food, repeat.
- **Evidence / verification:** Reproduced in an isolated test: 10 round trips of 1000 food turned 1000 gold into 1300 gold, with the food price back at its starting value. Refutation: there is no cooldown, no buy/sell spread and no per-trade shift scaled to lot size. The UI only checks affordability and capacity.
- **Suggested fix:** Ensure a round trip can never be profitable. Options: keep a minimum spread even when the blessing removes the fee; price a trade at the post-shift price (buy at `price + shift`, sell at `price − shift`); or scale the shift with the lot size so bulk trades move the price proportionally.

### [a/null-and-numeric-hazards/construction/duration-multiplier-reaches-zero] Construction research plus Rapid Construction makes every build take 1 second

- **Location:** `src/js/engine/state.js:1293`; related `src/js/models/buildings/building.js:35`, `src/js/models/buildings/headquarters.js:66`
- **Severity:** Medium
- **Confidence:** High
- **Likelihood:** Low. It requires all five Construction research tiers plus choosing Rapid Construction (challenges 4 or 9). The effect then lasts the blessing's 180 s.
- **Defect:** The research reductions (5 × 10% = 50%) and the blessing (50%) are summed without a cap, so the duration multiplier becomes `max(0, 1 − 1) = 0`. Every building level, territory expansion and headquarters type upgrade started in that window is then clamped to the 1-second minimum, regardless of cost. The getter's own contract says the multiplier lies in (0, 1]. The spec describes the blessing as "50% faster", not instant.
- **Trigger:** Complete Construction 1–5, then select Rapid Construction and start any construction.
- **Evidence / verification:** Reproduced in an isolated test: with the five research keys completed and the blessing active, the multiplier read exactly 0 and an HQ expansion returned a 1-second duration. Refutation: no cap or minimum multiplier exists, and the floating-point sum is exactly 1.0.
- **Suggested fix:** Combine reductions multiplicatively (`(1 − research) × (1 − blessing)`), or clamp the multiplier to a sensible minimum such as 0.25.

### [a/error-handling/persistence/failed-save-reported-as-success] A failed save still shows "Game Saved" and enables Load

- **Location:** `src/js/engine/storage.js:56`; related `src/components/screens/game_screen.vue:1004`, `src/components/screens/game_screen.vue:1023`, `src/components/screens/game_screen.vue:1304`
- **Severity:** Medium
- **Confidence:** Medium
- **Likelihood:** Low. It needs a browser where the storage write throws: storage blocked by privacy settings or policy, a full quota, or legacy Safari private mode.
- **Defect:** The `savedGame` setter swallows every write error and returns nothing. All three save paths (pause-menu Save, autosave, F9) unconditionally set "has saved game" and show the "Game Saved" indicator. The player believes progress is stored. Load then finds nothing and does nothing, and after quitting there is no Continue. The progress is lost after a save the game said succeeded.
- **Trigger:** Play with site storage blocked (e.g. cookies/site data disabled), then save and close the tab.
- **Evidence / verification:** Traced: `set savedGame` → `try { setItem } catch {}` with no signal; callers never read back or check. Remaining assumption: how often real players run with storage blocked; not reproduced in a browser.
- **Suggested fix:** Have the setter return success or failure (or rethrow). Show a "save failed" notification instead of "Game Saved", and do not set the has-saved-game flag on failure.

## Low

### [a/state-and-lifecycle/events/limit-notices-not-cleared-after-losses] Population and territory limit notices stay after workers or levels are lost

- **Location:** `src/js/engine/state.js:802`; related `src/js/engine/state.js:968`, `src/js/engine/state.js:1362`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Several challenges sacrifice workers on success or remove workers and building levels on failure, and players frequently sit at their population or territory cap.
- **Defect:** The "population limit reached" and "territory limit reached" notices are dismissed only by dismissing workers by hand, downgrading by hand, finishing a house or territory expansion, or Holy Expansion. Worker sacrifice (challenge requirements and punishments) and punishment level loss free population or territory but leave the notices up. Because the notice is still present, reaching the population cap again does not raise a fresh one.
- **Trigger:** Fill the house cap, then complete a worker-sacrifice challenge or fail Plague; or fill territory, then take a level-loss punishment.
- **Evidence / verification:** Traced every dismissal site of both event types. None is on the sacrifice or punishment paths, and `update()` never re-evaluates either condition. Refutation: no periodic recheck exists.
- **Suggested fix:** After sacrificing workers or removing levels, dismiss the notices when the colony is below the respective cap. Alternatively, edge-detect both limits in `update()` the way storage caps are handled.

### [a/state-and-lifecycle/game-loop/paused-time-counted-after-unpause] Up to one second of paused time (× game speed) is simulated after unpausing

- **Location:** `src/components/screens/game_screen.vue:1130`; related `src/components/screens/game_screen.vue:1176`, `src/components/screens/game_screen.vue:1209`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. It occurs on every tutorial-modal dismissal, blessing selection and punishment acknowledgement.
- **Defect:** While paused, the per-frame loop skips without refreshing its timestamp. Only the 1-second tick refreshes it. The unpause paths for the tutorial, blessing and punishment do not reset the timestamps (the win-continue and pause-menu paths do). The first frame after unpausing therefore advances seasons, construction, research, challenge timers and effect timeouts by up to 1 s × speed (up to 3 s) of time that elapsed while paused.
- **Trigger:** At 3× speed, open a tutorial modal and dismiss it about 0.9 s after the last 1-second tick.
- **Evidence / verification:** Traced `progressTick` (paused branch keeps `lastProgressTickTime`), `gameTick` (refreshes it once per second while paused), and `dismissTutorialModal` / `selectBlessing` / `acknowledgePunishment` (no reset), compared with `handleWinContinue`, which resets. Refutation: the 5 s delta cap bounds but does not remove the leak.
- **Suggested fix:** Reset the tick timestamps in every unpause path, e.g. in one shared "resume" helper.

### [a/concurrency/audio/stale-play-rejection-clears-new-sound-entry] Re-triggering a sound before it starts corrupts sound bookkeeping

- **Location:** `src/js/engine/audio.js:81`; related `src/js/engine/audio.js:54`, `src/js/engine/state.js:1359`
- **Severity:** Low
- **Confidence:** Medium
- **Likelihood:** Medium. Assigning a batch of workers with recruiting plays the recruit sound several times synchronously, and double taps do the same for the tap sound.
- **Defect:** A second `playSound` for the same asset pauses the element while the first `play()` promise is still pending. Per the HTML spec, that rejects the first promise. Its `.catch(cleanup)` then deletes the map entries now owned by the second call. The element keeps playing untracked, so the next call creates a second element that overlaps it. When the first element ends, its later cleanup deletes the newer element's entry, and the corruption continues.
- **Trigger:** Assign 10 workers to a building with no idle workers and enough food, so several recruit sounds fire in one call.
- **Evidence / verification:** Traced: the cleanup closure deletes `_activeSounds`/`_soundCleanup` by asset key without checking that the entry is still its own element. Not reproduced in a browser; depends on the play promise still being pending, which is the common case for synchronous repeats.
- **Suggested fix:** In cleanup, delete map entries only if they still reference this element and this cleanup. Alternatively, ignore `AbortError` rejections.

### [a/state-and-lifecycle/tutorial/open-tutorial-modal-lost-on-save] A tutorial modal open at save time is lost on reload

- **Location:** `src/js/models/tutorial.js:20`; related `src/js/models/tutorial.js:42`, `src/components/screens/game_screen.vue:1018`
- **Severity:** Low
- **Confidence:** Medium
- **Likelihood:** Low. It requires autosave or F9 to fire while a tutorial modal is open, then a reload of that save.
- **Defect:** The open tutorial modal is not serialized, and autosave keeps running while a tutorial modal pauses the game. After loading, the game runs unpaused, and that modal is neither shown nor marked dismissed. One-off triggers (the last HQ type upgrade) never fire again, and the negative-production trigger is suppressed by the restored edge-detection set. Tutorial completion waits for every modal to be dismissed, so it can stall for that save.
- **Trigger:** A negative-production tutorial modal is open, autosave fires (or F9), and the player later loads that save.
- **Evidence / verification:** Traced `Tutorial.toJSON` (omits `activeModal`), `State.fromJSON` (restores the negative-production set), and `checkTutorial` (requires `allModalsDismissed`). Refutation: recurring triggers (season change, challenge start) re-fire later, which limits the impact to one-off modals.
- **Suggested fix:** Serialize `activeModal` and restore the pause on load, or skip saving while a tutorial modal is open.

### [a/state-and-lifecycle/game-screen/tutorial-dismiss-unpauses-under-challenge-modal] Dismissing a tutorial modal unpauses the game while a challenge modal is still showing

- **Location:** `src/components/screens/game_screen.vue:1130`; related `src/js/engine/state.js:1336`, `src/components/screens/game_screen.vue:1196`
- **Severity:** Low
- **Confidence:** Medium
- **Likelihood:** Low. Both modals must appear at once: in a background tab the 1-second tick fires a tutorial modal and resolves the challenge timeout in the same tick, or the final blessing's recalculation fires a tutorial modal over the win modal.
- **Defect:** Tutorial modals can be triggered regardless of an active challenge modal. Challenge advancement does not stop when a tutorial pause happens in the same tick. Dismissing the tutorial sets `paused = false` unconditionally. Production, seasons and construction then run behind a reward, failure or win modal that the architecture says keeps the game paused.
- **Trigger:** Background tab; the first negative food production and the challenge timeout land in the same tick; return and dismiss the tutorial modal.
- **Evidence / verification:** Traced `gameTick` (hidden path: `update` → tutorial pause → `advanceChallenges` → challenge modal) and `dismissTutorialModal`, which ignores `challengeModal`. Remaining uncertainty is only the timing coincidence.
- **Suggested fix:** On tutorial dismissal, unpause only when no challenge modal is active. Optionally, stop advancing challenges in a tick once the game has been paused.

### [a/state-and-lifecycle/autosave/countdown-reset-on-pause-close] Opening and closing the pause menu restarts the autosave countdown

- **Location:** `src/components/screens/game_screen.vue:1345`; related `src/components/screens/game_screen.vue:1018`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. Autosave is off by default, and the player must reopen the pause menu more often than the interval (default 5 min).
- **Defect:** Closing the pause menu stops and recreates the autosave `setInterval`, discarding the play time already accumulated toward the next save. A player who pauses at least once per interval never gets an autosave.
- **Trigger:** Autosave on (5 min); open and close the pause menu every 4 minutes.
- **Evidence / verification:** Traced the `showModal` watcher: open → `stopAutosave()`, close → `startAutosave()` → new full-length interval. No remaining-time bookkeeping exists.
- **Suggested fix:** Track elapsed unpaused play time toward the next autosave and resume with the remaining time, instead of restarting the full interval.

### [a/state-and-lifecycle/game-screen/challenge-detail-not-closed-after-background-resolution] The challenge detail modal stays open under the result modal after a background-tab resolution

- **Location:** `src/components/screens/game_screen.vue:1223`; related `src/components/screens/game_screen.vue:1196`, `src/components/screens/game_screen.vue:1209`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It requires the detail modal to be open while the tab is hidden at the moment the challenge times out.
- **Defect:** The detail modal is closed only in the per-frame loop, right after challenges advance. When the challenge resolves in the hidden-tab tick, the game is paused, so the per-frame loop returns early and never closes it. Detail and result modals stack, and Escape closes the detail modal first.
- **Trigger:** Open the challenge detail modal, switch tabs until the timeout, and return.
- **Evidence / verification:** Traced: the hidden-tab path calls `advanceChallenges` without the close check, and `progressTick` exits on `state.paused` before reaching it.
- **Suggested fix:** Close the detail modal whenever a challenge modal becomes active, e.g. via a watcher on the synced challenge-modal value.

### [a/state-and-lifecycle/audio/playlist-survives-quit] Toggling music in Settings after quitting plays game music on the menu screens

- **Location:** `src/js/engine/audio.js:172`; related `src/js/engine/audio.js:123`, `src/app.vue:47`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It requires quitting a game and then turning music off and on from the home Settings screen.
- **Defect:** Quitting stops the current track but keeps the playlist. Re-enabling music sees a playlist and no active track, so it starts the game playlist on the home or settings screen, which otherwise never plays music.
- **Trigger:** Start a game → Quit → Settings → Music off → Music on.
- **Evidence / verification:** Traced `quitGame` → `stopMusic()` (clears only the element) and `setMusicEnabled(true)` (`_playlist.length && !_music` → `_playTrack`).
- **Suggested fix:** Clear the playlist when quitting to the home screen (e.g. a `stopMusic` variant that also resets `_playlist`).

### [a/state-and-lifecycle/modals/escape-closes-underlying-modal] Escape closes the hidden Market or Research modal instead of the modal on top

- **Location:** `src/components/modals/research_modal.vue:126`; related `src/components/modals/market_modal.vue:174`, `src/components/modals/challenge_failure_modal.vue:21`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It requires Market or Research to be open, without pausing the game, when a tutorial or challenge modal appears.
- **Defect:** Every modal registers a capture-phase window keydown listener that stops propagation immediately. Listeners fire in registration order, so the earlier-opened Market or Research modal consumes Escape. It closes beneath the visible tutorial or challenge modal, which stays open.
- **Trigger:** Keep the Market open until a season change triggers the tutorial modal, then press Escape.
- **Evidence / verification:** Traced listener registration order on `window` with `stopImmediatePropagation()` in each handler.
- **Suggested fix:** Keep a modal stack and let only the topmost modal handle Escape.

### [a/logic-errors/building-card/market-fee-tooltip-past-floor] Market upgrade tooltip promises "-1% market fee" after the fee has hit its floor

- **Location:** `src/components/buildings/base_card.vue:110`; related `src/js/models/buildings/market.js:55`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It is only visible from market level 26, where the 5% minimum fee is reached.
- **Defect:** The upgrade tooltip always advertises a 1% fee reduction. The fee is clamped at the 5% minimum from level 26, so further upgrades reduce nothing while the tooltip says otherwise.
- **Trigger:** Hover the market upgrade button at market level ≥ 26.
- **Evidence / verification:** Traced the tooltip (constant `MARKET_FEE_REDUCTION_PER_LEVEL`) against `effectiveTradeFee` (`max(5, 30 − (level − 1))`).
- **Suggested fix:** Compute the tooltip value as the difference between the current and next-level effective fee, and omit the line when it is 0.

### [b/contract-mismatches/specs/stale-challenge-effect-descriptions] specs.md misdescribes Favorable Weather and Plague effects

- **Location:** `docs/specs.md:338`; related `docs/specs.md:348`, `src/js/engine/state.js:341`, `src/data/challenges.json`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It affects contributors relying on the spec, not players.
- **Defect:** The spec says Favorable Weather multiplies the season modifiers by `(1 + warm)` / `(1 − cold)`. The code, its tests and the in-game text add the bonus instead (warm food ×1.3, not ×1.22). The spec also says Plague reduces general productivity, but both Plague punishments in the data have no productivity effect or duration, and a test asserts that absence.
- **Trigger:** Implementing or balancing from `docs/specs.md`.
- **Evidence / verification:** Compared `_computeSeasonMultipliers` and its tests (additive) and `challenges.json` with `constants.test.js` (Plague has no `productivityGeneral`) against the spec text. Code, tests and UI agree with each other, so the spec is the incorrect artifact.
- **Suggested fix:** Update both spec entries to the implemented behavior.
