import {BUILDING_BASE_COSTS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Produces wood for the colony.
 */
class Woodcutter extends Building {
  static ID = 'woodcutter'

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
    const base = BUILDING_BASE_COSTS.woodcutter
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
    })
  }
}

export default Woodcutter
