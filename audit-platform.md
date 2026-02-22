### `src/components/screens/game_screen.vue` (line 281)

`toLocaleString()` produces locale-dependent formatting, inconsistent with the custom `formatNumber()` helper used elsewhere.

**Fix:** Use `formatNumber()` for consistency.