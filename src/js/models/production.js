/**
 * Tracks per-tick production rates for each resource.
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
