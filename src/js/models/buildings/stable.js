import {BUILDING_UPGRADES, MILITARY_UNITS_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_STABLE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Trains cavalry units. Higher levels raise how many cavalry the colony can have.
 * Workers cannot be assigned to this building.
 */
class Stable extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Maximum cavalry the colony can have. An unbuilt building gives 0.
   * Formula: level × MILITARY_UNITS_PER_LEVEL
   * @returns {number} Unit cap at the current level
   */
  get unitCap() {
    return this.level * MILITARY_UNITS_PER_LEVEL
  }

  /**
   * Cost to level up from the current level.
   * Formula: floor(baseCost * multiplier ^ level)
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_STABLE]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Stable
