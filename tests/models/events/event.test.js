import {describe, it, expect} from 'vitest'
import Event from '@/js/models/events/event.js'

describe('Event', () => {
  describe('constructor', () => {
    it('should set all required fields', () => {
      const event = new Event({
        id: 1,
        type: 'season_changed',
        textKey: 'event.seasonChanged',
        icon: '/img/season/warm.png',
      })
      expect(event.id).toBe(1)
      expect(event.type).toBe('season_changed')
      expect(event.textKey).toBe('event.seasonChanged')
      expect(event.icon).toBe('/img/season/warm.png')
    })

    it('should default optional fields', () => {
      const event = new Event({
        id: 1,
        type: 'test',
        textKey: 'test',
        icon: 'test.png',
      })
      expect(event.params).toEqual([])
      expect(event.buildingKey).toBeNull()
      expect(event.researchKey).toBeNull()
      expect(event.action).toBeNull()
    })

    it('should set optional fields when provided', () => {
      const event = new Event({
        id: 1,
        type: 'test',
        textKey: 'test',
        icon: 'test.png',
        params: ['Farm'],
        buildingKey: 'farm',
        researchKey: 'transportation1',
        action: 'openModal',
      })
      expect(event.params).toEqual(['Farm'])
      expect(event.buildingKey).toBe('farm')
      expect(event.researchKey).toBe('transportation1')
      expect(event.action).toBe('openModal')
    })
  })

  describe('toJSON', () => {
    it('should return a serializable snapshot', () => {
      const event = new Event({
        id: 5,
        type: 'building_upgrade',
        textKey: 'event.buildingUpgrade',
        icon: '/img/buildings/farm.png',
        buildingKey: 'farm',
      })
      const json = event.toJSON()
      expect(json.id).toBe(5)
      expect(json.type).toBe('building_upgrade')
      expect(json.buildingKey).toBe('farm')
    })
  })
})
