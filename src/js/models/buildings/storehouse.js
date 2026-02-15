import {BUILDING_UPGRADES, STOREHOUSE_BASE_CAPACITY, STOREHOUSE_CAPACITY_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_STOREHOUSE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Increases resource stockpile capacity.
 */
class Storehouse extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Maximum resource storage capacity at the current level.
   * @returns {number}
   */
  storageCap() {
    return STOREHOUSE_BASE_CAPACITY + this.level * STOREHOUSE_CAPACITY_PER_LEVEL
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_STOREHOUSE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Storehouse
