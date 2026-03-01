/**
 * Colony data model. Wraps all colony sub-models
 * (season, resources, production, consumption, buildings, events).
 *
 * @property {number} year - Current year (starts at 1, increments every warm+cold cycle)
 * @property {Season} season - Current season state
 * @property {number} idleWorkers - Workers not assigned to buildings (derived getter)
 * @property {Resources} resources - Current resource amounts
 * @property {Production} production - Per-second gross production rates
 * @property {Consumption} consumption - Per-second worker upkeep rates (ephemeral, recalculated each tick)
 * @property {Buildings} buildings - All building instances
 * @property {Events} events - Game event log (future countdowns + past notifications)
 */
class Colony {
  /**
   * @param {Object} data - Colony data with pre-constructed sub-model instances
   */
  constructor(data) {
    this.year = data.year // Current year (increments every warm+cold cycle)
    this.season = data.season // Season model (currentSeason + seasonElapsed)
    this.resources = data.resources // Current resource amounts
    this.production = data.production // Per-second gross production rates
    this.buildings = data.buildings // All building instances
    this.events = data.events // Game event log (future countdowns + past notifications)
    this.consumption = data.consumption // Per-second worker upkeep (ephemeral, recalculated each tick)
  }

  /** @returns {number} Workers not assigned to any building (derived from total - assigned) */
  get idleWorkers() {
    return this.resources.workers - this.buildings.totalAssignedWorkers
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
