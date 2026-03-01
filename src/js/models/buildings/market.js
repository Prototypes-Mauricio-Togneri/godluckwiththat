import {BUILDING_UPGRADES, MARKET_BASE_PRICES} from '@/js/engine/balancing.js'
import {BUILDING_MARKET, RESOURCE_COPPER, RESOURCE_FOOD, RESOURCE_IRON, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Enables resource trading and tracks current market prices.
 * Prices shift with each trade (up on buy, down on sell).
 *
 * @property {number} food - Current gold price per 100 food
 * @property {number} wood - Current gold price per 100 wood
 * @property {number} stone - Current gold price per 100 stone
 * @property {number} copper - Current gold price per 100 copper
 * @property {number} iron - Current gold price per 100 iron
 */
class Market extends Building {
  /**
   * @param {Object} data - Initial building data + optional price overrides
   */
  constructor(data) {
    super(data)
    this[RESOURCE_FOOD] = data[RESOURCE_FOOD] ?? MARKET_BASE_PRICES[RESOURCE_FOOD]
    this[RESOURCE_WOOD] = data[RESOURCE_WOOD] ?? MARKET_BASE_PRICES[RESOURCE_WOOD]
    this[RESOURCE_STONE] = data[RESOURCE_STONE] ?? MARKET_BASE_PRICES[RESOURCE_STONE]
    this[RESOURCE_COPPER] = data[RESOURCE_COPPER] ?? MARKET_BASE_PRICES[RESOURCE_COPPER]
    this[RESOURCE_IRON] = data[RESOURCE_IRON] ?? MARKET_BASE_PRICES[RESOURCE_IRON]
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_MARKET]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }

  /**
   * Serializable snapshot of market prices for save/load.
   * @returns {Object}
   */
  toJSON() {
    return {
      level: this.level,
      constructionRemaining: this.constructionRemaining,
      constructionDuration: this.constructionDuration,
      [RESOURCE_FOOD]: this[RESOURCE_FOOD],
      [RESOURCE_WOOD]: this[RESOURCE_WOOD],
      [RESOURCE_STONE]: this[RESOURCE_STONE],
      [RESOURCE_COPPER]: this[RESOURCE_COPPER],
      [RESOURCE_IRON]: this[RESOURCE_IRON],
    }
  }
}

export default Market
