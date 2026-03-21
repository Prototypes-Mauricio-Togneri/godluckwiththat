import {describe, it, expect, vi, beforeEach} from 'vitest'

describe('localized', () => {
  beforeEach(() => {
    vi.resetModules()
  })

  function mockBrowserGlobals(language = 'en') {
    vi.stubGlobal('navigator', {
      language: language,
    })
    vi.stubGlobal('document', {
      documentElement: {
        lang: '',
      },
    })
  }

  async function importLocalized(language = 'en') {
    mockBrowserGlobals(language)
    const module = await import('@/js/i18n/localized.js')
    return module.t
  }

  describe('language resolution', () => {
    it('should resolve English for en browser language', async () => {
      const translate = await importLocalized('en')
      expect(translate('resource.food')).toBeDefined()
      expect(document.documentElement.lang).toBe('en')
    })

    it('should resolve French for fr browser language', async () => {
      const translate = await importLocalized('fr')
      expect(translate('resource.food')).toBeDefined()
      expect(document.documentElement.lang).toBe('fr')
    })

    it('should resolve Spanish for es browser language', async () => {
      await importLocalized('es')
      expect(document.documentElement.lang).toBe('es')
    })

    it('should fall back to English for unsupported language', async () => {
      await importLocalized('zh')
      expect(document.documentElement.lang).toBe('en')
    })

    it('should handle language codes with region suffix', async () => {
      await importLocalized('fr-CA')
      expect(document.documentElement.lang).toBe('fr')
    })
  })

  describe('t() function', () => {
    it('should return the localized string for a key', async () => {
      const translate = await importLocalized('en')
      const result = translate('resource.food')
      expect(typeof result).toBe('string')
      expect(result.length).toBeGreaterThan(0)
    })

    it('should replace positional parameters', async () => {
      const translate = await importLocalized('en')
      // Find a key that uses {0} parameter — event keys typically do
      const result = translate('event.buildingBuilding', 'TestBuilding')
      expect(result).toContain('TestBuilding')
    })

    it('should return raw string when no params passed', async () => {
      const translate = await importLocalized('en')
      const result = translate('event.buildingBuilding')
      expect(result).toContain('{0}')
    })

    it('should replace missing param indices with empty string', async () => {
      const translate = await importLocalized('en')
      // Pass fewer params than the template expects
      const result = translate('event.challengeStarted', 'first')
      expect(result).not.toContain('{0}')
    })
  })
})
