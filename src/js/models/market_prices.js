import {RESOURCE_COPPER, RESOURCE_FOOD, RESOURCE_IRON, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import {MARKET_BASE_PRICES} from '@/js/engine/balancing.js'

/**
 * Tracks current market prices per tradeable resource.
 * Prices shift with each trade (up on buy, down on sell).
 *
 * @property {number} food - Current gold price per 100 food
 * @property {number} wood - Current gold price per 100 wood
 * @property {number} stone - Current gold price per 100 stone
 * @property {number} copper - Current gold price per 100 copper
 * @property {number} iron - Current gold price per 100 iron
 */
class MarketPrices {
  /**
   * @param {Object} [data] - Initial prices (defaults to MARKET_BASE_PRICES)
   */
  constructor(data = {}) {
    this[RESOURCE_FOOD] = data[RESOURCE_FOOD] ?? MARKET_BASE_PRICES[RESOURCE_FOOD]
    this[RESOURCE_WOOD] = data[RESOURCE_WOOD] ?? MARKET_BASE_PRICES[RESOURCE_WOOD]
    this[RESOURCE_STONE] = data[RESOURCE_STONE] ?? MARKET_BASE_PRICES[RESOURCE_STONE]
    this[RESOURCE_COPPER] = data[RESOURCE_COPPER] ?? MARKET_BASE_PRICES[RESOURCE_COPPER]
    this[RESOURCE_IRON] = data[RESOURCE_IRON] ?? MARKET_BASE_PRICES[RESOURCE_IRON]
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object}
   */
  toJSON() {
    return {
      [RESOURCE_FOOD]: this[RESOURCE_FOOD],
      [RESOURCE_WOOD]: this[RESOURCE_WOOD],
      [RESOURCE_STONE]: this[RESOURCE_STONE],
      [RESOURCE_COPPER]: this[RESOURCE_COPPER],
      [RESOURCE_IRON]: this[RESOURCE_IRON],
    }
  }
}

export default MarketPrices
