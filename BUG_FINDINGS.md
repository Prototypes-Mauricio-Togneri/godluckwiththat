### [a/state-and-lifecycle/events/limit-notices-not-cleared-after-losses] Population and territory limit notices stay after workers or levels are lost

- **Location:** `src/js/engine/state.js:802`; related `src/js/engine/state.js:968`, `src/js/engine/state.js:1362`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Medium. Several challenges sacrifice workers on success or remove workers and building levels on failure, and players frequently sit at their population or territory cap.
- **Defect:** The "population limit reached" and "territory limit reached" notices are dismissed only by dismissing workers by hand, downgrading by hand, finishing a house or territory expansion, or Holy Expansion. Worker sacrifice (challenge requirements and punishments) and punishment level loss free population or territory but leave the notices up. Because the notice is still present, reaching the population cap again does not raise a fresh one.
- **Trigger:** Fill the house cap, then complete a worker-sacrifice challenge or fail Plague; or fill territory, then take a level-loss punishment.
- **Evidence / verification:** Traced every dismissal site of both event types. None is on the sacrifice or punishment paths, and `update()` never re-evaluates either condition. Refutation: no periodic recheck exists.
- **Suggested fix:** After sacrificing workers or removing levels, dismiss the notices when the colony is below the respective cap. Alternatively, edge-detect both limits in `update()` the way storage caps are handled.

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
