import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_ALTAR} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Generates faith for the colony.
 */
class Altar extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_ALTAR]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Altar
