import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_WORKSHOP} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Crafts siege equipment.
 */
class Workshop extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_WORKSHOP]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Workshop
