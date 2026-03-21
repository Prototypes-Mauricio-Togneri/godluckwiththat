import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES, HQ_TERRITORY_PER_LEVEL, HQ_UPGRADE_COSTS} from '@/js/engine/balancing.js'
import {BUILDING_HEADQUARTERS, HQ_TYPE_CAMP, HQ_TYPE_CITY, HQ_TYPE_SETTLEMENT, HQ_TYPE_VILLAGE} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import {createCost, createHeadquarters} from '../../helpers/factories.js'

describe('Headquarters', () => {
  describe('constructor', () => {
    it('should set type and inherit Building fields', () => {
      const headquarters = createHeadquarters({
        level: 2,
        type: HQ_TYPE_SETTLEMENT,
      })
      expect(headquarters.level).toBe(2)
      expect(headquarters.type).toBe(HQ_TYPE_SETTLEMENT)
      expect(headquarters.upgradeRemaining).toBe(0)
      expect(headquarters.upgradeDuration).toBe(0)
    })
  })

  describe('isUpgrading', () => {
    it('should return false when not upgrading', () => {
      const headquarters = createHeadquarters()
      expect(headquarters.isUpgrading).toBe(false)
    })

    it('should return true when upgrade is in progress', () => {
      const headquarters = createHeadquarters({
        upgradeRemaining: 10,
      })
      expect(headquarters.isUpgrading).toBe(true)
    })
  })

  describe('isMaxType', () => {
    it('should return false for non-max types', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CAMP,
      })
      expect(headquarters.isMaxType).toBe(false)
    })

    it('should return true for city', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CITY,
      })
      expect(headquarters.isMaxType).toBe(true)
    })
  })

  describe('territoryCap', () => {
    it('should return level times territory per level', () => {
      const headquarters = createHeadquarters({
        level: 5,
      })
      expect(headquarters.territoryCap).toBe(5 * HQ_TERRITORY_PER_LEVEL)
    })
  })

  describe('levelUpCost', () => {
    it('should return base cost at level 1', () => {
      const headquarters = createHeadquarters({
        level: 1,
      })
      const cost = headquarters.levelUpCost
      const {
        cost: baseCost,
      } = BUILDING_UPGRADES[BUILDING_HEADQUARTERS]
      expect(cost.food).toBe(baseCost.food)
      expect(cost.wood).toBe(baseCost.wood)
    })

    it('should scale exponentially with level', () => {
      const level1 = createHeadquarters({
        level: 1,
      })
      const level5 = createHeadquarters({
        level: 5,
      })
      expect(level5.levelUpCost.food).toBeGreaterThan(level1.levelUpCost.food)
    })

    it('should return a Cost instance', () => {
      const headquarters = createHeadquarters({
        level: 3,
      })
      expect(headquarters.levelUpCost).toBeInstanceOf(Cost)
    })
  })

  describe('upgradeCost', () => {
    it('should return a Cost for non-max types', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CAMP,
      })
      expect(headquarters.upgradeCost).toBe(HQ_UPGRADE_COSTS[HQ_TYPE_CAMP])
    })

    it('should return null for max type', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CITY,
      })
      expect(headquarters.upgradeCost).toBeNull()
    })
  })

  describe('nextType', () => {
    it('should return settlement for camp', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CAMP,
      })
      expect(headquarters.nextType).toBe(HQ_TYPE_SETTLEMENT)
    })

    it('should return village for settlement', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_SETTLEMENT,
      })
      expect(headquarters.nextType).toBe(HQ_TYPE_VILLAGE)
    })

    it('should return null for city', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CITY,
      })
      expect(headquarters.nextType).toBeNull()
    })
  })

  describe('upgradeType', () => {
    it('should set upgrade duration and remaining', () => {
      const headquarters = createHeadquarters()
      const cost = createCost({
        wood: 300,
      })
      const duration = headquarters.upgradeType(cost)
      expect(duration).toBeGreaterThan(0)
      expect(headquarters.upgradeRemaining).toBe(duration)
      expect(headquarters.upgradeDuration).toBe(duration)
    })
  })

  describe('advanceUpgrade', () => {
    it('should return false when not upgrading', () => {
      const headquarters = createHeadquarters()
      expect(headquarters.advanceUpgrade(1)).toBe(false)
    })

    it('should decrement upgradeRemaining', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CAMP,
        upgradeRemaining: 10,
        upgradeDuration: 10,
      })
      headquarters.advanceUpgrade(3)
      expect(headquarters.upgradeRemaining).toBe(7)
    })

    it('should complete upgrade and advance type', () => {
      const headquarters = createHeadquarters({
        type: HQ_TYPE_CAMP,
        upgradeRemaining: 5,
        upgradeDuration: 5,
      })
      const completed = headquarters.advanceUpgrade(5)
      expect(completed).toBe(true)
      expect(headquarters.type).toBe(HQ_TYPE_SETTLEMENT)
      expect(headquarters.upgradeRemaining).toBe(0)
      expect(headquarters.upgradeDuration).toBe(0)
    })
  })

  describe('toJSON', () => {
    it('should include type and upgrade fields', () => {
      const headquarters = createHeadquarters({
        level: 3,
        type: HQ_TYPE_VILLAGE,
        upgradeRemaining: 5,
        upgradeDuration: 10,
      })
      const json = headquarters.toJSON()
      expect(json.level).toBe(3)
      expect(json.type).toBe(HQ_TYPE_VILLAGE)
      expect(json.upgradeRemaining).toBe(5)
      expect(json.upgradeDuration).toBe(10)
    })
  })
})
