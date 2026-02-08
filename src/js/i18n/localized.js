import {LOCALIZED_EN} from '@/js/i18n/en.js'
import {LOCALIZED_ES} from '@/js/i18n/es.js'

const LOCALES = {
  en: LOCALIZED_EN,
  es: LOCALIZED_ES,
}

const browserLang = navigator.language.slice(0, 2)
const strings = LOCALES[browserLang] ?? LOCALES.en

/** Lookup helper — returns the localized string for the given key. */
export const t = key => strings[key]
