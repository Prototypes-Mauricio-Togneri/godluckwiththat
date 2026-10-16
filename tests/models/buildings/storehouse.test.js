import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES, STOREHOUSE_BASE_CAPACITY, STOREHOUSE_CAPACITY_MULTIPLIER} from '@/js/engine/balancing.js'
import {BUILDING_STOREHOUSE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Storehouse from '@/js/models/buildings/storehouse.js'

describe('Storehouse', () => {
  describe('storageCap', () => {
    it('should compute base capacity at level 1 with no bonus', () => {
      const storehouse = new Storehouse({
        level: 1,
      })
      const expected = Math.floor(STOREHOUSE_BASE_CAPACITY * STOREHOUSE_CAPACITY_MULTIPLIER)
      expect(storehouse.storageCap()).toBe(expected)
    })

    it('should increase with level', () => {
      const level1 = new Storehouse({
        level: 1,
      })
      const level5 = new Storehouse({
        level: 5,
      })
      expect(level5.storageCap()).toBeGreaterThan(level1.storageCap())
    })

    it('should apply storage bonus', () => {
      const storehouse = new Storehouse({
        level: 3,
      })
      const withoutBonus = storehouse.storageCap(0)
      const withBonus = storehouse.storageCap(0.25)
      expect(withBonus).toBeGreaterThan(withoutBonus)
    })

    it('should not lose a unit when the exact capacity is a whole number', () => {
      const storehouse = new Storehouse({
        level: 3,
      })
      expect(storehouse.storageCap()).toBe(864)
    })

    it('should floor the result', () => {
      const storehouse = new Storehouse({
        level: 2,
      })
      expect(Number.isInteger(storehouse.storageCap(0.1))).toBe(true)
    })
  })

  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Storehouse({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const storehouse = new Storehouse({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_STOREHOUSE]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(storehouse.levelUpCost.wood).toBe(expected.wood)
      expect(storehouse.levelUpCost.stone).toBe(expected.stone)
    })
  })
})
