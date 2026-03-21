import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_COPPER_MINE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import CopperMine from '@/js/models/buildings/copper_mine.js'

describe('CopperMine', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new CopperMine({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const mine = new CopperMine({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_COPPER_MINE]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(mine.levelUpCost.wood).toBe(expected.wood)
      expect(mine.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new CopperMine({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new CopperMine({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
