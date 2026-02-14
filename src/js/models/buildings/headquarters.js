import {BUILDING_UPGRADES, HQ_TERRITORY_PER_LEVEL, HQ_UPGRADE_COSTS} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'
import {HQ_TYPES} from '@/js/engine/constants.js'

/**
 * Colony headquarters building.
 *
 * @property {string} type - Headquarters progression type (e.g. 'camp')
 */
class Headquarters extends Building {
  static ID = 'headquarters'

  /**
   * @param {Object} data - Initial headquarters data with level and type
   */
  constructor(data) {
    super(data)
    this.type = data.type // Headquarters progression type (e.g. 'camp')
    this.upgradeRemaining = data.upgradeRemaining ?? 0 // Seconds left for type upgrade (0 = idle)
    this.upgradeDuration = data.upgradeDuration ?? 0 // Total type upgrade duration (for progress %)
  }

  /**
   * Maximum territory capacity at the current level.
   * @returns {number}
   */
  territoryCap() {
    return this.level * HQ_TERRITORY_PER_LEVEL
  }

  /**
   * Cost to increase HQ from the current level to the next.
   * Formula: wood = floor(BASE_WOOD * MULTIPLIER ^ (level - 1))
   * @returns {Cost}
   */
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES.headquarters
    const mult = Math.pow(multiplier, this.level - 1)
    const food = Math.floor(cost.food * mult)
    const wood = Math.floor(cost.wood * mult)
    return new Cost({
      food,
      wood,
    })
  }

  /**
   * Cost to upgrade headquarters to the next progression type.
   * @returns {Cost|null} Cost for the upgrade, or null if already at max type
   */
  upgradeCost() {
    return HQ_UPGRADE_COSTS[this.type] ?? null
  }

  /**
   * Next headquarters progression type.
   * @returns {string|null} Next type, or null if already at max
   */
  nextType() {
    const index = HQ_TYPES.indexOf(this.type)
    if (index < 0 || index >= HQ_TYPES.length - 1) return null
    return HQ_TYPES[index + 1]
  }
}

export default Headquarters
