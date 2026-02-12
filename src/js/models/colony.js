/**
 * Colony data model. Wraps all colony sub-models
 * (resources, production, stockpile, buildings).
 *
 * @property {number} year - Current year (starts at 1, increments every warm+cold cycle)
 * @property {string} season - Current season
 * @property {number} seasonElapsed - Seconds elapsed in current season
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
    this.year = data.year // Current year (increments every warm+cold cycle)
    this.season = data.season // Current season
    this.seasonElapsed = data.seasonElapsed // Seconds elapsed in current season
    this.idleWorkers = data.idleWorkers // Workers not assigned to buildings
    this.resources = data.resources // Current resource amounts
    this.production = data.production // Per-tick production rates
    this.stockpile = data.stockpile // Maximum storage capacities
    this.buildings = data.buildings // All building instances
  }
}

export default Colony
