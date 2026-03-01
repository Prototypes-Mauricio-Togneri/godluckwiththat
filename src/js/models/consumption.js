/**
 * Tracks per-second consumption rates for each resource.
 * Ephemeral model recalculated each tick by GameState.update(), not persisted.
 *
 * @property {number} food - Food consumption per second
 * @property {number} wood - Wood consumption per second
 */
class Consumption {
  /**
   * @param {Object} data - Initial consumption rates keyed by resource name
   */
  constructor(data) {
    this.food = data.food ?? 0 // Food consumption per second
    this.wood = data.wood ?? 0 // Wood consumption per second
  }
}

export default Consumption
