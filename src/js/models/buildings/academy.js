import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Generates knowledge for the colony.
 */
class Academy extends Producer {
  static ID = 'academy'

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
    } = BUILDING_UPGRADES.academy
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Academy
