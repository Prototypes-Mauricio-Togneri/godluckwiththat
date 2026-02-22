### `src/components/modals/research_modal.vue` (lines 232-243)

`::-webkit-scrollbar` styling is WebKit/Blink-only. Firefox shows default OS scrollbar, inconsistent with dark theme.

**Fix:** Add `scrollbar-width: thin; scrollbar-color: ...` (standard CSS Scrollbar API) alongside webkit rules.

### `src/components/screens/game_screen.vue` (lines 168-193)

`setInterval`/`requestAnimationFrame` game loop. On mobile, background tabs are aggressively throttled; elapsed wall-clock time is lost with no catch-up mechanism.

**Fix:** Record `lastTickTime` and compute missed delta via `visibilitychange` for catch-up ticks.

### `src/js/engine/audio.js` (lines 23-29)

12 `HTMLAudioElement` instances created and loaded at startup. On mobile/metered connections, this wastes bandwidth and delays load time.

**Fix:** Lazy-load audio on first request, caching for subsequent plays.

### `src/components/screens/game_screen.vue` (line 281)

`toLocaleString()` produces locale-dependent formatting, inconsistent with the custom `formatNumber()` helper used elsewhere.

**Fix:** Use `formatNumber()` for consistency.

### `index.html` (line 20)

Google Fonts loaded via blocking `<link>`. CDN unavailability (e.g., China) delays page render.

**Fix:** Self-host fonts or use non-blocking `preload` pattern.

### `src/js/i18n/localized.js` (line 15)

`navigator.language` read once at module load, never updated on language change.

**Fix:** Listen for `languagechange` event if needed, or accept this minor limitation.