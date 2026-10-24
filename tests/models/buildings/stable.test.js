import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES, MILITARY_UNITS_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_STABLE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Stable from '@/js/models/buildings/stable.js'

describe('Stable', () => {
  describe('unitCap', () => {
    it('should be 0 while the building is unbuilt', () => {
      expect(new Stable({
        level: 0,
      }).unitCap).toBe(0)
    })

    it('should be level × MILITARY_UNITS_PER_LEVEL', () => {
      expect(new Stable({
        level: 3,
      }).unitCap).toBe(3 * MILITARY_UNITS_PER_LEVEL)
    })

    it('should increase with level', () => {
      expect(new Stable({
        level: 2,
      }).unitCap).toBeGreaterThan(new Stable({
        level: 1,
      }).unitCap)
    })
  })

  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Stable({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const stable = new Stable({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_STABLE]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(stable.levelUpCost.wood).toBe(expected.wood)
      expect(stable.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Stable({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Stable({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
