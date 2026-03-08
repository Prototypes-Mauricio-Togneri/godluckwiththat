/**
 * Localization module. Detects the browser language and resolves
 * to a supported locale, defaulting to English.
 */

import {LOCALIZED_CA} from '@/js/i18n/ca.js'
import {LOCALIZED_EN} from '@/js/i18n/en.js'
import {LOCALIZED_ES} from '@/js/i18n/es.js'
import {LOCALIZED_FR} from '@/js/i18n/fr.js'
import {LOCALIZED_IT} from '@/js/i18n/it.js'

// Supported locale map (language code → string table)
const LOCALES = {
  ca: LOCALIZED_CA,
  en: LOCALIZED_EN,
  es: LOCALIZED_ES,
  fr: LOCALIZED_FR,
  it: LOCALIZED_IT,
}

const browserLang = navigator.language.slice(0, 2) // Two-letter language code
const resolvedLang = browserLang in LOCALES ? browserLang : 'en'
const strings = LOCALES[resolvedLang]

document.documentElement.lang = resolvedLang

/**
 * Returns the localized string for the given key.
 * Supports positional parameters: t('key', 'val0', 'val1') replaces {0}, {1}, etc.
 * @param {string} key - Dot-notation i18n key (e.g. 'resource.food')
 * @param {...string} params - Positional replacement values
 * @returns {string} Localized string
 */
export const t = (key, ...params) => {
  const str = strings[key]
  if (params.length === 0) {
    return str
  }
  return str.replace(/\{(\d+)\}/g, (_, index) => params[index] ?? '')
}
