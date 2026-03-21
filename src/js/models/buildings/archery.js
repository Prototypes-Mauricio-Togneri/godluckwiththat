import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_ARCHERY} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Trains archer units. Higher levels increase queue capacity and training speed.
 * Workers cannot be assigned to this building.
 */
class Archery extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_ARCHERY]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Archery
