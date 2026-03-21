import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_WOODCUTTER} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Woodcutter from '@/js/models/buildings/woodcutter.js'

describe('Woodcutter', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      const woodcutter = new Woodcutter({
        level: 1,
      })
      expect(woodcutter.levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const woodcutter = new Woodcutter({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_WOODCUTTER]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(woodcutter.levelUpCost.wood).toBe(expected.wood)
    })

    it('should increase with level', () => {
      const level1 = new Woodcutter({
        level: 1,
      })
      const level5 = new Woodcutter({
        level: 5,
      })
      expect(level5.levelUpCost.wood).toBeGreaterThan(level1.levelUpCost.wood)
    })
  })
})
