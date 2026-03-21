import {describe, it, expect} from 'vitest'
import {MARKET_BASE_FEE, MARKET_BASE_PRICES, MARKET_MAX_CURRENT_PRICE, MARKET_MIN_CURRENT_PRICE, MARKET_MIN_FEE, MARKET_PRICE_SHIFT, MARKET_TRADE_AMOUNT} from '@/js/engine/balancing.js'
import {RESOURCE_FOOD, RESOURCE_WOOD, TRADE_BUY, TRADE_SELL} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Market from '@/js/models/buildings/market.js'
import {createResources} from '../../helpers/factories.js'

describe('Market', () => {
  describe('constructor', () => {
    it('should default prices to base prices', () => {
      const market = new Market({
        level: 1,
      })
      expect(market[RESOURCE_FOOD]).toBe(MARKET_BASE_PRICES[RESOURCE_FOOD])
      expect(market[RESOURCE_WOOD]).toBe(MARKET_BASE_PRICES[RESOURCE_WOOD])
    })

    it('should accept price overrides', () => {
      const market = new Market({
        level: 1,
        food: 200,
      })
      expect(market[RESOURCE_FOOD]).toBe(200)
    })
  })

  describe('levelUpCost', () => {
    it('should return a Cost instance', () => {
      expect(new Market({
        level: 1,
      }).levelUpCost).toBeInstanceOf(Cost)
    })
  })

  describe('effectiveTradeFee', () => {
    it('should return base fee at level 1', () => {
      const market = new Market({
        level: 1,
      })
      expect(market.effectiveTradeFee).toBe(MARKET_BASE_FEE)
    })

    it('should reduce fee with higher levels', () => {
      const market = new Market({
        level: 10,
      })
      expect(market.effectiveTradeFee).toBeLessThan(MARKET_BASE_FEE)
    })

    it('should not go below minimum fee', () => {
      const market = new Market({
        level: 100,
      })
      expect(market.effectiveTradeFee).toBe(MARKET_MIN_FEE)
    })

    it('should return 0 when blessedMarkets is true', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      expect(market.effectiveTradeFee).toBe(0)
    })
  })

  describe('buyPrice', () => {
    it('should include fee markup', () => {
      const market = new Market({
        level: 1,
      })
      const basePrice = market[RESOURCE_FOOD]
      const buyPrice = market.buyPrice(RESOURCE_FOOD)
      expect(buyPrice).toBeGreaterThan(basePrice)
    })

    it('should equal base price when fee is zero (blessed)', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      const basePrice = market[RESOURCE_FOOD]
      expect(market.buyPrice(RESOURCE_FOOD)).toBe(basePrice)
    })

    it('should use minimum fee at very high level', () => {
      const market = new Market({
        level: 100,
      })
      const basePrice = market[RESOURCE_FOOD]
      const expected = Math.floor(basePrice * (1 + MARKET_MIN_FEE))
      expect(market.buyPrice(RESOURCE_FOOD)).toBe(expected)
    })
  })

  describe('sellPrice', () => {
    it('should apply fee discount', () => {
      const market = new Market({
        level: 1,
      })
      const basePrice = market[RESOURCE_FOOD]
      const sellPrice = market.sellPrice(RESOURCE_FOOD)
      expect(sellPrice).toBeLessThan(basePrice)
    })

    it('should equal base price when fee is zero (blessed)', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      const basePrice = market[RESOURCE_FOOD]
      expect(market.sellPrice(RESOURCE_FOOD)).toBe(basePrice)
    })

    it('should use minimum fee at very high level', () => {
      const market = new Market({
        level: 100,
      })
      const basePrice = market[RESOURCE_FOOD]
      const expected = Math.floor(basePrice * (1 - MARKET_MIN_FEE))
      expect(market.sellPrice(RESOURCE_FOOD)).toBe(expected)
    })
  })

  describe('executeTrade', () => {
    it('should buy: deduct gold, add resource, raise price', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 5000,
        food: 0,
      })
      const storageCap = 10000
      const goldBefore = resources.gold
      const priceBefore = market[RESOURCE_FOOD]

      const result = market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, storageCap)
      expect(result).toBe(true)
      expect(resources.gold).toBeLessThan(goldBefore)
      expect(resources.food).toBe(MARKET_TRADE_AMOUNT)
      expect(market[RESOURCE_FOOD]).toBe(priceBefore + MARKET_PRICE_SHIFT)
    })

    it('should sell: deduct resource, add gold, lower price', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 0,
        food: 500,
      })
      const storageCap = 10000
      const priceBefore = market[RESOURCE_FOOD]

      const result = market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, storageCap)
      expect(result).toBe(true)
      expect(resources.food).toBe(400)
      expect(resources.gold).toBeGreaterThan(0)
      expect(market[RESOURCE_FOOD]).toBe(priceBefore - MARKET_PRICE_SHIFT)
    })

    it('should reject buy when gold is insufficient', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 0,
        food: 0,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000)).toBe(false)
    })

    it('should reject sell when resource is insufficient', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 0,
        food: 0,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 10000)).toBe(false)
    })

    it('should reject buy when it would exceed storage cap', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 5000,
        food: 950,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 1000)).toBe(false)
    })

    it('should reject when level is 0', () => {
      const market = new Market({
        level: 0,
      })
      const resources = createResources({
        gold: 5000,
        food: 500,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000)).toBe(false)
    })

    it('should reject invalid amounts', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 5000,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000, 0)).toBe(false)
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000, 50)).toBe(false)
    })

    it('should succeed when gold exactly covers buy price', () => {
      const market = new Market({
        level: 1,
      })
      const exactGold = market.buyPrice(RESOURCE_FOOD)
      const resources = createResources({
        gold: exactGold,
        food: 0,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000)).toBe(true)
      expect(resources.gold).toBe(0)
      expect(resources.food).toBe(MARKET_TRADE_AMOUNT)
    })

    it('should reject sell when gold gained would exceed storage cap', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 990,
        food: 500,
      })
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 1000)).toBe(false)
    })

    it('should succeed sell when gold + sellPrice exactly equals storage cap', () => {
      const market = new Market({
        level: 1,
      })
      const sellPrice = market.sellPrice(RESOURCE_FOOD)
      const storageCap = 5000
      const resources = createResources({
        gold: storageCap - sellPrice,
        food: 500,
      })
      const result = market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, storageCap)
      expect(result).toBe(true)
      expect(resources.gold).toBe(storageCap)
    })

    it('should clamp price at maximum after repeated buys', () => {
      const market = new Market({
        level: 1,
        [RESOURCE_FOOD]: MARKET_MAX_CURRENT_PRICE,
      })
      const resources = createResources({
        gold: 99999,
        food: 0,
      })
      market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999)
      expect(market[RESOURCE_FOOD]).toBe(MARKET_MAX_CURRENT_PRICE)
    })

    it('should clamp price at minimum after repeated sells', () => {
      const market = new Market({
        level: 1,
        [RESOURCE_FOOD]: MARKET_MIN_CURRENT_PRICE,
      })
      const resources = createResources({
        gold: 0,
        food: 500,
      })
      market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999)
      expect(market[RESOURCE_FOOD]).toBe(MARKET_MIN_CURRENT_PRICE)
    })

    it('should accept valid multi-unit trades', () => {
      const market = new Market({
        level: 1,
      })
      const resources = createResources({
        gold: 99999,
        food: 0,
      })
      const amount = MARKET_TRADE_AMOUNT * 3
      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999, amount)).toBe(true)
      expect(resources.food).toBe(amount)
    })
  })

  describe('toJSON', () => {
    it('should include price fields', () => {
      const market = new Market({
        level: 2,
      })
      const json = market.toJSON()
      expect(json.level).toBe(2)
      expect(json[RESOURCE_FOOD]).toBe(MARKET_BASE_PRICES[RESOURCE_FOOD])
      expect(json[RESOURCE_WOOD]).toBe(MARKET_BASE_PRICES[RESOURCE_WOOD])
    })
  })
})
