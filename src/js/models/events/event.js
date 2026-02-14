/**
 * Base class for game events.
 * Events are ephemeral — not persisted in save data.
 *
 * @property {number} id - Unique event identifier
 * @property {string} type - Event type constant (e.g. EVENT_TYPE_SEASON_CHANGED)
 * @property {string} textKey - i18n key for the event description
 * @property {string} icon - Full image path (e.g. '/img/resources/food.png')
 */
class Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.type
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 */
  constructor(data) {
    this.id = data.id
    this.type = data.type
    this.textKey = data.textKey
    this.icon = data.icon
  }
}

export default Event
