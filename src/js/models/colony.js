import Resources from './resources.js'
import Production from './production.js'
import Storage from './storage.js'
import Buildings from './buildings.js'

/**
 * Colony data model. Wraps raw colony data into typed
 * sub-classes for resources, production, storage, and buildings.
 */
class Colony {
  /**
   * @param {Object} data - Raw colony data (e.g. INITIAL_COLONY from constants.js)
   */
  constructor(data) {
    this.season = data.season
    this.idleWorkers = data.idleWorkers
    this.resources = new Resources(data.resources)
    this.production = new Production(data.production)
    this.storage = new Storage(data.storage)
    this.buildings = new Buildings(data.buildings)
  }
}

export default Colony
