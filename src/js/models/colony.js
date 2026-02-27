import {SEASON_COLD, SEASON_WARM} from '@/js/engine/enums.js'

/**
 * Colony data model. Wraps all colony sub-models
 * (resources, production, stockpile, buildings, researches).
 *
 * @property {number} year - Current year (starts at 1, increments every warm+cold cycle)
 * @property {string} season - Current season
 * @property {number} seasonElapsed - Seconds elapsed in current season
 * @property {number} idleWorkers - Workers not assigned to buildings
 * @property {Resources} resources - Current resource amounts
 * @property {Production} production - Per-second production rates
 * @property {Stockpile} stockpile - Maximum storage capacities
 * @property {Buildings} buildings - All building instances
 * @property {Researches} researches - Research progress (completed + active)
 * @property {MarketPrices} marketPrices - Current market prices per tradeable resource
 */
class Colony {
  /**
   * @param {Object} data - Colony data with pre-constructed sub-model instances
   */
  constructor(data) {
    this.year = data.year // Current year (increments every warm+cold cycle)
    this.season = data.season // Current season
    this.seasonElapsed = data.seasonElapsed // Seconds elapsed in current season
    this.idleWorkers = data.idleWorkers // Workers not assigned to buildings
    this.resources = data.resources // Current resource amounts
    this.production = data.production // Per-tick production rates
    this.stockpile = data.stockpile // Maximum storage capacities
    this.buildings = data.buildings // All building instances
    this.researches = data.researches // Research progress (completed + active)
    this.marketPrices = data.marketPrices // Current market prices per tradeable resource
    this.consumption = {
      food: 0,
      wood: 0,
    } // Per-second worker upkeep (recalculated each tick)
  }

  /** @returns {boolean} Whether the current season is warm */
  get isWarmSeason() {
    return this.season === SEASON_WARM
  }

  /** @returns {boolean} Whether the current season is cold */
  get isColdSeason() {
    return this.season === SEASON_COLD
  }
}

export default Colony
