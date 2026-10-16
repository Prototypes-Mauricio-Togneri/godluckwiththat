import {describe, it, expect} from 'vitest'
import {RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import {createCost} from '../helpers/factories.js'

describe('Cost', () => {
  describe('constructor', () => {
    it('should default all resources to 0', () => {
      const cost = new Cost()
      expect(cost.food).toBe(0)
      expect(cost.wood).toBe(0)
      expect(cost.stone).toBe(0)
      expect(cost.copper).toBe(0)
      expect(cost.iron).toBe(0)
      expect(cost.gold).toBe(0)
      expect(cost.knowledge).toBe(0)
      expect(cost.faith).toBe(0)
    })

    it('should set provided values', () => {
      const cost = createCost({
        food: 50,
        wood: 30,
      })
      expect(cost.food).toBe(50)
      expect(cost.wood).toBe(30)
      expect(cost.stone).toBe(0)
    })
  })

  describe('entries', () => {
    it('should return only non-zero resources', () => {
      const cost = createCost({
        food: 10,
        wood: 5,
      })
      const entries = cost.entries
      expect(entries.size).toBe(2)
      expect(entries.get(RESOURCE_FOOD)).toBe(10)
      expect(entries.get(RESOURCE_WOOD)).toBe(5)
    })

    it('should return empty map when all resources are 0', () => {
      const cost = new Cost()
      expect(cost.entries.size).toBe(0)
    })

    it('should include all 8 resources when all are non-zero', () => {
      const cost = createCost({
        food: 1,
        wood: 2,
        stone: 3,
        copper: 4,
        iron: 5,
        gold: 6,
        knowledge: 7,
        faith: 8,
      })
      const entries = cost.entries
      expect(entries.size).toBe(8)
      expect(entries.get(RESOURCE_FOOD)).toBe(1)
      expect(entries.get(RESOURCE_WOOD)).toBe(2)
      expect(entries.get(RESOURCE_STONE)).toBe(3)
      expect(entries.get(RESOURCE_COPPER)).toBe(4)
      expect(entries.get(RESOURCE_IRON)).toBe(5)
      expect(entries.get(RESOURCE_GOLD)).toBe(6)
      expect(entries.get(RESOURCE_KNOWLEDGE)).toBe(7)
      expect(entries.get(RESOURCE_FAITH)).toBe(8)
    })

    it('should cache the entries map', () => {
      const cost = createCost({
        food: 10,
      })
      const firstCall = cost.entries
      const secondCall = cost.entries
      expect(firstCall).toBe(secondCall)
    })
  })

  describe('multiplyFloor', () => {
    it('should multiply all resources and floor the results', () => {
      const cost = createCost({
        food: 10,
        wood: 7,
      })
      const result = cost.multiplyFloor(1.5)
      expect(result.food).toBe(15)
      expect(result.wood).toBe(10)
    })

    it('should return a new Cost instance', () => {
      const cost = createCost({
        food: 10,
      })
      const result = cost.multiplyFloor(2)
      expect(result).not.toBe(cost)
      expect(result).toBeInstanceOf(Cost)
    })

    it('should handle fractional results by flooring', () => {
      const cost = createCost({
        food: 3,
      })
      const result = cost.multiplyFloor(1.4)
      expect(result.food).toBe(4)
    })

    it('should not lose a unit when a whole-number product evaluates slightly low', () => {
      const cost = createCost({
        wood: 50,
        stone: 25,
      })
      const result = cost.multiplyFloor(Math.pow(1.4, 2))
      expect(result.wood).toBe(98)
      expect(result.stone).toBe(49)
    })

    it('should handle factor of 0', () => {
      const cost = createCost({
        food: 100,
        wood: 200,
      })
      const result = cost.multiplyFloor(0)
      expect(result.food).toBe(0)
      expect(result.wood).toBe(0)
    })

    it('should shrink values with factor less than 1', () => {
      const cost = createCost({
        food: 100,
        wood: 50,
        stone: 1,
      })
      const result = cost.multiplyFloor(0.5)
      expect(result.food).toBe(50)
      expect(result.wood).toBe(25)
      expect(result.stone).toBe(0)
    })
  })

  describe('toSeconds', () => {
    it('should compute build time from weighted resource sum', () => {
      const cost = createCost({
        food: 100,
        wood: 100,
      })
      const seconds = cost.toSeconds
      expect(seconds).toBeGreaterThan(0)
      expect(Number.isInteger(seconds)).toBe(true)
    })

    it('should return 0 for a zero cost', () => {
      const cost = new Cost()
      expect(cost.toSeconds).toBe(0)
    })

    it('should increase with higher resource amounts', () => {
      const smallCost = createCost({
        food: 10,
      })
      const largeCost = createCost({
        food: 100,
      })
      expect(largeCost.toSeconds).toBeGreaterThan(smallCost.toSeconds)
    })

    it('should floor the result to an integer', () => {
      const cost = createCost({
        food: 33,
        wood: 17,
        stone: 7,
      })
      expect(Number.isInteger(cost.toSeconds)).toBe(true)
    })

    it('should only weight non-zero resources', () => {
      const withZeros = createCost({
        food: 100,
        wood: 0,
        stone: 0,
      })
      const foodOnly = createCost({
        food: 100,
      })
      expect(withZeros.toSeconds).toBe(foodOnly.toSeconds)
    })

    it('should treat unknown resource keys as zero weight', () => {
      const cost = new Cost()
      cost._entries = new Map([
        [
          'unknownResource',
          100,
        ],
      ])
      expect(cost.toSeconds).toBe(0)
    })
  })
})
