import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_TEMPLE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Temple from '@/js/models/buildings/temple.js'

describe('Temple', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Temple({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const temple = new Temple({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_TEMPLE]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(temple.levelUpCost.wood).toBe(expected.wood)
      expect(temple.levelUpCost.stone).toBe(expected.stone)
    })

    it('should not lose a unit to float rounding at level 2', () => {
      const temple = new Temple({
        level: 2,
      })
      expect(temple.levelUpCost.wood).toBe(98)
      expect(temple.levelUpCost.stone).toBe(49)
    })

    it('should increase with level', () => {
      expect(new Temple({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Temple({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
