import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Trains ranged units.
 */
class Archery extends Building {
  static ID = 'archery'

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
    } = BUILDING_UPGRADES.archery
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(multiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(multiplier, this.level)),
    })
  }
}

export default Archery
