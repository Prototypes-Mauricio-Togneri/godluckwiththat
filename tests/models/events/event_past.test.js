import {describe, it, expect} from 'vitest'
import EventPast from '@/js/models/events/event_past.js'

describe('EventPast', () => {
  describe('constructor', () => {
    it('should inherit all Event fields', () => {
      const event = new EventPast({
        id: 3,
        type: 'season_changed',
        textKey: 'event.seasonChanged',
        icon: '/img/season/warm.png',
        params: ['Warm'],
      })
      expect(event.id).toBe(3)
      expect(event.type).toBe('season_changed')
      expect(event.params).toEqual(['Warm'])
    })
  })
})
