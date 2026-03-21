import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_BARRACKS} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Barracks from '@/js/models/buildings/barracks.js'

describe('Barracks', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Barracks({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const barracks = new Barracks({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_BARRACKS]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(barracks.levelUpCost.wood).toBe(expected.wood)
      expect(barracks.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Barracks({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Barracks({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
