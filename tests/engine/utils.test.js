import {describe, it, expect} from 'vitest'
import {MARKET_MAX_CURRENT_PRICE, MARKET_MIN_CURRENT_PRICE, MARKET_PRICE_SHIFT} from '@/js/engine/balancing.js'
import {TRADE_BUY, TRADE_SELL} from '@/js/engine/enums.js'
import {canAffordCost, marketTradeQuote} from '@/js/engine/utils.js'
import {createCost} from '../helpers/factories.js'

describe('canAffordCost', () => {
  const richResources = {
    food: 1000,
    wood: 1000,
    stone: 1000,
    copper: 1000,
    iron: 1000,
    gold: 1000,
    knowledge: 1000,
    faith: 1000,
  }

  const poorResources = {
    food: 0,
    wood: 0,
    stone: 0,
    copper: 0,
    iron: 0,
    gold: 0,
    knowledge: 0,
    faith: 0,
  }

  it('should return true when resources exceed cost', () => {
    const cost = createCost({
      food: 50,
      wood: 30,
    })
    expect(canAffordCost(richResources, cost)).toBe(true)
  })

  it('should return true when resources exactly match cost', () => {
    const resources = {
      food: 50,
      wood: 30,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      knowledge: 0,
      faith: 0,
    }
    const cost = createCost({
      food: 50,
      wood: 30,
    })
    expect(canAffordCost(resources, cost)).toBe(true)
  })

  it('should return false when any resource is insufficient', () => {
    const resources = {
      food: 49,
      wood: 1000,
      stone: 1000,
      copper: 1000,
      iron: 1000,
      gold: 1000,
      knowledge: 1000,
      faith: 1000,
    }
    const cost = createCost({
      food: 50,
    })
    expect(canAffordCost(resources, cost)).toBe(false)
  })

  it('should return false when resources are empty', () => {
    const cost = createCost({
      food: 1,
    })
    expect(canAffordCost(poorResources, cost)).toBe(false)
  })

  it('should return true for a zero cost', () => {
    const cost = createCost()
    expect(canAffordCost(poorResources, cost)).toBe(true)
  })

  it('should check all 8 resource types', () => {
    const resources = {
      food: 10,
      wood: 10,
      stone: 10,
      copper: 10,
      iron: 10,
      gold: 10,
      knowledge: 10,
      faith: 10,
    }
    const costAllResources = createCost({
      food: 10,
      wood: 10,
      stone: 10,
      copper: 10,
      iron: 10,
      gold: 10,
      knowledge: 10,
      faith: 10,
    })
    expect(canAffordCost(resources, costAllResources)).toBe(true)

    const costTooMuchFaith = createCost({
      faith: 11,
    })
    expect(canAffordCost(resources, costTooMuchFaith)).toBe(false)
  })
})

describe('marketTradeQuote', () => {
  it('should price each bought lot at its raised price', () => {
    expect(marketTradeQuote(100, TRADE_BUY, 1, 0)).toEqual({
      gold: 100 + MARKET_PRICE_SHIFT,
      price: 100 + MARKET_PRICE_SHIFT,
    })
    expect(marketTradeQuote(100, TRADE_BUY, 10, 0)).toEqual({
      gold: 1000 + MARKET_PRICE_SHIFT * 55,
      price: 100 + MARKET_PRICE_SHIFT * 10,
    })
  })

  it('should price each sold lot at its lowered price', () => {
    expect(marketTradeQuote(130, TRADE_SELL, 10, 0)).toEqual({
      gold: 1300 - MARKET_PRICE_SHIFT * 55,
      price: 130 - MARKET_PRICE_SHIFT * 10,
    })
  })

  it('should apply the fee once to the total and floor it', () => {
    expect(marketTradeQuote(100, TRADE_BUY, 10, 0.05).gold).toBe(Math.floor((1000 + MARKET_PRICE_SHIFT * 55) * 1.05))
    expect(marketTradeQuote(130, TRADE_SELL, 10, 0.05).gold).toBe(Math.floor((1300 - MARKET_PRICE_SHIFT * 55) * 0.95))
  })

  it('should trade remaining lots at the price floor once it is reached', () => {
    const start = MARKET_MIN_CURRENT_PRICE + MARKET_PRICE_SHIFT + 1
    expect(marketTradeQuote(start, TRADE_SELL, 3, 0)).toEqual({
      gold: (start - MARKET_PRICE_SHIFT) + MARKET_MIN_CURRENT_PRICE * 2,
      price: MARKET_MIN_CURRENT_PRICE,
    })
  })

  it('should trade remaining lots at the price cap once it is reached', () => {
    const start = MARKET_MAX_CURRENT_PRICE - MARKET_PRICE_SHIFT - 1
    expect(marketTradeQuote(start, TRADE_BUY, 3, 0)).toEqual({
      gold: (start + MARKET_PRICE_SHIFT) + MARKET_MAX_CURRENT_PRICE * 2,
      price: MARKET_MAX_CURRENT_PRICE,
    })
  })

  it('should match trading the same lots one at a time', () => {
    const startPrices = [
      MARKET_MIN_CURRENT_PRICE,
      MARKET_MIN_CURRENT_PRICE + 1,
      47,
      100,
      MARKET_MAX_CURRENT_PRICE - 7,
      MARKET_MAX_CURRENT_PRICE,
    ]
    for (const direction of [
      TRADE_BUY,
      TRADE_SELL,
    ]) {
      for (const startPrice of startPrices) {
        let price = startPrice
        let gold = 0
        for (let lots = 1; lots <= 40; lots++) {
          const single = marketTradeQuote(price, direction, 1, 0)
          gold += single.gold
          price = single.price
          expect(marketTradeQuote(startPrice, direction, lots, 0)).toEqual({
            gold: gold,
            price: price,
          })
        }
      }
    }
  })
})
