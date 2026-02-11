import {BUILDING_BASE_COSTS, BUILDING_LEVEL_UP_MULTIPLIERS} from '@/js/balancing.js'
import Producer from '@/js/models/buildings/producer.js'
import Cost from '@/js/models/cost.js'

/**
 * Generates knowledge for the colony.
 */
class Academy extends Producer {
  static ID = 'academy'

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
    const base = BUILDING_BASE_COSTS.academy
    return new Cost({
      wood: Math.floor(base.wood * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.academy, level)),
      stone: Math.floor(base.stone * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.academy, level)),
    })
  }
}

export default Academy
