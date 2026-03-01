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
    this.territory = data.territory ?? 0 // Controlled territory count
    this.workers = data.workers ?? 0 // Total worker population
    this.food = data.food ?? 0 // Food supply
    this.wood = data.wood ?? 0 // Wood supply
    this.stone = data.stone ?? 0 // Stone supply
    this.copper = data.copper ?? 0 // Copper supply
    this.iron = data.iron ?? 0 // Iron supply
    this.gold = data.gold ?? 0 // Gold supply
    this.faith = data.faith ?? 0 // Faith supply
    this.knowledge = data.knowledge ?? 0 // Knowledge supply
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
      && cost.faith <= this.faith
  }

  /**
   * Subtracts the given cost from these resources in place.
   * @param {Cost} cost - Cost to deduct
   */
  deduct(cost) {
    this.food = Math.max(0, this.food - cost.food)
    this.wood = Math.max(0, this.wood - cost.wood)
    this.stone = Math.max(0, this.stone - cost.stone)
    this.copper = Math.max(0, this.copper - cost.copper)
    this.iron = Math.max(0, this.iron - cost.iron)
    this.gold = Math.max(0, this.gold - cost.gold)
    this.knowledge = Math.max(0, this.knowledge - cost.knowledge)
    this.faith = Math.max(0, this.faith - cost.faith)
  }
}

export default Resources
