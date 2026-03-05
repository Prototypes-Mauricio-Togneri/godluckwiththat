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
