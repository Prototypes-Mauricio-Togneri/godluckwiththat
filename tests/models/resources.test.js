import {describe, it, expect} from 'vitest'
import Resources from '@/js/models/resources.js'
import {createResources, createCost} from '../helpers/factories.js'

describe('Resources', () => {
  describe('constructor', () => {
    it('should set provided values', () => {
      const resources = createResources({
        food: 500,
        workers: 10,
      })
      expect(resources.food).toBe(500)
      expect(resources.workers).toBe(10)
    })

    it('should default all values to 0', () => {
      const resources = new Resources({})
      expect(resources.territory).toBe(0)
      expect(resources.territoryBonus).toBe(0)
      expect(resources.workers).toBe(0)
      expect(resources.food).toBe(0)
      expect(resources.wood).toBe(0)
      expect(resources.stone).toBe(0)
      expect(resources.copper).toBe(0)
      expect(resources.iron).toBe(0)
      expect(resources.gold).toBe(0)
      expect(resources.faith).toBe(0)
      expect(resources.knowledge).toBe(0)
    })
  })

  describe('canAfford', () => {
    it('should return true when resources exceed cost', () => {
      const resources = createResources({
        food: 100,
        wood: 100,
      })
      const cost = createCost({
        food: 50,
        wood: 30,
      })
      expect(resources.canAfford(cost)).toBe(true)
    })

    it('should return true when resources exactly match cost', () => {
      const resources = createResources({
        food: 50,
      })
      const cost = createCost({
        food: 50,
      })
      expect(resources.canAfford(cost)).toBe(true)
    })

    it('should return false when any resource is insufficient', () => {
      const resources = createResources({
        food: 49,
      })
      const cost = createCost({
        food: 50,
      })
      expect(resources.canAfford(cost)).toBe(false)
    })
  })

  describe('deduct', () => {
    it('should subtract cost from resources', () => {
      const resources = createResources({
        food: 100,
        wood: 80,
      })
      const cost = createCost({
        food: 30,
        wood: 20,
      })
      resources.deduct(cost)
      expect(resources.food).toBe(70)
      expect(resources.wood).toBe(60)
    })

    it('should clamp resources at 0', () => {
      const resources = createResources({
        food: 10,
      })
      const cost = createCost({
        food: 50,
      })
      resources.deduct(cost)
      expect(resources.food).toBe(0)
    })

    it('should not affect resources not in cost', () => {
      const resources = createResources({
        food: 100,
        stone: 50,
      })
      const cost = createCost({
        food: 30,
      })
      resources.deduct(cost)
      expect(resources.stone).toBe(50)
    })
  })

  describe('toJSON', () => {
    it('should return a plain object with all properties', () => {
      const resources = createResources({
        food: 100,
        workers: 5,
        territory: 3,
      })
      const json = resources.toJSON()
      expect(json.food).toBe(100)
      expect(json.workers).toBe(5)
      expect(json.territory).toBe(3)
      expect(json).toHaveProperty('territoryBonus')
      expect(json).toHaveProperty('knowledge')
      expect(json).toHaveProperty('faith')
    })

    it('should produce a snapshot that can reconstruct Resources', () => {
      const original = createResources({
        food: 42,
        wood: 99,
        workers: 7,
      })
      const restored = new Resources(original.toJSON())
      expect(restored.food).toBe(42)
      expect(restored.wood).toBe(99)
      expect(restored.workers).toBe(7)
    })
  })
})
