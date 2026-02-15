import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_WOODCUTTER} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces wood for the colony.
 */
class Woodcutter extends Producer {
  static ID = BUILDING_WOODCUTTER

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
    } = BUILDING_UPGRADES[BUILDING_WOODCUTTER]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Woodcutter
