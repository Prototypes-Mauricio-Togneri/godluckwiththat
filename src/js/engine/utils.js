// Shared utility functions for resource affordability checks and market pricing.

import {MARKET_MAX_CURRENT_PRICE, MARKET_MIN_CURRENT_PRICE, MARKET_PRICE_SHIFT} from '@/js/engine/balancing.js'
import {TRADE_BUY} from '@/js/engine/enums.js'

/**
 * Whether the given resource snapshot can cover the cost.
 * Works on plain objects (no class dependency).
 * @param {Object} resources - Flat resource snapshot {food, wood, stone, ...}
 * @param {Cost} cost - Cost instance with resource fields
 * @returns {boolean} True if every cost field is <= the corresponding resource
 */
export function canAffordCost(resources, cost) {
  return cost.food <= resources.food
    && cost.wood <= resources.wood
    && cost.stone <= resources.stone
    && cost.copper <= resources.copper
    && cost.iron <= resources.iron
    && cost.gold <= resources.gold
    && cost.knowledge <= resources.knowledge
    && cost.faith <= resources.faith
}

/**
 * Gold total and resulting price for trading a number of lots at the market.
 * Each lot shifts the price first and then trades at the shifted price (buy pays the raised
 * price, sell receives the lowered one), so round trips and split trades never create gold.
 * Fee is applied once to the total to avoid a double-floor rounding discount on bulk trades.
 * @param {number} price - Current gold price per MARKET_TRADE_AMOUNT
 * @param {'buy'|'sell'} direction - Trade direction
 * @param {number} lots - Number of MARKET_TRADE_AMOUNT lots traded
 * @param {number} fee - Effective fee fraction (e.g. 0.21)
 * @returns {{gold: number, price: number}} Gold paid or received (floored) and the price after the trade
 */
export function marketTradeQuote(price, direction, lots, fee) {
  const isBuy = direction === TRADE_BUY
  const shift = isBuy ? MARKET_PRICE_SHIFT : -MARKET_PRICE_SHIFT
  const bound = isBuy ? MARKET_MAX_CURRENT_PRICE : MARKET_MIN_CURRENT_PRICE
  // Lots that shift freely before the price would cross its bound; the remaining lots trade at the bound
  const room = isBuy ? bound - price : price - bound
  const freeLots = Math.min(lots, Math.max(0, Math.floor(room / MARKET_PRICE_SHIFT)))
  const boundLots = lots - freeLots
  const total = freeLots * price + shift * freeLots * (freeLots + 1) / 2 + boundLots * bound
  return {
    gold: Math.floor(total * (isBuy ? 1 + fee : 1 - fee)),
    price: boundLots > 0 ? bound : price + shift * freeLots,
  }
}
