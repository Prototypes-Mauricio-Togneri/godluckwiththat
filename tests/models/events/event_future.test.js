import {describe, it, expect} from 'vitest'
import EventFuture from '@/js/models/events/event_future.js'

describe('EventFuture', () => {
  function createFutureEvent(overrides = {}) {
    return new EventFuture({
      id: 1,
      type: 'building_upgrade',
      textKey: 'event.building',
      icon: 'test.png',
      remainingSeconds: 60,
      ...overrides,
    })
  }

  describe('constructor', () => {
    it('should set remainingSeconds', () => {
      const event = createFutureEvent({
        remainingSeconds: 120,
      })
      expect(event.remainingSeconds).toBe(120)
    })

    it('should inherit Event fields', () => {
      const event = createFutureEvent()
      expect(event.id).toBe(1)
      expect(event.type).toBe('building_upgrade')
    })
  })

  describe('advance', () => {
    it('should decrement remainingSeconds by delta', () => {
      const event = createFutureEvent({
        remainingSeconds: 60,
      })
      event.advance(10)
      expect(event.remainingSeconds).toBe(50)
    })

    it('should clamp at 0', () => {
      const event = createFutureEvent({
        remainingSeconds: 5,
      })
      event.advance(20)
      expect(event.remainingSeconds).toBe(0)
    })

    it('should not decrement below 0', () => {
      const event = createFutureEvent({
        remainingSeconds: 0,
      })
      event.advance(5)
      expect(event.remainingSeconds).toBe(0)
    })
  })

  describe('toJSON', () => {
    it('should include remainingSeconds', () => {
      const event = createFutureEvent({
        remainingSeconds: 42,
      })
      const json = event.toJSON()
      expect(json.remainingSeconds).toBe(42)
      expect(json.id).toBe(1)
      expect(json.type).toBe('building_upgrade')
    })
  })
})
