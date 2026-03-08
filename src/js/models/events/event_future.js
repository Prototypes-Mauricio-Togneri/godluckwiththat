import Event from '@/js/models/events/event.js'

/**
 * A future event with a countdown timer.
 *
 * @property {number} remainingSeconds - Seconds until event fires
 */
class EventFuture extends Event {
  /**
   * @param {Object} data - Future event data
   * @param {number} data.id - Unique event identifier
   * @param {string} data.type - Event type constant
   * @param {string} data.textKey - i18n key for description
   * @param {string} data.icon - Full image path
   * @param {string[]} [data.params] - Positional i18n interpolation values
   * @param {string} [data.buildingKey] - Building key for construction lookup
   * @param {string} [data.researchKey] - Research key for research lookup
   * @param {number} data.remainingSeconds - Countdown duration in seconds
   */
  constructor(data) {
    super(data)
    this.remainingSeconds = data.remainingSeconds // Seconds until event fires
  }

  /**
   * Decrements remaining seconds, clamped at 0.
   * @param {number} delta - Seconds elapsed since last tick
   */
  advance(delta) {
    if (this.remainingSeconds > 0) {
      this.remainingSeconds = Math.max(0, this.remainingSeconds - delta)
    }
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      ...super.toJSON(),
      remainingSeconds: this.remainingSeconds,
    }
  }
}

export default EventFuture
