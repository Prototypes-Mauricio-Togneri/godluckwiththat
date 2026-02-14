import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces iron for the colony.
 */
class IronMine extends Producer {
  static ID = 'ironMine'

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
    } = BUILDING_UPGRADES.ironMine
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default IronMine
