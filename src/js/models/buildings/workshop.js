import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Crafts siege equipment.
 */
class Workshop extends Building {
  static ID = 'workshop'

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
    } = BUILDING_UPGRADES.workshop
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Workshop
