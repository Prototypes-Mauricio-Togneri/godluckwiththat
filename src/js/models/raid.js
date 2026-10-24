import {TRIBUTE_CANCEL_MULTIPLIER, TRIBUTE_DELAY_GROWTH} from '@/js/engine/balancing.js'
import {RAID_PHASE_INCOMING, RAID_PHASE_WAITING} from '@/js/engine/enums.js'
import {unitCounts} from '@/js/engine/utils.js'
import Cost from '@/js/models/cost.js'

/**
 * A raid on the colony. Waits on a hidden timer, then is announced and counts down
 * (incoming phase) until it arrives and the battle is resolved.
 *
 * @property {string} phase - RAID_PHASE_WAITING or RAID_PHASE_INCOMING
 * @property {number} remainingSeconds - Seconds left in the current phase
 * @property {Object<string, number>} enemy - Raider count per unit type (all 0 while waiting)
 * @property {Cost|null} demand - Base tribute demand (null while waiting)
 * @property {number} delaysPaid - Number of delays already bought
 */
class Raid {
  /**
   * @param {Object} [data] - Raid data (missing fields get defaults)
   */
  constructor(data = {}) {
    // Only restore a known phase, so an edited save can't send an unknown one into the battle
    this.phase = data.phase === RAID_PHASE_INCOMING ? RAID_PHASE_INCOMING : RAID_PHASE_WAITING // Waiting (hidden) or incoming (announced)
    this.remainingSeconds = data.remainingSeconds ?? 0 // Seconds left in the current phase
    this.enemy = unitCounts(data.enemy) // Raider count per unit type
    this.demand = data.demand ? new Cost(data.demand) : null // Base tribute demand, set at the announcement
    this.delaysPaid = data.delaysPaid ?? 0 // Delays already bought
  }

  /** @returns {number} Total raiders across all unit types */
  get enemyCount() {
    let total = 0
    for (const count of Object.values(this.enemy)) {
      total += count
    }
    return total
  }

  /** @returns {Cost|null} Price of the next delay (base × growth ^ delaysPaid), or null before the announcement */
  get delayCost() {
    return this.demand?.multiplyFloor(Math.pow(TRIBUTE_DELAY_GROWTH, this.delaysPaid)) ?? null
  }

  /** @returns {Cost|null} Price of calling the raid off (base × cancel multiplier), or null before the announcement */
  get cancelCost() {
    return this.demand?.multiplyFloor(TRIBUTE_CANCEL_MULTIPLIER) ?? null
  }

  /** @returns {boolean} Whether another delay is offered (stops once it would cost more than cancelling) */
  get canDelay() {
    return Math.pow(TRIBUTE_DELAY_GROWTH, this.delaysPaid) <= TRIBUTE_CANCEL_MULTIPLIER
  }

  /**
   * Counts the current phase down, clamped at 0.
   * @param {number} delta - Seconds elapsed
   * @returns {boolean} Whether the phase timer has reached 0
   */
  advance(delta) {
    this.remainingSeconds = Math.max(0, this.remainingSeconds - delta)
    return this.remainingSeconds === 0
  }

  /**
   * Reconstructs a Raid instance from serialized data.
   * @param {Object} data - Serialized raid data
   * @returns {Raid} Restored Raid instance
   */
  static fromJSON(data) {
    return new Raid(data)
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      phase: this.phase,
      remainingSeconds: this.remainingSeconds,
      enemy: {
        ...this.enemy,
      },
      demand: this.demand ? Object.fromEntries(this.demand.entries) : null,
      delaysPaid: this.delaysPaid,
    }
  }
}

export default Raid
