/**
 * Tracks maximum stockpile capacity for each resource.
 *
 * @property {number} territory - Max territory capacity
 * @property {number} workers - Max worker capacity
 * @property {number} food - Max food storage
 * @property {number} wood - Max wood storage
 * @property {number} stone - Max stone storage
 * @property {number} copper - Max copper storage
 * @property {number} iron - Max iron storage
 * @property {number} gold - Max gold storage
 * @property {number} faith - Max faith storage
 * @property {number} knowledge - Max knowledge storage
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
