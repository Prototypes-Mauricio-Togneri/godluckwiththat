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
