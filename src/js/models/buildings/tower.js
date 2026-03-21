import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_TOWER} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Ranged attack structure. The higher the level, the more attack it provides to the colony.
 * Workers cannot be assigned to this building.
 */
class Tower extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_TOWER]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Tower
