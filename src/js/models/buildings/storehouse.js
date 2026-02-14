import {BUILDING_UPGRADES, STOREHOUSE_BASE_CAPACITY, STOREHOUSE_CAPACITY_PER_LEVEL} from '@/js/engine/balancing.js'
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
    const {
      cost, costMultiplier,
    } = BUILDING_UPGRADES.storehouse
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(costMultiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(costMultiplier, this.level)),
    })
  }
}

export default Storehouse
