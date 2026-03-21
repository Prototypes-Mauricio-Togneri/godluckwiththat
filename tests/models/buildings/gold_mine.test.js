import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_GOLD_MINE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import GoldMine from '@/js/models/buildings/gold_mine.js'

describe('GoldMine', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new GoldMine({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const mine = new GoldMine({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_GOLD_MINE]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(mine.levelUpCost.wood).toBe(expected.wood)
      expect(mine.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new GoldMine({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new GoldMine({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
