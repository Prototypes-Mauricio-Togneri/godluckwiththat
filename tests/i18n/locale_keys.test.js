import {describe, it, expect} from 'vitest'
import {LOCALIZED_EN} from '@/js/i18n/en.js'
import {LOCALIZED_ES} from '@/js/i18n/es.js'
import {LOCALIZED_CA} from '@/js/i18n/ca.js'
import {LOCALIZED_FR} from '@/js/i18n/fr.js'
import {LOCALIZED_IT} from '@/js/i18n/it.js'

const locales = {
  es: LOCALIZED_ES,
  ca: LOCALIZED_CA,
  fr: LOCALIZED_FR,
  it: LOCALIZED_IT,
}

const referenceKeys = Object.keys(LOCALIZED_EN)

function keysWithEmptyValues(locale) {
  return Object.entries(locale)
    .filter(entry => entry[1] === '')
    .map(entry => entry[0])
}

function keysWithNonStringValues(locale) {
  return Object.entries(locale)
    .filter(entry => typeof entry[1] !== 'string')
    .map(entry => entry[0])
}

describe('locale consistency', () => {
  describe.each(Object.entries(locales))('%s', (_, locale) => {
    it('should contain every key from en.js', () => {
      const localeKeys = new Set(Object.keys(locale))
      const missingKeys = referenceKeys.filter(key => !localeKeys.has(key))
      expect(missingKeys).toEqual([])
    })

    it('should not have extra keys absent from en.js', () => {
      const referenceKeySet = new Set(referenceKeys)
      const extraKeys = Object.keys(locale).filter(key => !referenceKeySet.has(key))
      expect(extraKeys).toEqual([])
    })

    it('should not have empty string values', () => {
      expect(keysWithEmptyValues(locale)).toEqual([])
    })

    it('should have only string values', () => {
      expect(keysWithNonStringValues(locale)).toEqual([])
    })
  })

  describe('en', () => {
    it('should not have empty string values', () => {
      expect(keysWithEmptyValues(LOCALIZED_EN)).toEqual([])
    })

    it('should have only string values', () => {
      expect(keysWithNonStringValues(LOCALIZED_EN)).toEqual([])
    })
  })
})
