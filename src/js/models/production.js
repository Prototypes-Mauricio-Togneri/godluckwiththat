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

export default Production
