/**
 * Blessing reward granted for completing a divine challenge.
 * Tracked in Challenges.activeBlessings; effects applied in Phase 2.
 *
 * @property {string} type - Blessing type enum
 * @property {number|null} timeout - Duration in seconds (null for instant effects)
 * @property {number|null} productivity - Productivity boost fraction (e.g. 0.3 for 30%)
 * @property {Object|null} resources - Resource grants (resource key → amount)
 * @property {number|null} territory - Territory slots granted
 * @property {number|null} construction - Construction speed fraction (e.g. 0.5 for 50% faster)
 * @property {number|null} warm - Warm season improvement fraction
 * @property {number|null} cold - Cold season improvement fraction
 */
class Blessing {
  /**
   * @param {Object} data - Blessing data
   */
  constructor(data) {
    this.type = data.type // Blessing type enum
    this.timeout = data.timeout ?? null // Duration in seconds (null for instant)
    this.productivity = data.productivity ?? null // Productivity boost fraction
    this.resources = data.resources ?? null // Resource grants (resource key → amount)
    this.territory = data.territory ?? null // Territory slots granted
    this.construction = data.construction ?? null // Construction speed fraction
    this.warm = data.warm ?? null // Warm season improvement fraction
    this.cold = data.cold ?? null // Cold season improvement fraction
  }

  /**
   * Reconstructs a Blessing instance from serialized data.
   * @param {Object} data - Serialized blessing data
   * @returns {Blessing} Restored Blessing instance
   */
  static fromJSON(data) {
    return new Blessing(data)
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      type: this.type,
      timeout: this.timeout,
      productivity: this.productivity,
      resources: this.resources,
      territory: this.territory,
      construction: this.construction,
      warm: this.warm,
      cold: this.cold,
    }
  }
}

export default Blessing
