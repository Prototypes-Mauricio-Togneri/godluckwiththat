import {BUILDING_BASE_COSTS, HQ_LEVEL_UP_MULTIPLIER, HQ_UPGRADE_COSTS} from '@/js/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'
import {HQ_TYPES} from '@/js/constants.js'

/**
 * Colony headquarters building.
 *
 * @property {string} type - Headquarters progression type (e.g. 'camp')
 */
class Headquarters extends Building {
  /**
   * @param {Object} data - Initial headquarters data with level and type
   */
  constructor(data) {
    super(data)
    this.type = data.type // Headquarters progression type (e.g. 'camp')
  }

  static baseCost = BUILDING_BASE_COSTS.headquarters
  static levelUpMultiplier = HQ_LEVEL_UP_MULTIPLIER

  /**
   * Cost to increase HQ from the given level to the next.
   * Formula: wood = floor(BASE_WOOD * MULTIPLIER ^ (level - 1))
   * @param {number} level - Current headquarters level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const wood = Math.floor(Headquarters.baseCost.wood * Math.pow(Headquarters.levelUpMultiplier, level - 1))
    return new Cost({
      wood,
    })
  }

  /**
   * Cost to upgrade headquarters to the next progression type.
   * @param {string} currentType - Current HQ type (e.g. 'camp')
   * @returns {Cost|null} Cost for the upgrade, or null if already at max type
   */
  static upgradeCost(currentType) {
    const index = HQ_TYPES.indexOf(currentType)
    if (index < 0 || index >= HQ_TYPES.length - 1) return null

    return new Cost(HQ_UPGRADE_COSTS[index])
  }

  /**
   * Next headquarters progression type.
   * @param {string} currentType - Current HQ type
   * @returns {string|null} Next type, or null if already at max
   */
  static nextType(currentType) {
    const index = HQ_TYPES.indexOf(currentType)
    if (index < 0 || index >= HQ_TYPES.length - 1) return null
    return HQ_TYPES[index + 1]
  }
}

export default Headquarters
