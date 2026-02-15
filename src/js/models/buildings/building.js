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

  get isUnbuilt() {
    return this.level === 0
  }

  get isConstructing() {
    return this.constructionRemaining > 0
  }
}

export default Building
