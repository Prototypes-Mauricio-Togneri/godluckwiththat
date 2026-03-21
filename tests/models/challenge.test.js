import {describe, it, expect} from 'vitest'
import {CHALLENGE_STATUS_ACTIVATED, CHALLENGE_STATUS_PENDING, CHALLENGE_STATUS_STARTED} from '@/js/engine/enums.js'
import Challenge from '@/js/models/challenge.js'
import {createChallenge} from '../helpers/factories.js'

describe('Challenge', () => {
  describe('constructor', () => {
    it('should set all fields', () => {
      const challenge = createChallenge({
        index: 3,
        delay: 120,
        timeout: 600,
      })
      expect(challenge.index).toBe(3)
      expect(challenge.status).toBe(CHALLENGE_STATUS_PENDING)
      expect(challenge.delay).toBe(120)
      expect(challenge.timeout).toBe(600)
      expect(challenge.delayElapsed).toBe(0)
      expect(challenge.timeoutElapsed).toBe(0)
    })
  })

  describe('isDelayElapsed', () => {
    it('should return true when activated and delay elapsed', () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_ACTIVATED,
        delay: 60,
        delayElapsed: 60,
      })
      expect(challenge.isDelayElapsed).toBe(true)
    })

    it('should return false when delay not yet elapsed', () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_ACTIVATED,
        delay: 60,
        delayElapsed: 30,
      })
      expect(challenge.isDelayElapsed).toBe(false)
    })

    it('should return false when not in activated status', () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        delay: 60,
        delayElapsed: 60,
      })
      expect(challenge.isDelayElapsed).toBe(false)
    })
  })

  describe('isTimeoutElapsed', () => {
    it('should return true when started and timeout elapsed', () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        timeout: 300,
        timeoutElapsed: 300,
      })
      expect(challenge.isTimeoutElapsed).toBe(true)
    })

    it('should return false when timeout not yet elapsed', () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        timeout: 300,
        timeoutElapsed: 100,
      })
      expect(challenge.isTimeoutElapsed).toBe(false)
    })
  })

  describe('reset', () => {
    it('should reset timers and set status to activated', () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        delayElapsed: 50,
        timeoutElapsed: 200,
      })
      challenge.reset()
      expect(challenge.status).toBe(CHALLENGE_STATUS_ACTIVATED)
      expect(challenge.delayElapsed).toBe(0)
      expect(challenge.timeoutElapsed).toBe(0)
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip through serialization', () => {
      const original = createChallenge({
        index: 2,
        status: CHALLENGE_STATUS_ACTIVATED,
        delay: 60,
        delayElapsed: 30,
        timeout: 300,
      })
      const json = original.toJSON()
      const restored = Challenge.fromJSON(json)
      expect(restored.index).toBe(2)
      expect(restored.status).toBe(CHALLENGE_STATUS_ACTIVATED)
      expect(restored.delayElapsed).toBe(30)
      expect(restored.blessings).toHaveLength(1)
      expect(restored.punishment).toBeDefined()
    })
  })
})
