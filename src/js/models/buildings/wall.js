import {BUILDING_BASE_COSTS, BUILDING_LEVEL_UP_MULTIPLIERS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Defensive fortification.
 */
class Wall extends Building {
  static ID = 'wall'

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
    const base = BUILDING_BASE_COSTS.wall
    return new Cost({
      wood: Math.floor(base.wood * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.wall, level)),
      stone: Math.floor(base.stone * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.wall, level)),
    })
  }
}

export default Wall
