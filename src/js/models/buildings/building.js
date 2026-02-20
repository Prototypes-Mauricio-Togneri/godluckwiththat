/**
 * Base class for all colony buildings.
 *
 * @property {number} level - Current building level
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
}

export default Building
