### [b/contract-mismatches/specs/stale-challenge-effect-descriptions] specs.md misdescribes Favorable Weather and Plague effects

- **Location:** `docs/specs.md:338`; related `docs/specs.md:348`, `src/js/engine/state.js:341`, `src/data/challenges.json`
- **Severity:** Low
- **Confidence:** High
- **Likelihood:** Low. It affects contributors relying on the spec, not players.
- **Defect:** The spec says Favorable Weather multiplies the season modifiers by `(1 + warm)` / `(1 − cold)`. The code, its tests and the in-game text add the bonus instead (warm food ×1.3, not ×1.22). The spec also says Plague reduces general productivity, but both Plague punishments in the data have no productivity effect or duration, and a test asserts that absence.
- **Trigger:** Implementing or balancing from `docs/specs.md`.
- **Evidence / verification:** Compared `_computeSeasonMultipliers` and its tests (additive) and `challenges.json` with `constants.test.js` (Plague has no `productivityGeneral`) against the spec text. Code, tests and UI agree with each other, so the spec is the incorrect artifact.
- **Suggested fix:** Update both spec entries to the implemented behavior.
