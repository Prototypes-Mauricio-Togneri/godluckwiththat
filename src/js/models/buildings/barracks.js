import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Trains infantry units.
 */
class Barracks extends Building {
  static ID = 'barracks'

  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES.barracks
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Barracks
