import {BUILDING_BASE_COSTS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Trains mounted units.
 */
class Stable extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  static baseCost = BUILDING_BASE_COSTS.stable

  /**
   * Cost to level up from the given level.
   * @param {number} level - Current building level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const base = Stable.baseCost
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
      stone: Math.floor(base.stone * (level + 1)),
    })
  }
}

export default Stable
