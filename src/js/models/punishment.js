/**
 * Punishment applied when a divine challenge is failed.
 * Tracked in Challenges.activePunishments; effects applied in Phase 2.
 *
 * @property {string} type - Punishment type enum
 * @property {number|null} timeout - Duration in seconds (null for instant effects)
 * @property {number|null} faith - Fraction of stored faith lost (e.g. 0.5 for 50%)
 * @property {number|null} productivity - Productivity decrease fraction
 * @property {number|null} resources - Fraction of bounded resources lost
 * @property {number|null} workers - Number of workers lost
 * @property {number|null} levels - Number of building levels lost
 */
class Punishment {
  /**
   * @param {Object} data - Punishment data
   */
  constructor(data) {
    this.type = data.type // Punishment type enum
    this.timeout = data.timeout ?? null // Duration in seconds (null for instant)
    this.faith = data.faith ?? null // Fraction of stored faith lost
    this.productivity = data.productivity ?? null // Productivity decrease fraction
    this.resources = data.resources ?? null // Fraction of bounded resources lost
    this.workers = data.workers ?? null // Number of workers lost
    this.levels = data.levels ?? null // Number of building levels lost
  }

  /**
   * Reconstructs a Punishment instance from serialized data.
   * @param {Object} data - Serialized punishment data
   * @returns {Punishment} Restored Punishment instance
   */
  static fromJSON(data) {
    return new Punishment(data)
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      type: this.type,
      timeout: this.timeout,
      faith: this.faith,
      productivity: this.productivity,
      resources: this.resources,
      workers: this.workers,
      levels: this.levels,
    }
  }
}

export default Punishment
