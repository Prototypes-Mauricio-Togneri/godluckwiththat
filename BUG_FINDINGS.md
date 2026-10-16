### [b/validation-and-coercion/market/negative-saved-price] A negative saved market price grants gold on purchase

- **Location:** `src/js/models/buildings/market.js:26`; related: `src/js/engine/utils.js:73`, `src/js/models/buildings/market.js:79`, `src/js/engine/state.js:1481`.
- **Severity:** Medium.
- **Confidence:** High.
- **Likelihood:** Low. Ordinary trading respects price bounds; the trigger requires a malformed or hand-edited local save.
- **Defect:** Market restoration accepts any finite price, including negative values. A buy quote can then be negative, and subtracting that quote adds gold while also granting the purchased resource.
- **Trigger:** Load a save with a built market whose saved food price is `-100`, then buy one 100-unit food lot with room in storage.
- **Evidence / verification:** The constructor accepts `-100`; the one-lot buy quote shifts it to `-97` before the fee, producing a negative gold cost. The affordability and storage checks do not reject that cost, and the load path does not clamp it. A separate refutation checked the quote bounds, trade guards, and modal guard; none blocks this path. Verified statically; tests were not run.
- **Suggested fix:** Validate restored prices against the configured minimum and maximum before any trade, or reject invalid saved market state.

### [a/state-and-lifecycle/tutorial/dropped-challenge-explanation] A simultaneous popup can discard a challenge tutorial step

- **Location:** `src/js/engine/state.js:1377`; related: `src/components/screens/game_screen.vue:1283`, `src/js/engine/state.js:700`, `src/js/models/tutorial.js:35`.
- **Severity:** Medium.
- **Confidence:** High.
- **Likelihood:** Low. A season change or HQ upgrade must open a tutorial popup in the same progress step that a challenge delay expires.
- **Defect:** Progress continues through challenge-start handling after an earlier operation opens a tutorial popup. The challenge popup trigger sees the active popup and is discarded; there is no immediate replay, delaying the explanation until another challenge starts. If this is the final opportunity, the required dismissed-modal set cannot become complete.
- **Trigger:** Have a season flip or HQ upgrade complete in the same progress step as a challenge's activation delay.
- **Evidence / verification:** The progress function calls season, construction, and challenge advancement sequentially without stopping when an earlier call pauses play. The challenge popup is triggered only at the delay-to-start transition. A separate refutation confirmed that later challenge starts can recover an earlier loss, but found no recovery when no later challenge remains. Verified statically; tests were not run.
- **Suggested fix:** Queue undelivered tutorial popups and show them after the current one closes, or retry the challenge explanation while it remains undismissed.
