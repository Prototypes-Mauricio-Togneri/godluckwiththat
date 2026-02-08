import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'
import {BUILDING_BUILD_COSTS} from '@/js/constants.js'

/**
 * Enables resource trading.
 */
class Market extends Building {
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
    const base = BUILDING_BUILD_COSTS.market
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
      stone: Math.floor(base.stone * (level + 1)),
    })
  }
}

export default Market
