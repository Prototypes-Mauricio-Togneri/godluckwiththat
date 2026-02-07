/**
 * Tracks maximum stockpile capacity for each resource.
 */
class Stockpile {
  /**
   * @param {Object} data - Initial stockpile caps keyed by resource name
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

export default Stockpile
