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
  }
}

export default Building
