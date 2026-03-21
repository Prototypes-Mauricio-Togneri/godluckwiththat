import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_FARM} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Farm from '@/js/models/buildings/farm.js'

describe('Farm', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      const farm = new Farm({
        level: 1,
      })
      expect(farm.levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const farm = new Farm({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_FARM]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(farm.levelUpCost.wood).toBe(expected.wood)
    })

    it('should increase with level', () => {
      const level1 = new Farm({
        level: 1,
      })
      const level5 = new Farm({
        level: 5,
      })
      expect(level5.levelUpCost.wood).toBeGreaterThan(level1.levelUpCost.wood)
    })
  })
})
