---
description: Audit all locale files in `src/js/i18n/` against the English reference (`en.js`).
---

Audit all locale files in `src/js/i18n/` against the English reference (`en.js`).

## Steps

1. Read `src/js/i18n/en.js` to get the reference key set.
2. Read every other locale file (`ca.js`, `es.js`, `fr.js`, `it.js`).
3. For each non-English locale, compare its keys against the English reference:
   - **Missing keys**: keys present in `en.js` but absent in the locale file.
   - **Extra keys**: keys present in the locale file but absent in `en.js`.
   - **Order mismatch**: keys that exist but appear in a different order than in `en.js`.
4. Report findings per locale (missing, extra, order issues). If a locale is fully in sync, say so.
5. For any locale with missing or extra keys, fix the file:
   - Add missing keys with the English value as a placeholder, preserving the same position/order as `en.js`. Prefix the value with `[EN]` so untranslated strings are easy to spot (e.g. `'resource.food': '[EN] Food'`).
   - Remove extra keys that don't exist in `en.js`.
   - Reorder keys to match `en.js` ordering, preserving comment lines and section structure from `en.js`.
6. Preserve each locale's existing translations — only touch missing, extra, or misplaced keys.
7. After edits, run `npm run lint -- --fix` and fix any remaining errors.
