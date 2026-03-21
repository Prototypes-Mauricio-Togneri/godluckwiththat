import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_WALL} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Wall from '@/js/models/buildings/wall.js'

describe('Wall', () => {
  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Wall({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const wall = new Wall({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_WALL]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(wall.levelUpCost.wood).toBe(expected.wood)
      expect(wall.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Wall({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Wall({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
