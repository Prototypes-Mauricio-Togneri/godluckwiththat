import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES,
  MARKET_BASE_FEE,
  MARKET_MIN_FEE,
  RESEARCH_SUBCATEGORY_BONUSES,
  RESEARCH_SUBCATEGORY_COST_MULTIPLIERS,
  RESEARCH_TIER_COSTS,
  RESEARCH_TIME_MULTIPLIER,
  SEASON_WARM_FOOD_MODIFIER,
  SEASON_COLD_FOOD_MODIFIER,
  SEASON_WARM_WOOD_MODIFIER,
  SEASON_COLD_WOOD_MODIFIER} from '@/js/engine/balancing.js'
import * as enums from '@/js/engine/enums.js'
import {RESOURCE_COPPER, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import {VALID_BUILDING_KEYS} from '../helpers/building_keys.js'

describe('balancing', () => {
  describe('BUILDING_UPGRADES', () => {
    it('every key corresponds to a valid BUILDING_* enum', () => {
      for (const key of Object.keys(BUILDING_UPGRADES)) {
        expect(VALID_BUILDING_KEYS.has(key), `unexpected key "${key}"`).toBe(true)
      }
    })

    it('all cost values are Cost instances with positive values', () => {
      for (const [
        key,
        upgrade,
      ] of Object.entries(BUILDING_UPGRADES)) {
        expect(upgrade.cost, `${key}.cost`).toBeInstanceOf(Cost)
        expect(upgrade.cost.entries.size, `${key}.cost has no positive resources`).toBeGreaterThan(0)
      }
    })

    it('all multiplier values are greater than 1', () => {
      for (const [
        key,
        upgrade,
      ] of Object.entries(BUILDING_UPGRADES)) {
        expect(upgrade.multiplier, `${key}.multiplier`).toBeGreaterThan(1)
      }
    })
  })

  describe('season multipliers', () => {
    const seasonModifiers = [
      {
        name: 'SEASON_WARM_FOOD_MODIFIER',
        value: SEASON_WARM_FOOD_MODIFIER,
      },
      {
        name: 'SEASON_COLD_FOOD_MODIFIER',
        value: SEASON_COLD_FOOD_MODIFIER,
      },
      {
        name: 'SEASON_WARM_WOOD_MODIFIER',
        value: SEASON_WARM_WOOD_MODIFIER,
      },
      {
        name: 'SEASON_COLD_WOOD_MODIFIER',
        value: SEASON_COLD_WOOD_MODIFIER,
      },
    ]

    it.each(seasonModifiers)('$name effective multiplier is between 0 and 2', ({
      value,
    }) => {
      const effectiveMultiplier = 1 + value
      expect(effectiveMultiplier).toBeGreaterThanOrEqual(0)
      expect(effectiveMultiplier).toBeLessThanOrEqual(2)
    })
  })

  describe('RESEARCH_TIER_COSTS', () => {
    const tierResources = [
      [
        RESOURCE_FOOD,
        RESOURCE_WOOD,
      ],
      [
        RESOURCE_WOOD,
        RESOURCE_STONE,
      ],
      [
        RESOURCE_STONE,
        RESOURCE_COPPER,
      ],
      [
        RESOURCE_COPPER,
        RESOURCE_IRON,
      ],
      [
        RESOURCE_IRON,
        RESOURCE_GOLD,
      ],
    ]

    it('has one Cost per tier', () => {
      expect(RESEARCH_TIER_COSTS).toHaveLength(5)
      for (const cost of RESEARCH_TIER_COSTS) {
        expect(cost).toBeInstanceOf(Cost)
      }
    })

    it('knowledge rises with each tier', () => {
      for (let i = 1; i < RESEARCH_TIER_COSTS.length; i++) {
        expect(RESEARCH_TIER_COSTS[i].knowledge, `tier ${i + 1}`).toBeGreaterThan(RESEARCH_TIER_COSTS[i - 1].knowledge)
      }
    })

    it.each(tierResources.map((resources, index) => ({
      tier: index + 1,
      resources: resources,
    })))('tier $tier costs knowledge plus $resources', ({
      tier, resources,
    }) => {
      const cost = RESEARCH_TIER_COSTS[tier - 1]
      expect(new Set(cost.entries.keys())).toEqual(new Set([
        ...resources,
        RESOURCE_KNOWLEDGE,
      ]))
    })
  })

  describe('RESEARCH_SUBCATEGORY_COST_MULTIPLIERS', () => {
    const subcategoryKeys = Object.keys(enums)
      .filter(name => name.startsWith('RESEARCH_SUBCATEGORY_'))
      .map(name => enums[name])

    it('has a positive multiplier for every RESEARCH_SUBCATEGORY_* key and no others', () => {
      expect(new Set(Object.keys(RESEARCH_SUBCATEGORY_COST_MULTIPLIERS))).toEqual(new Set(subcategoryKeys))
      for (const key of subcategoryKeys) {
        expect(RESEARCH_SUBCATEGORY_COST_MULTIPLIERS[key], key).toBeGreaterThan(0)
      }
    })
  })

  describe('RESEARCH_TIME_MULTIPLIER', () => {
    it('is at least 1', () => {
      expect(RESEARCH_TIME_MULTIPLIER).toBeGreaterThanOrEqual(1)
    })
  })

  describe('RESEARCH_SUBCATEGORY_BONUSES', () => {
    it('every bonus is shown as a whole number (percent, or flat amount)', () => {
      for (const [
        key,
        bonus,
      ] of Object.entries(RESEARCH_SUBCATEGORY_BONUSES)) {
        const shown = bonus.flat ? bonus.value : bonus.value * 100
        expect(Number.isInteger(shown), `${key} shows ${shown}`).toBe(true)
      }
    })
  })

  describe('trade fees', () => {
    it('MARKET_BASE_FEE is between 0 and 1', () => {
      expect(MARKET_BASE_FEE).toBeGreaterThanOrEqual(0)
      expect(MARKET_BASE_FEE).toBeLessThanOrEqual(1)
    })

    it('MARKET_MIN_FEE is between 0 and 1', () => {
      expect(MARKET_MIN_FEE).toBeGreaterThanOrEqual(0)
      expect(MARKET_MIN_FEE).toBeLessThanOrEqual(1)
    })
  })
})
