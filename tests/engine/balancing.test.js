import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES,
  MARKET_BASE_FEE,
  MARKET_MIN_FEE,
  SEASON_WARM_FOOD_MODIFIER,
  SEASON_COLD_FOOD_MODIFIER,
  SEASON_WARM_WOOD_MODIFIER,
  SEASON_COLD_WOOD_MODIFIER} from '@/js/engine/balancing.js'
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
