import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Producer from '@/js/models/buildings/producer.js'
import Cost from '@/js/models/cost.js'

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
      cost, costMultiplier,
    } = BUILDING_UPGRADES.academy
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(costMultiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(costMultiplier, this.level)),
    })
  }
}

export default Academy
