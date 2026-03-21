import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES, HOUSE_POPULATION_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_HOUSE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import House from '@/js/models/buildings/house.js'

describe('House', () => {
  describe('populationCap', () => {
    it('should return level times population per level with no bonus', () => {
      const house = new House({
        level: 3,
      })
      expect(house.populationCap()).toBe(3 * HOUSE_POPULATION_PER_LEVEL)
    })

    it('should add flat habitation bonus per level', () => {
      const house = new House({
        level: 3,
      })
      const bonus = 2
      expect(house.populationCap(bonus)).toBe(3 * (HOUSE_POPULATION_PER_LEVEL + bonus))
    })

    it('should return 0 for unbuilt house', () => {
      const house = new House({
        level: 0,
      })
      expect(house.populationCap()).toBe(0)
    })
  })

  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new House({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })

    it('should match formula: baseCost * multiplier ^ level', () => {
      const house = new House({
        level: 3,
      })
      const {
        cost, multiplier,
      } = BUILDING_UPGRADES[BUILDING_HOUSE]
      const expected = cost.multiplyFloor(Math.pow(multiplier, 3))
      expect(house.levelUpCost.wood).toBe(expected.wood)
    })

    it('should increase with level', () => {
      expect(new House({
        level: 5,
      }).levelUpCost.wood).toBeGreaterThan(new House({
        level: 1,
      }).levelUpCost.wood)
    })
  })
})
