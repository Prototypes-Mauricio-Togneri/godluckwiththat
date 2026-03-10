import {BUILDING_UPGRADES, STOREHOUSE_BASE_CAPACITY, STOREHOUSE_CAPACITY_MULTIPLIER} from '@/js/engine/balancing.js'
import {BUILDING_STOREHOUSE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Increases resource storage capacity.
 */
class Storehouse extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Maximum resource storage capacity at the current level, with optional bonus.
   * @param {number} storageBonus - Fractional bonus from research (e.g. 0.10 = +10%)
   * @returns {number} Maximum storage capacity at current level
   */
  storageCap(storageBonus = 0) {
    const base = STOREHOUSE_BASE_CAPACITY * Math.pow(STOREHOUSE_CAPACITY_MULTIPLIER, this.level)
    return Math.floor(base * (1 + storageBonus))
  }

  /**
   * Cost to level up from the current level.
   * Formula: floor(baseCost * multiplier ^ level)
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_STOREHOUSE]
    return cost.multiplyFloor(Math.pow(multiplier, this.level))
  }
}

export default Storehouse
