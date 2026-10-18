// Shared utility functions for resource affordability checks, rounding, storage capacity, market pricing, and timer progress.

import {MARKET_BASE_FEE, MARKET_FEE_REDUCTION_PER_LEVEL, MARKET_MAX_CURRENT_PRICE, MARKET_MIN_CURRENT_PRICE, MARKET_MIN_FEE, MARKET_PRICE_SHIFT, STOREHOUSE_BASE_CAPACITY, STOREHOUSE_CAPACITY_MULTIPLIER} from '@/js/engine/balancing.js'
import {TRADE_BUY} from '@/js/engine/enums.js'

const FLOOR_TOLERANCE = 1e-9 // Float error absorbed before flooring, far below any real fractional part

/**
 * Floors a float product, treating a value a hair below a whole number as that whole number.
 * Products that are exact whole numbers can evaluate slightly low (e.g. 45 × 1.4 = 62.99999999999999)
 * and would otherwise floor one unit short.
 * @param {number} value - Value to floor
 * @returns {number} Floored value
 */
export function floorWithTolerance(value) {
  return Math.floor(value + FLOOR_TOLERANCE)
}

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
 * Market trade fee in whole percent for a market level, ignoring the BLESSED_MARKETS blessing.
 * Base fee, reduced per level above 1, never below the minimum fee.
 * @param {number} level - Market level
 * @returns {number} Fee percent (e.g. 26 at level 5)
 */
export function marketFeePercent(level) {
  const basePercent = Math.round(MARKET_BASE_FEE * 100) // e.g. 30
  const reductionPerLevel = Math.round(MARKET_FEE_REDUCTION_PER_LEVEL * 100) // e.g. 1
  const minPercent = Math.round(MARKET_MIN_FEE * 100) // e.g. 5
  return Math.max(minPercent, basePercent - Math.max(0, level - 1) * reductionPerLevel)
}

/**
 * Storehouse storage capacity for a level, with optional research bonus.
 * Formula: floor(STOREHOUSE_BASE_CAPACITY × STOREHOUSE_CAPACITY_MULTIPLIER^level × (1 + storageBonus)).
 * @param {number} level - Storehouse level
 * @param {number} storageBonus - Fractional bonus from research (e.g. 0.10 = +10%)
 * @returns {number} Maximum storage capacity
 */
export function storageCapacity(level, storageBonus) {
  return floorWithTolerance(STOREHOUSE_BASE_CAPACITY * Math.pow(STOREHOUSE_CAPACITY_MULTIPLIER, level) * (1 + storageBonus))
}

/**
 * Gold total and resulting price for trading a number of lots at the market.
 * Each lot shifts the price first and then trades at the shifted price (buy pays the raised
 * price, sell receives the lowered one), so round trips and split trades never create gold.
 * Fee is applied once to the total to avoid a double-floor rounding discount on bulk trades, in
 * integer percent math so an exact whole-gold result never floors one gold short.
 * @param {number} price - Current gold price per MARKET_TRADE_AMOUNT
 * @param {'buy'|'sell'} direction - Trade direction
 * @param {number} lots - Number of MARKET_TRADE_AMOUNT lots traded
 * @param {number} fee - Effective fee fraction, a whole number of percent (e.g. 0.21 = 21%; rounded to the nearest percent)
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
  const feePercent = Math.round(fee * 100) // e.g. 21
  return {
    gold: Math.floor(total * (isBuy ? 100 + feePercent : 100 - feePercent) / 100),
    price: boundLots > 0 ? bound : price + shift * freeLots,
  }
}

/**
 * Elapsed fraction of a countdown timer, for progress fills.
 * @param {number} remainingSeconds - Seconds left on the timer
 * @param {number} duration - Total timer length in seconds
 * @returns {number} Progress from 0 (just started) to 1 (finished), clamped; 0 when the duration is missing or not positive
 */
export function timerProgress(remainingSeconds, duration) {
  if (!(duration > 0)) {
    return 0
  }
  return Math.min(1, Math.max(0, 1 - remainingSeconds / duration))
}
