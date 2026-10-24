import Buildings from '@/js/models/buildings.js'
import Events from '@/js/models/events/events.js'
import Military from '@/js/models/military.js'
import Resources from '@/js/models/resources.js'
import Season from '@/js/models/season.js'

/**
 * Colony data model. Wraps all colony sub-models
 * (season, resources, buildings, events, military).
 *
 * @property {number} year - Current year (starts at 1, increments every warm+cold cycle)
 * @property {Season} season - Current season state
 * @property {number} idleWorkers - Workers not assigned to buildings (derived getter)
 * @property {Resources} resources - Current resource amounts
 * @property {Buildings} buildings - All building instances
 * @property {Events} events - Game event log (future countdowns + past notifications)
 * @property {Military} military - Army and raid state
 */
class Colony {
  /**
   * @param {Object} data - Colony data with pre-constructed sub-model instances
   */
  constructor(data) {
    this.year = data.year // Current year (increments every warm+cold cycle)
    this.season = data.season // Season model (currentSeason + seasonElapsed)
    this.resources = data.resources // Current resource amounts
    this.buildings = data.buildings // All building instances
    this.events = data.events // Game event log (future countdowns + past notifications)
    this.military = data.military ?? new Military() // Army and raid state
  }

  /** @returns {number} Workers not assigned to any building (derived from total - assigned) */
  get idleWorkers() {
    return this.resources.workers - this.buildings.totalAssignedWorkers
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
      military: Military.fromJSON(data.military),
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
      military: this.military.toJSON(),
    }
  }
}

export default Colony
