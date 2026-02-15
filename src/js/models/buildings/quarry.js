import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_QUARRY} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces stone for the colony.
 */
class Quarry extends Producer {
  static ID = BUILDING_QUARRY

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
    } = BUILDING_UPGRADES[BUILDING_QUARRY]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Quarry
