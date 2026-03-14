import {CHALLENGE_STATUS_ACTIVATED, CHALLENGE_STATUS_COMPLETED, CHALLENGE_STATUS_STARTED} from '@/js/engine/enums.js'
import Blessing from '@/js/models/blessing.js'
import Challenge from '@/js/models/challenge.js'
import Punishment from '@/js/models/punishment.js'

/**
 * Container for the challenge system state.
 * Lives on Meta. Tracks pending, active, and completed challenges
 * plus accumulated blessings and punishments.
 *
 * @property {Challenge[]} pending - Challenges not yet activated
 * @property {Challenge|null} active - Currently active challenge (or null)
 * @property {Challenge[]} completed - Successfully completed challenges
 * @property {Blessing[]} activeBlessings - Blessings earned from completed challenges
 * @property {Punishment[]} activePunishments - Punishments from failed challenges
 */
class Challenges {
  /**
   * @param {Object} data - Challenges container data
   */
  constructor(data) {
    this.pending = data.pending // Challenges not yet activated
    this.active = data.active // Currently active challenge (or null)
    this.completed = data.completed // Successfully completed challenges
    this.activeBlessings = data.activeBlessings // Blessings earned from completions
    this.activePunishments = data.activePunishments // Punishments from failures
  }
  /** @returns {number} Total number of challenges across all states */
  get totalCount() {
    return this.pending.length + (this.active ? 1 : 0) + this.completed.length
  }

  /** @returns {boolean} Whether all challenges have been completed */
  get allCompleted() {
    return this.pending.length === 0 && this.active === null
  }

  /**
   * Moves the first pending challenge to active with status `activated`.
   */
  activate() {
    if (this.pending.length === 0) {
      return
    }
    this.active = this.pending.shift()
    this.active.status = CHALLENGE_STATUS_ACTIVATED
  }

  /**
   * Transitions the active challenge from `activated` to `started`.
   */
  start() {
    if (!this.active) {
      return
    }
    this.active.status = CHALLENGE_STATUS_STARTED
  }

  /**
   * Completes the active challenge: moves it to completed, stores the chosen blessing.
   * @param {Blessing} blessing - The blessing the player chose as reward
   */
  complete(blessing) {
    if (!this.active) {
      return
    }
    this.active.status = CHALLENGE_STATUS_COMPLETED
    this.completed.push(this.active)
    this.activeBlessings.push(blessing)
    this.active = null
  }

  /**
   * Fails the active challenge: resets timers, stores the punishment.
   * @param {Punishment} punishment - The punishment applied
   */
  fail(punishment) {
    if (!this.active) {
      return
    }
    this.active.reset()
    this.activePunishments.push(punishment)
  }

  /**
   * Advances the active challenge timers by the elapsed delta.
   * @param {number} delta - Seconds since last tick
   */
  advance(delta) {
    if (!this.active) {
      return
    }
    if (this.active.status === CHALLENGE_STATUS_ACTIVATED) {
      this.active.delayElapsed += delta
    } else if (this.active.status === CHALLENGE_STATUS_STARTED) {
      this.active.timeoutElapsed += delta
    }
  }

  /**
   * Reconstructs a Challenges instance from serialized data.
   * @param {Object} data - Serialized challenges data
   * @returns {Challenges} Restored Challenges instance
   */
  static fromJSON(data) {
    return new Challenges({
      pending: (data.pending ?? []).map(c => Challenge.fromJSON(c)),
      active: data.active ? Challenge.fromJSON(data.active) : null,
      completed: (data.completed ?? []).map(c => Challenge.fromJSON(c)),
      activeBlessings: (data.activeBlessings ?? []).map(b => Blessing.fromJSON(b)),
      activePunishments: (data.activePunishments ?? []).map(p => Punishment.fromJSON(p)),
    })
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      pending: this.pending.map(c => c.toJSON()),
      active: this.active ? this.active.toJSON() : null,
      completed: this.completed.map(c => c.toJSON()),
      activeBlessings: this.activeBlessings.map(b => b.toJSON()),
      activePunishments: this.activePunishments.map(p => p.toJSON()),
    }
  }
}

export default Challenges
