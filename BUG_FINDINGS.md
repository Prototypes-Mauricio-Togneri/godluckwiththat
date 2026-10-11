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
