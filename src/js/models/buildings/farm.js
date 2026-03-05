import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_FARM} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces food for the colony.
 */
class Farm extends Producer {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the current level.
   * Formula: floor(baseCost * multiplier ^ level)
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_FARM]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Farm
