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
