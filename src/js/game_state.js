/**
 * Central game state container.
 * Wraps a Colony instance and will hold additional
 * session-level state (e.g. timers, events) as the game grows.
 *
 * @property {Colony} colony - Active colony instance
 */
class GameState {
  /**
   * @param {Colony} colony - Colony instance
   */
  constructor(colony) {
    this.colony = colony
  }
}

export default GameState
