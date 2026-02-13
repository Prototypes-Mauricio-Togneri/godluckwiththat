/**
 * Base class for game events.
 * Events are ephemeral — not persisted in save data.
 *
 * @property {number} id - Unique event identifier
 * @property {string} textKey - i18n key for the event description
 * @property {string} icon - Image path relative to /img/
 */
class Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 */
  constructor(data) {
    this.id = data.id
    this.textKey = data.textKey
    this.icon = data.icon
  }
}

export default Event
