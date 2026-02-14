import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Generates faith for the colony.
 */
class Altar extends Building {
  static ID = 'altar'

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
    } = BUILDING_UPGRADES.altar
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Altar
