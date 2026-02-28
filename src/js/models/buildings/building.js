/**
 * Base class for all colony buildings.
 *
 * @property {number} level - Current building level
 * @property {number} constructionRemaining - Seconds left in construction (0 = idle)
 * @property {number} constructionDuration - Total construction time (for progress calculation)
 */
class Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    this.level = data.level // Current building level
    this.constructionRemaining = data.constructionRemaining ?? 0 // Seconds left (0 = not constructing)
    this.constructionDuration = data.constructionDuration ?? 0 // Total duration (for progress %)
  }

  /** @returns {boolean} Whether the building has not been built yet */
  get isUnbuilt() {
    return this.level === 0
  }

  /** @returns {boolean} Whether the building is currently under construction */
  get isConstructing() {
    return this.constructionRemaining > 0
  }

  /**
   * Advances construction by the given time delta.
   * @param {number} delta - Seconds elapsed
   * @returns {boolean} Whether construction just completed
   */
  advance(delta) {
    if (!this.isConstructing) return false
    this.constructionRemaining = Math.max(0, this.constructionRemaining - delta)
    if (this.constructionRemaining === 0) {
      this.level += 1
      this.constructionDuration = 0
      return true
    }
    return false
  }
}

export default Building
