import {BUILDING_UPGRADES, HOUSE_BASE_POPULATION, HOUSE_POPULATION_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_HOUSE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Provides housing for colony population.
 */
class House extends Building {
  static ID = BUILDING_HOUSE

  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
  }

  /**
   * Maximum population capacity at the current level.
   * @returns {number}
   */
  populationCap() {
    return HOUSE_BASE_POPULATION + this.level * HOUSE_POPULATION_PER_LEVEL
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_HOUSE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor()
  }
}

export default House
