import {BUILDING_UPGRADES, HOUSE_BASE_POPULATION, HOUSE_POPULATION_PER_LEVEL} from '@/js/engine/balancing.js'
import Building from '@/js/models/buildings/building.js'
import Cost from '@/js/models/cost.js'

/**
 * Provides housing for colony population.
 */
class House extends Building {
  static ID = 'house'

  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Cost to level up from the given level.
   * @param {number} level - Current building level
   * @returns {Cost}
   */
  /**
   * Maximum population capacity at the current level.
   * @returns {number}
   */
  populationCap() {
    return HOUSE_BASE_POPULATION + this.level * HOUSE_POPULATION_PER_LEVEL
  }

  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES.house
    return new Cost({
      wood: Math.floor(cost.wood * Math.pow(multiplier, this.level)),
    })
  }
}

export default House
