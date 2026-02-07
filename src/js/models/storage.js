/**
 * Tracks maximum storage capacity for each resource.
 * Each key (food, wood, stone, etc.) is a direct property.
 */
class Storage {
  /**
   * @param {Object} data - Initial storage caps keyed by resource name
   */
  constructor(data) {
    Object.assign(this, data)
  }

  /**
   * Returns the storage cap for a resource.
   * @param {string} key - Resource name
   * @returns {number}
   */
  get(key) {
    return this[key]
  }

  /**
   * Sets a storage cap to an exact value.
   * @param {string} key - Resource name
   * @param {number} value - New cap
   */
  set(key, value) {
    this[key] = value
  }

  /**
   * Adds to a storage cap.
   * @param {string} key - Resource name
   * @param {number} amount - Amount to add
   */
  add(key, amount) {
    this[key] += amount
  }

  /**
   * Checks whether a resource is at capacity.
   * @param {string} key - Resource name
   * @param {number} currentAmount - Current resource amount
   * @returns {boolean}
   */
  isFull(key, currentAmount) {
    return currentAmount >= this[key]
  }

  /**
   * Clamps a value to [0, cap] for a given resource.
   * @param {string} key - Resource name
   * @param {number} value - Value to clamp
   * @returns {number}
   */
  clamp(key, value) {
    return Math.max(0, Math.min(value, this[key]))
  }
}

export default Storage
