/**
 * Tracks current resource amounts for the colony.
 *
 * @property {number} territory - Controlled territory count
 * @property {number} workers - Total worker population
 * @property {number} food - Food supply
 * @property {number} wood - Wood supply
 * @property {number} stone - Stone supply
 * @property {number} copper - Copper supply
 * @property {number} iron - Iron supply
 * @property {number} gold - Gold supply
 * @property {number} faith - Faith supply
 * @property {number} knowledge - Knowledge supply
 */
class Resources {
  /**
   * @param {Object} data - Initial resource values keyed by name
   */
  constructor(data) {
    this.territory = data.territory
    this.workers = data.workers
    this.food = data.food
    this.wood = data.wood
    this.stone = data.stone
    this.copper = data.copper
    this.iron = data.iron
    this.gold = data.gold
    this.faith = data.faith
    this.knowledge = data.knowledge
  }

}

export default Resources
