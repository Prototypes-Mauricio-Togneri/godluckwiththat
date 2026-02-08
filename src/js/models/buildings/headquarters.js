import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'
import {HQ_TYPES, HQ_LEVEL_UP_BASE_WOOD, HQ_LEVEL_UP_MULTIPLIER} from '@/js/constants.js'

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

  /**
   * Cost to increase HQ from the given level to the next.
   * Formula: wood = floor(BASE_WOOD * MULTIPLIER ^ (level - 1))
   * @param {number} level - Current headquarters level
   * @returns {Cost}
   */
  static levelUpCost(level) {
    const wood = Math.floor(HQ_LEVEL_UP_BASE_WOOD * Math.pow(HQ_LEVEL_UP_MULTIPLIER, level - 1))
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

    const costs = [
      new Cost({
        wood: 200,
        stone: 100,
      }),
      new Cost({
        wood: 500,
        stone: 250,
        copper: 100,
      }),
      new Cost({
        wood: 1000,
        stone: 500,
        copper: 250,
        iron: 100,
      }),
      new Cost({
        wood: 2000,
        stone: 1000,
        copper: 500,
        iron: 250,
        gold: 100,
      }),
    ]
    return costs[index]
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
