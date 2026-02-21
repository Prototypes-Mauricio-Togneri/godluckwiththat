/**
 * Tracks per-second production rates for each resource.
 *
 * @property {number} food - Food production per second
 * @property {number} wood - Wood production per second
 * @property {number} stone - Stone production per second
 * @property {number} copper - Copper production per second
 * @property {number} iron - Iron production per second
 * @property {number} gold - Gold production per second
 * @property {number} faith - Faith production per second
 * @property {number} knowledge - Knowledge production per second
 */
class Production {
  /**
   * @param {Object} data - Initial production rates keyed by resource name
   */
  constructor(data) {
    this.food = data.food ?? 0 // Food production per second
    this.wood = data.wood ?? 0 // Wood production per second
    this.stone = data.stone ?? 0 // Stone production per second
    this.copper = data.copper ?? 0 // Copper production per second
    this.iron = data.iron ?? 0 // Iron production per second
    this.gold = data.gold ?? 0 // Gold production per second
    this.faith = data.faith ?? 0 // Faith production per second
    this.knowledge = data.knowledge ?? 0 // Knowledge production per second
  }
}

export default Production
