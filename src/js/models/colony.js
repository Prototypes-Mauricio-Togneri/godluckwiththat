/**
 * Colony data model. Wraps all colony sub-models
 * (resources, production, stockpile, buildings).
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
