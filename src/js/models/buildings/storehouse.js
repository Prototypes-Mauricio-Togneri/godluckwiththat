import {BUILDING_BASE_COSTS, BUILDING_LEVEL_UP_MULTIPLIERS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Increases resource stockpile capacity.
 */
class Storehouse extends Building {
  static ID = 'storehouse'

  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the given level.
   * @param {number} level - Current building level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const base = BUILDING_BASE_COSTS.storehouse
    return new Cost({
      wood: Math.floor(base.wood * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.storehouse, level)),
      stone: Math.floor(base.stone * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.storehouse, level)),
    })
  }
}

export default Storehouse
