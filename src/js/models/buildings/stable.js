import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_STABLE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Trains cavalry units.
 */
class Stable extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the current level.
   * Formula: floor(baseCost * multiplier ^ level)
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_STABLE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor
  }
}

export default Stable
