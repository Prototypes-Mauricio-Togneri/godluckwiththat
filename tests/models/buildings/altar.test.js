import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_ALTAR} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Altar from '@/js/models/buildings/altar.js'

describe('Altar', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Altar({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const altar = new Altar({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_ALTAR]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(altar.levelUpCost.wood).toBe(expected.wood)
    })

    it('should increase with level', () => {
      expect(new Altar({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Altar({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
