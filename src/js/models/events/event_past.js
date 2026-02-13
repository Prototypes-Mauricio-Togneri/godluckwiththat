import Event from '@/js/models/events/event.js'

/**
 * A past event that has already occurred.
 */
class EventPast extends Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 */
  constructor(data) {
    super(data)
  }
}

export default EventPast
