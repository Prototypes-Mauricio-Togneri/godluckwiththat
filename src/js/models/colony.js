/**
 * Colony data model. Wraps all colony sub-models
 * (resources, production, stockpile, buildings, researches).
 *
 * @property {number} year - Current year (starts at 1, increments every warm+cold cycle)
 * @property {Season} season - Current season state
 * @property {number} idleWorkers - Workers not assigned to buildings
 * @property {Resources} resources - Current resource amounts
 * @property {Production} production - Per-second gross production rates
 * @property {Stockpile} stockpile - Maximum storage capacities
 * @property {Buildings} buildings - All building instances
 * @property {Researches} researches - Research progress (completed + active)
 * @property {Trades} trades - Current market prices per tradeable resource
 */
class Colony {
  /**
   * @param {Object} data - Colony data with pre-constructed sub-model instances
   */
  constructor(data) {
    this.year = data.year // Current year (increments every warm+cold cycle)
    this.season = data.season // Season model (currentSeason + seasonElapsed)
    this.idleWorkers = data.idleWorkers // Workers not assigned to buildings
    this.resources = data.resources // Current resource amounts
    this.production = data.production // Per-tick production rates
    this.stockpile = data.stockpile // Maximum storage capacities
    this.buildings = data.buildings // All building instances
    this.researches = data.researches // Research progress (completed + active)
    this.trades = data.trades // Current market prices per tradeable resource
    this.consumption = data.consumption // Per-second worker upkeep (recalculated each tick)
  }

  /** @returns {boolean} Whether the current season is warm */
  get isWarmSeason() {
    return this.season.isWarm
  }

  /** @returns {boolean} Whether the current season is cold */
  get isColdSeason() {
    return this.season.isCold
  }

  /**
   * Returns the net production rate for a resource (gross minus consumption).
   * @param {string} resource - Resource key
   * @returns {number} Net production per second
   */
  netProduction(resource) {
    return this.production[resource] - (this.consumption[resource] ?? 0)
  }
}

export default Colony
