import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_MONUMENT} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Grants a one-time faith bonus on each level completion.
 * The bonus is applied externally by State.advanceConstruction().
 */
class Monument extends Building {
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
    } = BUILDING_UPGRADES[BUILDING_MONUMENT]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Monument
