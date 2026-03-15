import {BUILDING_UPGRADES, MARKET_BASE_FEE, MARKET_BASE_PRICES, MARKET_FEE_REDUCTION_PER_LEVEL, MARKET_MAX_CURRENT_PRICE, MARKET_MIN_CURRENT_PRICE, MARKET_MIN_FEE, MARKET_PRICE_SHIFT, MARKET_TRADE_AMOUNT} from '@/js/engine/balancing.js'
import {BUILDING_MARKET, RESOURCE_COPPER, RESOURCE_FOOD, RESOURCE_IRON, RESOURCE_STONE, RESOURCE_WOOD, TRADE_BUY} from '@/js/engine/enums.js'
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
    this[RESOURCE_FOOD] = data[RESOURCE_FOOD] ?? MARKET_BASE_PRICES[RESOURCE_FOOD] // Current gold price per 100 food
    this[RESOURCE_WOOD] = data[RESOURCE_WOOD] ?? MARKET_BASE_PRICES[RESOURCE_WOOD] // Current gold price per 100 wood
    this[RESOURCE_STONE] = data[RESOURCE_STONE] ?? MARKET_BASE_PRICES[RESOURCE_STONE] // Current gold price per 100 stone
    this[RESOURCE_COPPER] = data[RESOURCE_COPPER] ?? MARKET_BASE_PRICES[RESOURCE_COPPER] // Current gold price per 100 copper
    this[RESOURCE_IRON] = data[RESOURCE_IRON] ?? MARKET_BASE_PRICES[RESOURCE_IRON] // Current gold price per 100 iron
    this.blessedMarkets = false // Set by State.update() when BLESSED_MARKETS blessing is active
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_MARKET]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }

  /**
   * Computes the effective trade fee, accounting for market level.
   * @returns {number} Effective fee fraction (e.g. 0.21)
   */
  get effectiveTradeFee() {
    if (this.blessedMarkets) {
      return 0
    }
    const basePercent = Math.round(MARKET_BASE_FEE * 100) // e.g. 30
    const reductionPerLevel = Math.round(MARKET_FEE_REDUCTION_PER_LEVEL * 100) // e.g. 1
    const minPercent = Math.round(MARKET_MIN_FEE * 100) // e.g. 5
    const rawPercent = basePercent - Math.max(0, this.level - 1) * reductionPerLevel // e.g. 26 at level 5
    return Math.max(minPercent, rawPercent) / 100
  }

  /**
   * Returns the gold cost to buy a resource at current market price + fee.
   * @param {string} resource - Resource key
   * @returns {number} Gold cost (floored)
   */
  buyPrice(resource) {
    return Math.floor(this[resource] * (1 + this.effectiveTradeFee))
  }

  /**
   * Returns the gold gained from selling a resource at current market price - fee.
   * @param {string} resource - Resource key
   * @returns {number} Gold gained (floored)
   */
  sellPrice(resource) {
    return Math.floor(this[resource] * (1 - this.effectiveTradeFee))
  }

  /**
   * Executes a market trade: buy or sell a resource for gold.
   * @param {string} resource - Resource key (food, wood, stone, copper, iron)
   * @param {'buy'|'sell'} direction - Trade direction
   * @param {Resources} resources - Current resource amounts (mutated in place)
   * @param {number} storageCap - Maximum storage capacity for bounded resources
   * @param {number} [amount=MARKET_TRADE_AMOUNT] - Number of resource units to trade
   * @returns {boolean} Whether the trade was executed
   */
  executeTrade(resource, direction, resources, storageCap, amount = MARKET_TRADE_AMOUNT) {
    if (this.level < 1 || amount <= 0 || amount % MARKET_TRADE_AMOUNT !== 0) {
      return false
    }
    const multiplier = amount / MARKET_TRADE_AMOUNT
    // Buy: deduct gold, add resource, raise price
    if (direction === TRADE_BUY) {
      const goldCost = Math.floor(this.buyPrice(resource) * multiplier)
      if (resources.gold < goldCost) {
        return false
      }
      if (resources[resource] + amount > storageCap) {
        return false
      }
      resources.gold -= goldCost
      resources[resource] += amount
      this[resource] = Math.min(MARKET_MAX_CURRENT_PRICE, this[resource] + MARKET_PRICE_SHIFT)
    // Sell: deduct resource, add gold, lower price
    } else {
      const goldGain = Math.floor(this.sellPrice(resource) * multiplier)
      if (resources[resource] < amount) {
        return false
      }
      if (resources.gold + goldGain > storageCap) {
        return false
      }
      resources.gold += goldGain
      resources[resource] -= amount
      this[resource] = Math.max(MARKET_MIN_CURRENT_PRICE, this[resource] - MARKET_PRICE_SHIFT)
    }
    return true
  }

  /**
   * Serializable snapshot of market prices for save/load.
   * @returns {Object} Plain object snapshot for serialization
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
