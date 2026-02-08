import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Produces food for the colony.
 */
class Farm extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  static baseCost = {
    wood: 10,
  }

  /**
   * Cost to level up from the given level.
   * @param {number} level - Current building level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const base = Farm.baseCost
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
    })
  }
}

export default Farm
