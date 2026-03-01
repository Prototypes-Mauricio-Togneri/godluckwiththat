import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_IRON_MINE} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces iron for the colony.
 */
class IronMine extends Producer {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_IRON_MINE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor
  }
}

export default IronMine
