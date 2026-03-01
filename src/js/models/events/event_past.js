import Event from '@/js/models/events/event.js'

/**
 * A past event that has already occurred.
 */
class EventPast extends Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.type
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 * @param {string[]} [data.params] - Positional i18n interpolation values
	 * @param {string} [data.buildingKey] - Building key for construction lookup
	 * @param {string} [data.researchKey] - Research key for research lookup
	 */
  constructor(data) {
    super(data)
  }
}

export default EventPast
