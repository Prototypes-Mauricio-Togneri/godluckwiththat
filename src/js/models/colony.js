/**
 * Colony data model. Wraps all colony sub-models
 * (resources, production, stockpile, buildings).
 *
 * @property {string} season - Current season
 * @property {number} idleWorkers - Workers not assigned to buildings
 * @property {Resources} resources - Current resource amounts
 * @property {Production} production - Per-tick production rates
 * @property {Stockpile} stockpile - Maximum storage capacities
 * @property {Buildings} buildings - All building instances
 */
class Colony {
  /**
   * @param {Object} data - Colony data with pre-constructed sub-model instances
   */
  constructor(data) {
    this.season = data.season
    this.idleWorkers = data.idleWorkers
    this.resources = data.resources
    this.production = data.production
    this.stockpile = data.stockpile
    this.buildings = data.buildings
  }
}

export default Colony
