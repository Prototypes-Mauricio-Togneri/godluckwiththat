import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Trains mounted units.
 */
class Stable extends Building {
  static ID = 'stable'

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
    } = BUILDING_UPGRADES.stable
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(costMultiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(costMultiplier, this.level)),
    })
  }
}

export default Stable
