// Localization module. Detects the browser language and resolves
// to a supported locale, defaulting to English.

import {LOCALIZED_EN} from '@/js/i18n/en.js'
import {LOCALIZED_ES} from '@/js/i18n/es.js'

// Supported locale map (language code → string table)
const LOCALES = {
  en: LOCALIZED_EN,
  es: LOCALIZED_ES,
}

const browserLang = navigator.language.slice(0, 2) // Two-letter language code
const strings = LOCALES[browserLang] ?? LOCALES.en // Resolved string table

/**
 * Returns the localized string for the given key.
 * @param {string} key - Dot-notation i18n key (e.g. 'resource.food')
 * @returns {string} Localized string
 */
export const t = key => strings[key]
