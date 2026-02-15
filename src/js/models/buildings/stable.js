import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_STABLE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Trains mounted units.
 */
class Stable extends Building {
  static ID = BUILDING_STABLE

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
    } = BUILDING_UPGRADES[BUILDING_STABLE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Stable
