import {describe, it, expect} from 'vitest'
import Production from '@/js/models/production.js'

describe('Production', () => {
  describe('constructor', () => {
    it('should set all fields to default values', () => {
      const production = new Production({})
      expect(production.food).toBe(0)
      expect(production.wood).toBe(0)
      expect(production.stone).toBe(0)
      expect(production.copper).toBe(0)
      expect(production.iron).toBe(0)
      expect(production.gold).toBe(0)
      expect(production.faith).toBe(0)
      expect(production.knowledge).toBe(0)
    })

    it('should accept override values', () => {
      const production = new Production({
        food: 5,
        wood: 3,
        stone: 2,
        copper: 1.5,
        iron: 0.8,
        gold: 0.3,
        faith: 0.1,
        knowledge: 0.05,
      })
      expect(production.food).toBe(5)
      expect(production.wood).toBe(3)
      expect(production.stone).toBe(2)
      expect(production.copper).toBe(1.5)
      expect(production.iron).toBe(0.8)
      expect(production.gold).toBe(0.3)
      expect(production.faith).toBe(0.1)
      expect(production.knowledge).toBe(0.05)
    })
  })
})
