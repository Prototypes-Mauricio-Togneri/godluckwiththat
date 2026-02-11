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
    this.territory = data.territory // Controlled territory count
    this.workers = data.workers // Total worker population
    this.food = data.food // Food supply
    this.wood = data.wood // Wood supply
    this.stone = data.stone // Stone supply
    this.copper = data.copper // Copper supply
    this.iron = data.iron // Iron supply
    this.gold = data.gold // Gold supply
    this.faith = data.faith // Faith supply
    this.knowledge = data.knowledge // Knowledge supply
  }

  /**
   * @param {Cost} cost - Cost to check against current resources
   * @returns {boolean} True if every cost field is <= the corresponding resource
   */
  canAfford(cost) {
    return cost.food <= this.food
      && cost.wood <= this.wood
      && cost.stone <= this.stone
      && cost.copper <= this.copper
      && cost.iron <= this.iron
      && cost.gold <= this.gold
      && cost.knowledge <= this.knowledge
  }

  /**
   * Subtracts the given cost from these resources in place.
   * @param {Cost} cost - Cost to deduct
   */
  deduct(cost) {
    this.food -= cost.food
    this.wood -= cost.wood
    this.stone -= cost.stone
    this.copper -= cost.copper
    this.iron -= cost.iron
    this.gold -= cost.gold
    this.knowledge -= cost.knowledge
  }

}

export default Resources
