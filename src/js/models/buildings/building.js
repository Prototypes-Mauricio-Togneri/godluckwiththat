/**
 * Base class for all colony buildings.
 *
 * @property {number} level - Current building level
 * @property {number} workers - Number of workers assigned to this building
 */
class Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    this.level = data.level // Current building level
    this.workers = data.workers ?? 0 // Assigned workers (default 0)
  }
}

export default Building
