### `src/components/screens/home_screen.vue` (line 33)

`height: 100vh` doesn't account for mobile browser chrome. Start button may be hidden behind iOS Safari/Android Chrome toolbar.

**Fix:** Use `height: 100vh; height: 100dvh;` (dvh supported in Safari 15.4+, Chrome 108+, Firefox 108+).

### `src/components/screens/game_screen.vue` (lines 411-412)

Same `100vh` issue on `.game-screen` and `--thumb-h` calculation. Game layout extends behind browser chrome on mobile.

**Fix:** Use `height: 100dvh` with `100vh` fallback. Update `--thumb-h` accordingly.

## Medium

### `src/js/engine/audio.js` (lines 62-71, 95-98)

Music `play()` errors suppressed. No retry on iOS Safari background/foreground transitions; audio stops silently.

**Fix:** Add `visibilitychange` listener to call `resumeMusic()` when document becomes visible.

### `src/components/screens/game_screen.vue` (lines 234-407)

Horizontal flex layout with 6 side-by-side columns, no responsive breakpoints. Completely unusable on phones and narrow tablets.

**Fix:** Add media queries to stack columns or use tabbed layout on smaller viewports, or set `min-width` with `overflow-x: auto`.

### `src/components/screens/game_screen.vue` (line 595)

`.game-content` has `overflow: hidden`. Content clipped on smaller screens with no way to scroll.

**Fix:** Change to `overflow: auto` or `overflow-x: auto`.

### `src/assets/styles.css` (line 29)

`user-select: none` on `*` without `-webkit-user-select` prefix. Older WebKit browsers (Safari < 14.1) require the prefix.

**Fix:** Add `-webkit-user-select: none` alongside the unprefixed property.

### `src/assets/styles.css` (lines 80-118)

Tooltips rely entirely on `:hover`. Touch devices can't trigger hover reliably; tooltip content invisible on mobile.

**Fix:** Implement tap-to-show/tap-to-dismiss pattern for touch devices.

### `src/components/modals/research_modal.vue` (lines 232-243)

`::-webkit-scrollbar` styling is WebKit/Blink-only. Firefox shows default OS scrollbar, inconsistent with dark theme.

**Fix:** Add `scrollbar-width: thin; scrollbar-color: ...` (standard CSS Scrollbar API) alongside webkit rules.

### `src/components/screens/game_screen.vue` (lines 168-193)

`setInterval`/`requestAnimationFrame` game loop. On mobile, background tabs are aggressively throttled; elapsed wall-clock time is lost with no catch-up mechanism.

**Fix:** Record `lastTickTime` and compute missed delta via `visibilitychange` for catch-up ticks.

## Warning

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