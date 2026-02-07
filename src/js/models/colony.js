/**
 * Colony data model. Wraps all colony sub-models
 * (resources, production, storage, buildings).
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
    this.storage = data.storage
    this.buildings = data.buildings
  }
}

export default Colony
