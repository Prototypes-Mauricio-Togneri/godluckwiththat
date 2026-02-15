import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_WALL} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Defensive fortification.
 */
class Wall extends Building {
  static ID = BUILDING_WALL

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
    } = BUILDING_UPGRADES[BUILDING_WALL]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Wall
