import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_MARKET} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Enables resource trading.
 */
class Market extends Building {
  static ID = BUILDING_MARKET

  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_MARKET]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Market
