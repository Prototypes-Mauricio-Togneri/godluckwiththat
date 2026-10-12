import {describe, it, expect, vi, beforeEach} from 'vitest'
import {initializeApp} from 'firebase/app'
import {getAnalytics, isSupported, logEvent} from 'firebase/analytics'
import {FIREBASE_CONFIG} from '@/js/engine/constants.js'
import {ANALYTICS_EVENT_GAME_START, ANALYTICS_EVENT_TUTORIAL_COMPLETE, ANALYTICS_GAME_MODE_NEW, ANALYTICS_GAME_MODE_SAVED} from '@/js/engine/enums.js'

vi.mock('firebase/app', () => ({
  initializeApp: vi.fn(() => 'app'),
}))

vi.mock('firebase/analytics', () => ({
  getAnalytics: vi.fn(() => 'analytics'),
  isSupported: vi.fn(),
  logEvent: vi.fn(),
}))

describe('analytics', () => {
  beforeEach(() => {
    vi.resetModules()
    vi.clearAllMocks()
    isSupported.mockResolvedValue(true)
  })

  async function importAnalytics(hostname = 'godluckwiththat.com') {
    vi.stubGlobal('window', {
      location: {
        hostname: hostname,
      },
    })
    const module = await import('@/js/engine/analytics.js')
    return module.default
  }

  async function flushPromises() {
    await new Promise((resolve) => setTimeout(resolve, 0))
  }

  describe('init', () => {
    it('should initialize Firebase with the project config', async () => {
      const analytics = await importAnalytics()
      analytics.init()
      await flushPromises()
      expect(initializeApp).toHaveBeenCalledWith(FIREBASE_CONFIG)
      expect(getAnalytics).toHaveBeenCalledWith('app')
    })

    it('should stay disabled on localhost', async () => {
      const analytics = await importAnalytics('localhost')
      analytics.init()
      analytics.logGameStart(ANALYTICS_GAME_MODE_NEW)
      await flushPromises()
      expect(isSupported).not.toHaveBeenCalled()
      expect(logEvent).not.toHaveBeenCalled()
    })

    it('should stay disabled on 127.0.0.1', async () => {
      const analytics = await importAnalytics('127.0.0.1')
      analytics.init()
      analytics.logGameStart(ANALYTICS_GAME_MODE_NEW)
      await flushPromises()
      expect(isSupported).not.toHaveBeenCalled()
      expect(logEvent).not.toHaveBeenCalled()
    })

    it('should stay disabled when the browser is not supported', async () => {
      isSupported.mockResolvedValue(false)
      const analytics = await importAnalytics()
      analytics.init()
      analytics.logGameStart(ANALYTICS_GAME_MODE_NEW)
      await flushPromises()
      expect(initializeApp).not.toHaveBeenCalled()
      expect(logEvent).not.toHaveBeenCalled()
    })

    it('should stay disabled without throwing when initialization fails', async () => {
      isSupported.mockRejectedValue(new Error('blocked'))
      const analytics = await importAnalytics()
      analytics.init()
      analytics.logGameStart(ANALYTICS_GAME_MODE_NEW)
      await flushPromises()
      expect(logEvent).not.toHaveBeenCalled()
    })
  })

  describe('events', () => {
    it('should not log events before init is called', async () => {
      const analytics = await importAnalytics()
      analytics.logGameStart(ANALYTICS_GAME_MODE_NEW)
      await flushPromises()
      expect(logEvent).not.toHaveBeenCalled()
    })

    it('should log game start with its mode', async () => {
      const analytics = await importAnalytics()
      analytics.init()
      analytics.logGameStart(ANALYTICS_GAME_MODE_SAVED)
      await flushPromises()
      expect(logEvent).toHaveBeenCalledWith('analytics', ANALYTICS_EVENT_GAME_START, {
        mode: ANALYTICS_GAME_MODE_SAVED,
      })
    })

    it('should log tutorial complete', async () => {
      const analytics = await importAnalytics()
      analytics.init()
      analytics.logTutorialComplete()
      await flushPromises()
      expect(logEvent).toHaveBeenCalledWith('analytics', ANALYTICS_EVENT_TUTORIAL_COMPLETE, undefined)
    })

    it('should not throw when logging fails', async () => {
      logEvent.mockImplementationOnce(() => {
        throw new Error('network')
      })
      const analytics = await importAnalytics()
      analytics.init()
      analytics.logTutorialComplete()
      await flushPromises()
      expect(logEvent).toHaveBeenCalled()
    })
  })
})
