import {BUILDING_BASE_COSTS, BUILDING_LEVEL_UP_MULTIPLIERS, STOREHOUSE_BASE_CAPACITY, STOREHOUSE_CAPACITY_PER_LEVEL} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Increases resource stockpile capacity.
 */
class Storehouse extends Building {
  static ID = 'storehouse'

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
    const base = BUILDING_BASE_COSTS.storehouse
    return new Cost({
      wood: Math.floor(base.wood * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.storehouse, this.level)),
      stone: Math.floor(base.stone * Math.pow(BUILDING_LEVEL_UP_MULTIPLIERS.storehouse, this.level)),
    })
  }
}

export default Storehouse
