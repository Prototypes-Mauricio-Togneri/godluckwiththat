import {BUILDING_UPGRADES, MARKET_BASE_PRICES, MARKET_TRADE_AMOUNT} from '@/js/engine/balancing.js'
import {BUILDING_MARKET, RESOURCE_COPPER, RESOURCE_FOOD, RESOURCE_IRON, RESOURCE_STONE, RESOURCE_WOOD, TRADE_BUY} from '@/js/engine/enums.js'
import {marketFeePercent, marketTradeQuote} from '@/js/engine/utils.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Enables trading food, wood, stone, copper, and iron for gold.
 * Prices shift with every MARKET_TRADE_AMOUNT lot traded (up on buy, down on sell, AoE2-style),
 * and each lot trades at its shifted price so buy/sell round trips always cost gold.
 * Base fee is 30%, reduced by 1% per level (minimum 5%). When blessedMarkets is true, fee is 0%.
 * Workers cannot be assigned to this building.
 *
 * @property {number} food - Current gold price per 100 food
 * @property {number} wood - Current gold price per 100 wood
 * @property {number} stone - Current gold price per 100 stone
 * @property {number} copper - Current gold price per 100 copper
 * @property {number} iron - Current gold price per 100 iron
 * @property {boolean} blessedMarkets - Whether the BLESSED_MARKETS blessing is active (0% fee)
 */
class Market extends Building {
  /**
   * @param {Object} data - Initial building data + optional price overrides (non-numeric saved prices fall back to base prices)
   */
  constructor(data) {
    super(data)
    this[RESOURCE_FOOD] = Number.isFinite(data[RESOURCE_FOOD]) ? data[RESOURCE_FOOD] : MARKET_BASE_PRICES[RESOURCE_FOOD] // Current gold price per 100 food
    this[RESOURCE_WOOD] = Number.isFinite(data[RESOURCE_WOOD]) ? data[RESOURCE_WOOD] : MARKET_BASE_PRICES[RESOURCE_WOOD] // Current gold price per 100 wood
    this[RESOURCE_STONE] = Number.isFinite(data[RESOURCE_STONE]) ? data[RESOURCE_STONE] : MARKET_BASE_PRICES[RESOURCE_STONE] // Current gold price per 100 stone
    this[RESOURCE_COPPER] = Number.isFinite(data[RESOURCE_COPPER]) ? data[RESOURCE_COPPER] : MARKET_BASE_PRICES[RESOURCE_COPPER] // Current gold price per 100 copper
    this[RESOURCE_IRON] = Number.isFinite(data[RESOURCE_IRON]) ? data[RESOURCE_IRON] : MARKET_BASE_PRICES[RESOURCE_IRON] // Current gold price per 100 iron
    this.blessedMarkets = false // Set by State.update() when BLESSED_MARKETS blessing is active
  }

  /**
   * Cost to level up from the current level.
   * Formula: floor(baseCost * multiplier ^ level)
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
    return marketFeePercent(this.level) / 100
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
    const quote = marketTradeQuote(this[resource], direction, amount / MARKET_TRADE_AMOUNT, this.effectiveTradeFee)
    // Buy: deduct gold, add resource, raise price
    if (direction === TRADE_BUY) {
      if (resources.gold < quote.gold) {
        return false
      }
      if (resources[resource] + amount > storageCap) {
        return false
      }
      resources.gold -= quote.gold
      resources[resource] += amount
    // Sell: deduct resource, add gold, lower price
    } else {
      if (resources[resource] < amount) {
        return false
      }
      if (resources.gold + quote.gold > storageCap) {
        return false
      }
      resources.gold += quote.gold
      resources[resource] -= amount
    }
    this[resource] = quote.price
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
