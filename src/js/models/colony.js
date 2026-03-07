import Buildings from '@/js/models/buildings.js'
import Consumption from '@/js/models/consumption.js'
import Events from '@/js/models/events/events.js'
import Production from '@/js/models/production.js'
import Resources from '@/js/models/resources.js'
import Season from '@/js/models/season.js'

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
    this.productivity = data.productivity ?? 1 // Productivity ratio 0–1 (ephemeral, recalculated each tick; reduced by food/wood shortage)
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

  /**
   * Reconstructs a Colony instance from serialized data.
   * @param {Object} data - Serialized colony data
   * @param {Object} classMap - Map of building key → class constructor
   * @returns {Colony} Restored Colony instance
   */
  static fromJSON(data, classMap) {
    return new Colony({
      year: data.year,
      season: new Season(data.season),
      resources: new Resources(data.resources),
      buildings: Buildings.fromJSON(data.buildings, classMap),
      events: Events.fromJSON(data.events),
      production: new Production({}),
      consumption: new Consumption({}),
    })
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      year: this.year,
      season: this.season.toJSON(),
      resources: this.resources.toJSON(),
      buildings: this.buildings.toJSON(),
      events: this.events.toJSON(),
    }
  }
}

export default Colony
