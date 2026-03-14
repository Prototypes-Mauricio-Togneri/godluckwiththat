import {CHALLENGE_STATUS_ACTIVATED, CHALLENGE_STATUS_STARTED} from '@/js/engine/enums.js'
import Blessing from '@/js/models/blessing.js'
import Punishment from '@/js/models/punishment.js'

/**
 * A single divine challenge with requirements, timer state, and rewards/penalties.
 * The gods send sequential challenges to test the colony's worthiness.
 *
 * @property {number} index - Challenge number (starting from 1)
 * @property {string} status - Lifecycle state (pending, activated, started, completed)
 * @property {number} delay - Seconds from activation until the player is informed
 * @property {number} delayElapsed - Seconds elapsed since activation
 * @property {number} timeout - Seconds to complete the challenge once started
 * @property {number} timeoutElapsed - Seconds elapsed since started
 * @property {Object} requirements - Challenge requirements (faith, altar, temple, monument, resources, workers)
 * @property {Blessing[]} blessings - Available blessing reward choices
 * @property {Punishment} punishment - Punishment applied on failure
 */
class Challenge {
  /**
   * @param {Object} data - Challenge data
   */
  constructor(data) {
    this.index = data.index // Challenge number (starting from 1)
    this.status = data.status // Lifecycle state
    this.delay = data.delay // Seconds from activation until player is informed
    this.delayElapsed = data.delayElapsed ?? 0 // Seconds elapsed since activation
    this.timeout = data.timeout // Seconds to complete once started
    this.timeoutElapsed = data.timeoutElapsed ?? 0 // Seconds elapsed since started
    this.requirements = data.requirements // Requirements object
    this.blessings = data.blessings // Array of Blessing choices
    this.punishment = data.punishment // Punishment on failure
  }

  /**
   * Resets timer state and sets status back to activated (for retrying after failure).
   */
  /**
   * Whether the activation delay has fully elapsed and the challenge is ready to start.
   * @returns {boolean}
   */
  get isDelayElapsed() {
    return this.status === CHALLENGE_STATUS_ACTIVATED
      && this.delayElapsed >= this.delay
  }

  /**
   * Whether the challenge timeout has fully elapsed and is ready for resolution.
   * @returns {boolean}
   */
  get isTimeoutElapsed() {
    return this.status === CHALLENGE_STATUS_STARTED
      && this.timeoutElapsed >= this.timeout
  }

  reset() {
    this.delayElapsed = 0
    this.timeoutElapsed = 0
    this.status = CHALLENGE_STATUS_ACTIVATED
  }

  /**
   * Reconstructs a Challenge instance from serialized data.
   * @param {Object} data - Serialized challenge data
   * @returns {Challenge} Restored Challenge instance
   */
  static fromJSON(data) {
    return new Challenge({
      ...data,
      blessings: data.blessings.map(b => Blessing.fromJSON(b)),
      punishment: Punishment.fromJSON(data.punishment),
    })
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      index: this.index,
      status: this.status,
      delay: this.delay,
      delayElapsed: this.delayElapsed,
      timeout: this.timeout,
      timeoutElapsed: this.timeoutElapsed,
      requirements: this.requirements,
      blessings: this.blessings.map(b => b.toJSON()),
      punishment: this.punishment.toJSON(),
    }
  }
}

export default Challenge
