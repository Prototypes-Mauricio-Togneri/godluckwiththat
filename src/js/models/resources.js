/**
 * Tracks current resource amounts for the colony.
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
