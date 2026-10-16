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

    it('should fall back to base prices when saved prices are not finite numbers', () => {
      const market = new Market({
        level: 1,
        food: '100',
        wood: Infinity,
      })
      expect(market[RESOURCE_FOOD]).toBe(MARKET_BASE_PRICES[RESOURCE_FOOD])
      expect(market[RESOURCE_WOOD]).toBe(MARKET_BASE_PRICES[RESOURCE_WOOD])
    })

    it('should clamp saved prices to the trading bounds', () => {
      const market = new Market({
        level: 1,
        food: -100,
        wood: MARKET_MAX_CURRENT_PRICE + 1,
      })
      expect(market[RESOURCE_FOOD]).toBe(MARKET_MIN_CURRENT_PRICE)
      expect(market[RESOURCE_WOOD]).toBe(MARKET_MAX_CURRENT_PRICE)
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

  describe('executeTrade', () => {
    it('should not grant gold or food from a negative saved price', () => {
      const market = new Market({
        level: 1,
        food: -100,
      })
      const resources = createResources({
        gold: 0,
        food: 0,
      })

      expect(market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000)).toBe(false)
      expect(resources.gold).toBe(0)
      expect(resources.food).toBe(0)
    })

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
      const exactGold = Math.floor((market[RESOURCE_FOOD] + MARKET_PRICE_SHIFT) * (1 + market.effectiveTradeFee))
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
      const sellPrice = Math.floor((market[RESOURCE_FOOD] - MARKET_PRICE_SHIFT) * (1 - market.effectiveTradeFee))
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

    it('should buy at the raised price with no fee when blessedMarkets is active', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      const basePrice = market[RESOURCE_FOOD]
      const resources = createResources({
        gold: 5000,
        food: 0,
      })
      const goldBefore = resources.gold

      const result = market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 10000)
      expect(result).toBe(true)
      expect(resources.gold).toBe(goldBefore - (basePrice + MARKET_PRICE_SHIFT))
      expect(resources.food).toBe(MARKET_TRADE_AMOUNT)
    })

    it('should sell at the lowered price with no fee when blessedMarkets is active', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      const basePrice = market[RESOURCE_FOOD]
      const resources = createResources({
        gold: 0,
        food: 500,
      })

      const result = market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 10000)
      expect(result).toBe(true)
      expect(resources.gold).toBe(basePrice - MARKET_PRICE_SHIFT)
      expect(resources.food).toBe(400)
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

    it('should not give a double-floor rounding discount on bulk buys', () => {
      const market = new Market({
        level: 1,
      })
      const basePrice = market[RESOURCE_FOOD]
      const fee = market.effectiveTradeFee
      const multiplier = 10
      const amount = MARKET_TRADE_AMOUNT * multiplier
      const resources = createResources({
        gold: 99999,
        food: 0,
      })

      market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999, amount)
      const goldSpent = 99999 - resources.gold
      let lotPrices = 0
      for (let lot = 1; lot <= multiplier; lot++) {
        lotPrices += basePrice + lot * MARKET_PRICE_SHIFT
      }
      const expectedCost = Math.floor(lotPrices * (1 + fee))
      expect(goldSpent).toBe(expectedCost)
    })

    it('should not give a double-floor rounding discount on bulk sells', () => {
      const market = new Market({
        level: 1,
      })
      const basePrice = market[RESOURCE_FOOD]
      const fee = market.effectiveTradeFee
      const multiplier = 10
      const amount = MARKET_TRADE_AMOUNT * multiplier
      const resources = createResources({
        gold: 0,
        food: amount,
      })

      market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999, amount)
      let lotPrices = 0
      for (let lot = 1; lot <= multiplier; lot++) {
        lotPrices += basePrice - lot * MARKET_PRICE_SHIFT
      }
      const expectedGain = Math.floor(lotPrices * (1 - fee))
      expect(resources.gold).toBe(expectedGain)
    })

    it('should move the price by one shift per lot on bulk trades', () => {
      const market = new Market({
        level: 1,
      })
      const priceBefore = market[RESOURCE_FOOD]
      const resources = createResources({
        gold: 99999,
        food: 0,
      })
      market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999, MARKET_TRADE_AMOUNT * 10)
      expect(market[RESOURCE_FOOD]).toBe(priceBefore + MARKET_PRICE_SHIFT * 10)
      market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999, MARKET_TRADE_AMOUNT * 10)
      expect(market[RESOURCE_FOOD]).toBe(priceBefore)
    })

    it('should charge the same for one bulk trade as for the same lots traded one by one', () => {
      const bulkMarket = new Market({
        level: 1,
      })
      const splitMarket = new Market({
        level: 1,
      })
      bulkMarket.blessedMarkets = true
      splitMarket.blessedMarkets = true
      const bulkResources = createResources({
        gold: 5000,
        food: 0,
      })
      const splitResources = createResources({
        gold: 5000,
        food: 0,
      })

      bulkMarket.executeTrade(RESOURCE_FOOD, TRADE_BUY, bulkResources, 99999, MARKET_TRADE_AMOUNT * 10)
      for (let lot = 0; lot < 10; lot++) {
        splitMarket.executeTrade(RESOURCE_FOOD, TRADE_BUY, splitResources, 99999)
      }
      expect(splitResources.gold).toBe(bulkResources.gold)
      expect(splitMarket[RESOURCE_FOOD]).toBe(bulkMarket[RESOURCE_FOOD])
    })

    it('should lose gold on a buy-then-sell round trip when blessedMarkets is active', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      const priceBefore = market[RESOURCE_FOOD]
      const resources = createResources({
        gold: 5000,
        food: 0,
      })
      const amount = MARKET_TRADE_AMOUNT * 10

      market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999, amount)
      market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999, amount)
      expect(resources.gold).toBeLessThan(5000)
      expect(resources.food).toBe(0)
      expect(market[RESOURCE_FOOD]).toBe(priceBefore)
    })

    it('should lose gold on a sell-then-buy round trip when blessedMarkets is active', () => {
      const market = new Market({
        level: 1,
      })
      market.blessedMarkets = true
      const resources = createResources({
        gold: 5000,
        food: 1000,
      })
      const amount = MARKET_TRADE_AMOUNT * 10

      market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999, amount)
      market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999, amount)
      expect(resources.gold).toBeLessThan(5000)
      expect(resources.food).toBe(1000)
    })

    it('should lose gold on round trips near the price floor at the minimum fee', () => {
      for (let price = MARKET_MIN_CURRENT_PRICE; price <= MARKET_MIN_CURRENT_PRICE + 10; price++) {
        const market = new Market({
          level: 100,
          [RESOURCE_FOOD]: price,
        })
        const resources = createResources({
          gold: 5000,
          food: 100,
        })

        market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999)
        market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999)
        market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999)
        market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999)
        expect(resources.gold).toBeLessThan(5000)
        expect(resources.food).toBe(100)
      }
    })

    it('should lose gold when selling lots one by one and buying them back in bulk', () => {
      const market = new Market({
        level: 100,
      })
      const resources = createResources({
        gold: 5000,
        food: 1000,
      })

      for (let lot = 0; lot < 10; lot++) {
        market.executeTrade(RESOURCE_FOOD, TRADE_SELL, resources, 99999)
      }
      market.executeTrade(RESOURCE_FOOD, TRADE_BUY, resources, 99999, MARKET_TRADE_AMOUNT * 10)
      expect(resources.gold).toBeLessThan(5000)
      expect(resources.food).toBe(1000)
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
