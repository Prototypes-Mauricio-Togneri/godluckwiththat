import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Produces iron for the colony.
 */
class IronMine extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  static baseCost = {
    wood: 100,
    stone: 50,
  }

  /**
   * Cost to level up from the given level.
   * @param {number} level - Current building level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const base = IronMine.baseCost
    return new Cost({
      wood: Math.floor(base.wood * (level + 1)),
      stone: Math.floor(base.stone * (level + 1)),
    })
  }
}

export default IronMine
