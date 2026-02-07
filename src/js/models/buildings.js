/**
 * Tracks building data for the colony.
 * Each building name is a direct property holding its data object.
 */
class Buildings {
  /**
   * @param {Object} data - Initial building data keyed by building name
   */
  constructor(data) {
    for (const key of Object.keys(data)) {
      this[key] = {
        ...data[key],
      }
    }
  }

  /**
   * Returns the level of a building.
   * @param {string} name - Building name
   * @returns {number}
   */
  getLevel(name) {
    return this[name].level
  }

  /**
   * Increments a building's level by one.
   * @param {string} name - Building name
   */
  upgrade(name) {
    this[name].level += 1
  }

  /**
   * Checks whether a building has been constructed (level > 0).
   * @param {string} name - Building name
   * @returns {boolean}
   */
  isBuilt(name) {
    return this[name].level > 0
  }
}

export default Buildings
