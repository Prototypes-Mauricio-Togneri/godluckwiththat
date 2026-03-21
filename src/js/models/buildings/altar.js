import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_ALTAR} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Passive faith generator. Produces faith per level per second (flagged passive in PRODUCTION_RATES).
 * Workers cannot be assigned to this building.
 */
class Altar extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_ALTAR]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Altar
