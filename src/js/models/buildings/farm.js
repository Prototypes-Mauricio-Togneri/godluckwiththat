import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_FARM} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces food for the colony.
 */
class Farm extends Producer {
  static ID = BUILDING_FARM

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
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_FARM]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Farm
