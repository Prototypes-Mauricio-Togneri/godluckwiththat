import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_MONUMENT} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Monument from '@/js/models/buildings/monument.js'

describe('Monument', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Monument({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const monument = new Monument({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_MONUMENT]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(monument.levelUpCost.wood).toBe(expected.wood)
      expect(monument.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Monument({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Monument({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
