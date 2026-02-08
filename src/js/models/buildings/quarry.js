import Building from '@/js/models/buildings/building.js'

/**
 * Produces stone for the colony.
 */
class Quarry extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }
}

export default Quarry
