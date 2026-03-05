  7. dismissPastByType / dismissPastByTextKey create new arrays via filter()
  - File: src/js/models/events/events.js
  - Lines: 134–144
  - Severity: Medium
  - Category: GC Pressure
  - Both methods use Array.filter() which always allocates a new array, even
  when no items match. Called from state.js on construction completion (lines
  261, 266, 268), season changes (line 226), resource cap transitions (line
  176), and negative production transitions (line 209) — potentially multiple
  times per tick.
  - Fix: Use in-place removal with a reverse for loop and splice(), avoiding
  array allocation when nothing is removed.

  8. Triple iteration of BOUNDED_RESOURCES per tick
  - File: src/js/engine/state.js
  - Lines: 153–155 (cap enforcement), 161–178 (cap edge detection), 194–211
  (negative production edge detection)
  - Severity: Low
  - Category: Game Loop
  - The same 8-element BOUNDED_RESOURCES array is iterated 3 separate times in
  update(). Each pass does related work (cap, cap edge events, negative
  production events) that could be consolidated.
  - Fix: Merge all three loops into a single pass over BOUNDED_RESOURCES.

  9. completedCount() uses Array.filter() in template
  - File: src/components/modals/research_modal.vue
  - Lines: 78–79
  - Severity: Low
  - Category: GC Pressure / Rendering
  - completedCount(sub) calls sub.researches.filter(key => ...) creating a
  temporary array per subcategory per render. Also called indirectly by
  accumulatedBonusText(sub) (line 87), doubling the work. Small arrays (~5
  items), only while the modal is open.
  - Fix: Convert to a computed property returning a Map<subcategory, count>, or
  compute the count with a for loop and counter instead of filter().length.

  10. Template helper functions are plain functions, not computed
  - File: src/components/screens/game_screen.vue
  - Lines: 71–80 (rateClass), 86–88 (isBounded), 94–100 (resourceFillPercent),
  106–125 (timeEstimate), 131–149 (grossProduction, resourceConsumption,
  hasConsumption)
  - Severity: Low
  - Category: Rendering
  - These are plain functions called in template expressions, re-evaluated on
  every render for every visible resource. Most are cheap O(1) lookups.
  Exception: timeEstimate (lines 106–125) does conditional string formatting
  with t() + formatTime() per resource per render.
  - Fix: For timeEstimate, precompute a map in syncUI(). The others are cheap
  enough that converting to computed maps would add complexity for negligible
  gain.

  11. Market modal template functions
  - File: src/components/modals/market_modal.vue
  - Lines: 23–35 (canBuy, canSell), 41–65 (buyTooltip, sellTooltip)
  - Severity: Low
  - Category: Rendering
  - Four functions called per resource (5 tradeable resources) per render — 20
  function invocations. buyTooltip and sellTooltip perform t() lookups and
  formatNumber() calls. Only active while the market modal is open, so not a
  per-frame cost during gameplay.
  - Fix: Convert to a computed map: Map<resource, { canBuy, canSell, buyTooltip,
   sellTooltip }>.

  12. Audio cloneNode() per sound play
  - File: src/js/engine/audio.js
  - Lines: 59–60
  - Severity: Low
  - Category: GC Pressure
  - Clones cached HTMLAudioElement nodes for each sound play. Properly cleaned
  up via ended/error listeners with AbortController (lines 63–79). Mitigated by
  reusing the clone per asset path (lines 53–57 check _activeSounds first).
  - Fix: No action needed — current design correctly limits to one active clone
  per asset path.

  14. CSS box-shadow glow on resource progress bars
  - File: src/assets/styles.css
  - Lines: 645–653
  - Severity: Low
  - Category: CSS/GPU
  - box-shadow: 0 0 5px applied to .resource-bar-fill--positive and --negative.
  Up to 8 resource bars visible simultaneously. Small blur radius, minimal GPU
  overhead.
  - Fix: No action needed — 8 elements with a 5px blur is negligible.

  15. CSS infinite animation on active research nodes
  - File: src/components/modals/research_modal.vue
  - Lines: 407, 411–414
  - Severity: Low
  - Category: CSS/GPU
  - animation: research-pulse 2s ease-in-out infinite on .research-node--active.
   Uses outline (cheaper than box-shadow). Only 1–3 active research nodes at
  most, and only while the modal is open.
  - Fix: No action needed.

  16. CSS double drop-shadow on building help image
  - File: src/components/modals/building_help_modal.vue
  - Lines: 93–94
  - Severity: Low
  - Category: CSS/GPU
  - filter: drop-shadow(...) drop-shadow(...) stacks two GPU filter passes.
  Single element, only visible when the help modal is open.
  - Fix: No action needed — single element, modal context.