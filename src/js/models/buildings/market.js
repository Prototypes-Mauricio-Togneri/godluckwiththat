import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

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
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(multiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(multiplier, this.level)),
    })
  }
}

export default Market
