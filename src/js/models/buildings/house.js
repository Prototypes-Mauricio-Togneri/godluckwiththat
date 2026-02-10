import {BUILDING_BASE_COSTS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Provides housing for colony population.
 */
class House extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  static baseCost = BUILDING_BASE_COSTS.house

  /**
   * Cost to level up from the given level.
   * @param {number} level - Current building level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const base = House.baseCost
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
    })
  }
}

export default House
