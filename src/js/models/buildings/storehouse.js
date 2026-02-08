import Building from '@/js/models/buildings/building.js'

/**
 * Increases resource stockpile capacity.
 */
class Storehouse extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }
}

export default Storehouse
