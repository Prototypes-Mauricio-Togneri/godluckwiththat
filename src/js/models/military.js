import {unitCounts} from '@/js/engine/utils.js'
import Raid from '@/js/models/raid.js'

/**
 * The colony's army and raid state.
 *
 * @property {Object<string, number>} units - Unit count per type
 * @property {Raid|null} raid - The current raid (waiting or incoming), or null before one is scheduled
 * @property {number} raidCount - Raids resolved or called off so far
 */
class Military {
  /**
   * @param {Object} [data] - Military data (missing fields get defaults)
   */
  constructor(data = {}) {
    this.units = unitCounts(data.units) // Unit count per type
    this.raid = data.raid ?? null // Current raid, or null
    this.raidCount = data.raidCount ?? 0 // Raids resolved or called off so far
  }

  /** @returns {number} Total units across all types */
  get totalUnits() {
    let total = 0
    for (const count of Object.values(this.units)) {
      total += count
    }
    return total
  }

  /**
   * Reconstructs a Military instance from serialized data (missing data gives an empty army).
   * @param {Object} [data] - Serialized military data
   * @returns {Military} Restored Military instance
   */
  static fromJSON(data) {
    return new Military({
      units: data?.units,
      raid: data?.raid ? Raid.fromJSON(data.raid) : null,
      raidCount: data?.raidCount,
    })
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      units: {
        ...this.units,
      },
      raid: this.raid ? this.raid.toJSON() : null,
      raidCount: this.raidCount,
    }
  }
}

export default Military
