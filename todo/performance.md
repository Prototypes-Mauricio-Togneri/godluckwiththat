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