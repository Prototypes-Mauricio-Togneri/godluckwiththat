/**
 * Tracks per-tick production rates for each resource.
 * Each key (food, wood, stone, etc.) is a direct property.
 */
class Production {
  /**
   * @param {Object} data - Initial production rates keyed by resource name
   */
  constructor(data) {
    Object.assign(this, data)
  }

  /**
   * Returns the production rate for a resource.
   * @param {string} key - Resource name
   * @returns {number}
   */
  get(key) {
    return this[key]
  }

  /**
   * Sets a production rate to an exact value.
   * @param {string} key - Resource name
   * @param {number} value - New rate
   */
  set(key, value) {
    this[key] = value
  }

  /**
   * Adds to a production rate.
   * @param {string} key - Resource name
   * @param {number} amount - Amount to add
   */
  add(key, amount) {
    this[key] += amount
  }

  /**
   * Resets all production rates to zero.
   */
  reset() {
    for (const key of Object.keys(this)) {
      this[key] = 0
    }
  }

  /**
   * Applies production rates to resources, clamping by storage caps.
   * @param {import('./resources.js').default} resources - Resources instance
   * @param {import('./storage.js').default} storage - Storage instance
   */
  apply(resources, storage) {
    for (const key of Object.keys(this)) {
      resources.set(key, storage.clamp(key, resources.get(key) + this[key]))
    }
  }
}

export default Production
