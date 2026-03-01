import {BUILDING_UPGRADES, HOUSE_POPULATION_PER_LEVEL} from '@/js/engine/balancing.js'
import {BUILDING_HOUSE} from '@/js/engine/enums.js'
import Building from '@/js/models/buildings/building.js'

/**
 * Provides housing for colony population.
 *
 * @property {number} workersCap - Cached population cap, recalculated each tick
 */
class House extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
    this.workersCap = data.workersCap ?? 0 // Cached cap, set each tick by GameState.update()
  }

  /**
   * Maximum population capacity at the current level.
   * @param {number} [habitationBonus=0] - Flat bonus per level from habitation research
   * @returns {number} Maximum population at current level
   */
  populationCap(habitationBonus = 0) {
    return this.level * (HOUSE_POPULATION_PER_LEVEL + habitationBonus)
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost} Resource cost for the next level
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_HOUSE]
    return cost.multiply(Math.pow(multiplier, this.level)).floor
  }
}

export default House
