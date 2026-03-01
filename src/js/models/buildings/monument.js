import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_MONUMENT} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Grants a one-time faith bonus on each level completion.
 */
class Monument extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_MONUMENT]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Monument
