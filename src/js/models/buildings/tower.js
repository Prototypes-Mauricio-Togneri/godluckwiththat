import {BUILDING_BASE_COSTS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Defensive ranged structure.
 */
class Tower extends Building {
  static ID = 'tower'

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
    const base = BUILDING_BASE_COSTS.tower
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
      stone: Math.floor(base.stone * (level + 1)),
    })
  }
}

export default Tower
