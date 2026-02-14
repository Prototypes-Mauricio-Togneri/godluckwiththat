import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces wood for the colony.
 */
class Woodcutter extends Producer {
  static ID = 'woodcutter'

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
    } = BUILDING_UPGRADES.woodcutter
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Woodcutter
