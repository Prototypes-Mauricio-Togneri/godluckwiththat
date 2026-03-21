import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_QUARRY} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Quarry from '@/js/models/buildings/quarry.js'

describe('Quarry', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Quarry({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const quarry = new Quarry({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_QUARRY]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(quarry.levelUpCost.wood).toBe(expected.wood)
    })

    it('should increase with level', () => {
      expect(new Quarry({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Quarry({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
