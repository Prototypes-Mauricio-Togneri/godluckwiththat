/**
 * Tracks current resource amounts for the colony.
 * Each key (food, wood, stone, etc.) is a direct property.
 */
class Resources {
  /**
   * @param {Object} data - Initial resource values keyed by name
   */
  constructor(data) {
    Object.assign(this, data)
  }

  /**
   * Returns the current amount of a resource.
   * @param {string} key - Resource name
   * @returns {number}
   */
  get(key) {
    return this[key]
  }

  /**
   * Sets a resource to an exact value.
   * @param {string} key - Resource name
   * @param {number} value - New amount
   */
  set(key, value) {
    this[key] = value
  }

  /**
   * Adds an amount to a resource.
   * @param {string} key - Resource name
   * @param {number} amount - Amount to add
   */
  add(key, amount) {
    this[key] += amount
  }

  /**
   * Subtracts an amount from a resource if sufficient.
   * @param {string} key - Resource name
   * @param {number} amount - Amount to consume
   * @returns {boolean} True if the resource was consumed
   */
  consume(key, amount) {
    if (this[key] < amount) return false
    this[key] -= amount
    return true
  }

  /**
   * Checks whether all costs in a map can be paid.
   * @param {Object} costMap - Object mapping resource names to amounts
   * @returns {boolean}
   */
  canAfford(costMap) {
    for (const key of Object.keys(costMap)) {
      if (this[key] < costMap[key]) return false
    }
    return true
  }

  /**
   * Deducts all costs in a map if affordable.
   * @param {Object} costMap - Object mapping resource names to amounts
   * @returns {boolean} True if the payment succeeded
   */
  pay(costMap) {
    if (!this.canAfford(costMap)) return false
    for (const key of Object.keys(costMap)) {
      this[key] -= costMap[key]
    }
    return true
  }
}

export default Resources
