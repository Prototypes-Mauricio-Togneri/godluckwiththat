import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_IRON_MINE} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Produces iron for the colony. Rate per worker per second defined in PRODUCTION_RATES (balancing.js).
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
   * Formula: floor(baseCost * multiplier ^ level)
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_IRON_MINE]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default IronMine
