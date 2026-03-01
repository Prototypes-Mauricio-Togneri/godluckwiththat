import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_TOWER} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Defensive ranged structure.
 */
class Tower extends Building {
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
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_TOWER]
    return cost.multiply(Math.pow(multiplier, this.level)).floor
  }
}

export default Tower
