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
   * Completes the active challenge: moves it to completed, stores a copy of the chosen blessing.
   * A copy is stored so the timeout countdown does not drain the challenge's own blessing.
   * @param {Blessing} blessing - The blessing the player chose as reward
   */
  complete(blessing) {
    if (!this.active) {
      return
    }
    this.active.status = CHALLENGE_STATUS_COMPLETED
    this.completed.push(this.active)
    this.activeBlessings.push(Blessing.fromJSON(blessing.toJSON()))
    this.active = null
  }

  /**
   * Fails the active challenge: resets timers, stores a copy of the punishment.
   * A copy is stored so the timeout countdown does not drain the challenge's own punishment,
   * which is reused if the challenge is failed again.
   * @param {Punishment} punishment - The punishment applied
   */
  fail(punishment) {
    if (!this.active) {
      return
    }
    this.active.reset()
    this.activePunishments.push(Punishment.fromJSON(punishment.toJSON()))
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
      pending: (data.pending ?? []).map(challenge => Challenge.fromJSON(challenge)),
      active: data.active ? Challenge.fromJSON(data.active) : null,
      completed: (data.completed ?? []).map(challenge => Challenge.fromJSON(challenge)),
      activeBlessings: (data.activeBlessings ?? []).map(blessing => Blessing.fromJSON(blessing)),
      activePunishments: (data.activePunishments ?? []).map(punishment => Punishment.fromJSON(punishment)),
    })
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      pending: this.pending.map(challenge => challenge.toJSON()),
      active: this.active ? this.active.toJSON() : null,
      completed: this.completed.map(challenge => challenge.toJSON()),
      activeBlessings: this.activeBlessings.map(blessing => blessing.toJSON()),
      activePunishments: this.activePunishments.map(punishment => punishment.toJSON()),
    }
  }
}

export default Challenges
