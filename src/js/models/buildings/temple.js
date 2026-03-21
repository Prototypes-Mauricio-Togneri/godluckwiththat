import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_TEMPLE} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Worker-based faith producer. Workers are assigned to pray and generate faith per worker per second.
 * Rate defined in PRODUCTION_RATES (balancing.js).
 */
class Temple extends Producer {
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
    } = BUILDING_UPGRADES[BUILDING_TEMPLE]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Temple
