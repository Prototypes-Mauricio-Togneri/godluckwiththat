import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_WORKSHOP} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Workshop from '@/js/models/buildings/workshop.js'

describe('Workshop', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Workshop({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const workshop = new Workshop({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_WORKSHOP]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(workshop.levelUpCost.wood).toBe(expected.wood)
      expect(workshop.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Workshop({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Workshop({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
