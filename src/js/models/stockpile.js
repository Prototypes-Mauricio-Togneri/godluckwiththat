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
 */
class Stockpile {
  /**
   * @param {Object} data - Initial stockpile caps keyed by resource name
   */
  constructor(data) {
    this.territory = data.territory // Max territory capacity
    this.workers = data.workers // Max worker capacity
    this.food = data.food // Max food storage
    this.wood = data.wood // Max wood storage
    this.stone = data.stone // Max stone storage
    this.copper = data.copper // Max copper storage
    this.iron = data.iron // Max iron storage
    this.gold = data.gold // Max gold storage
  }
}

export default Stockpile
