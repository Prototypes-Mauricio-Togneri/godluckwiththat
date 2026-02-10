/**
 * Tracks per-tick production rates for each resource.
 *
 * @property {number} food - Food production per tick
 * @property {number} wood - Wood production per tick
 * @property {number} stone - Stone production per tick
 * @property {number} copper - Copper production per tick
 * @property {number} iron - Iron production per tick
 * @property {number} gold - Gold production per tick
 * @property {number} faith - Faith production per tick
 * @property {number} knowledge - Knowledge production per tick
 */
class Production {
  /**
   * @param {Object} data - Initial production rates keyed by resource name
   */
  constructor(data) {
    this.food = data.food // Food production per tick
    this.wood = data.wood // Wood production per tick
    this.stone = data.stone // Stone production per tick
    this.copper = data.copper // Copper production per tick
    this.iron = data.iron // Iron production per tick
    this.gold = data.gold // Gold production per tick
    this.faith = data.faith // Faith production per tick
    this.knowledge = data.knowledge // Knowledge production per tick
  }
}

export default Production
