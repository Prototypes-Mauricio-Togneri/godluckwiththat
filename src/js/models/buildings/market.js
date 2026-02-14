import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Enables resource trading.
 */
class Market extends Building {
  static ID = 'market'

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
    } = BUILDING_UPGRADES.market
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Market
