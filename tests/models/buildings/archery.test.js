import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_ARCHERY} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Archery from '@/js/models/buildings/archery.js'

describe('Archery', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Archery({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const archery = new Archery({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_ARCHERY]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(archery.levelUpCost.wood).toBe(expected.wood)
      expect(archery.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Archery({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Archery({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
