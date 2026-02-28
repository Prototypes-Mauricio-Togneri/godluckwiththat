import {BUILDING_UPGRADES, HQ_TERRITORY_PER_LEVEL, HQ_UPGRADE_COSTS} from '@/js/engine/balancing.js'
import {BUILDING_HEADQUARTERS} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'
import {HQ_TYPES} from '@/js/engine/constants.js'

/**
 * Colony headquarters building.
 *
 * @property {string} type - Headquarters progression type (e.g. 'camp')
 * @property {number} upgradeRemaining - Seconds left for type upgrade (0 = idle)
 * @property {number} upgradeDuration - Total type upgrade duration (for progress calculation)
 */
class Headquarters extends Building {
  /**
   * @param {Object} data - Initial headquarters data with level and type
   */
  constructor(data) {
    super(data)
    this.type = data.type // Headquarters progression type (e.g. 'camp')
    this.upgradeRemaining = data.upgradeRemaining ?? 0 // Seconds left for type upgrade (0 = idle)
    this.upgradeDuration = data.upgradeDuration ?? 0 // Total type upgrade duration (for progress %)
  }

  /** @returns {boolean} Whether a type upgrade is in progress */
  get isUpgrading() {
    return this.upgradeRemaining > 0
  }

  /** @returns {boolean} Whether the headquarters is at the highest type */
  get isMaxType() {
    return this.type === HQ_TYPES[HQ_TYPES.length - 1]
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
    } = BUILDING_UPGRADES[BUILDING_HEADQUARTERS]
    return cost.multiply(Math.pow(multiplier, this.level - 1)).floor()
  }

  /**
   * Cost to upgrade headquarters to the next progression type.
   * @returns {Cost|null} Cost for the upgrade, or null if already at max type
   */
  upgradeCost() {
    return HQ_UPGRADE_COSTS[this.type] ?? null
  }

  /**
   * Advances type upgrade by the given time delta.
   * @param {number} delta - Seconds elapsed
   * @returns {boolean} Whether the upgrade just completed
   */
  advanceUpgrade(delta) {
    if (!this.isUpgrading) {
      return false
    }
    this.upgradeRemaining = Math.max(0, this.upgradeRemaining - delta)
    if (this.upgradeRemaining === 0) {
      this.type = this.nextType()
      this.upgradeDuration = 0
      return true
    }
    return false
  }

  /**
   * Next headquarters progression type.
   * @returns {string|null} Next type, or null if already at max
   */
  nextType() {
    const index = HQ_TYPES.indexOf(this.type)
    if (index < 0 || index >= HQ_TYPES.length - 1) {
      return null
    }
    return HQ_TYPES[index + 1]
  }
}

export default Headquarters
