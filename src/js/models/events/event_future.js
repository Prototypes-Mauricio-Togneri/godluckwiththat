import Event from '@/js/models/events/event.js'

/**
 * A future event with a countdown timer.
 *
 * @property {number} remainingSeconds - Seconds until event fires
 */
class EventFuture extends Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.type
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 * @param {number} data.remainingSeconds
	 */
  constructor(data) {
    super(data)
    this.remainingSeconds = data.remainingSeconds
  }
}

export default EventFuture
