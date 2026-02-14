import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Grand structure honoring the Gods.
 */
class Monument extends Building {
  static ID = 'monument'

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
      cost, costMultiplier,
    } = BUILDING_UPGRADES.monument
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(costMultiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(costMultiplier, this.level)),
    })
  }
}

export default Monument
