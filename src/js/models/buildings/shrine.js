import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_SHRINE} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Sacred building that amplifies faith.
 */
class Shrine extends Producer {
  static ID = BUILDING_SHRINE

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
    } = BUILDING_UPGRADES[BUILDING_SHRINE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default Shrine
