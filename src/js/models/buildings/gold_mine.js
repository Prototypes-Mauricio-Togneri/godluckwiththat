import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces gold for the colony.
 */
class GoldMine extends Producer {
  static ID = 'goldMine'

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
    } = BUILDING_UPGRADES.goldMine
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default GoldMine
