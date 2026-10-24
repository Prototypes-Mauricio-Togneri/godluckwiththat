import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES, TOWER_ARCHERS_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_TOWER} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Tower from '@/js/models/buildings/tower.js'

describe('Tower', () => {
  describe('archers', () => {
    it('should be 0 while the tower is unbuilt', () => {
      expect(new Tower({
        level: 0,
      }).archers).toBe(0)
    })

    it('should be level × TOWER_ARCHERS_PER_LEVEL', () => {
      expect(new Tower({
        level: 3,
      }).archers).toBe(3 * TOWER_ARCHERS_PER_LEVEL)
    })

    it('should increase with level', () => {
      expect(new Tower({
        level: 2,
      }).archers).toBeGreaterThan(new Tower({
        level: 1,
      }).archers)
    })
  })

  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Tower({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const tower = new Tower({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_TOWER]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(tower.levelUpCost.wood).toBe(expected.wood)
      expect(tower.levelUpCost.stone).toBe(expected.stone)
    })

    it('should increase with level', () => {
      expect(new Tower({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new Tower({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
