import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import Producer from '@/js/models/buildings/producer.js'
import Cost from '@/js/models/cost.js'

/**
 * Sacred building that amplifies faith.
 */
class Shrine extends Producer {
  static ID = 'shrine'

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
    } = BUILDING_UPGRADES.shrine
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(multiplier, this.level)),
      stone: Math.floor(cost.stone * Math.pow(multiplier, this.level)),
    })
  }
}

export default Shrine
