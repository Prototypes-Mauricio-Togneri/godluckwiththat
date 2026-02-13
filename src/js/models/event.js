/**
 * Represents a single game event (future or past).
 * Events are ephemeral — not persisted in save data.
 *
 * @property {number} id - Unique event identifier
 * @property {string} textKey - i18n key for the event description
 * @property {string} icon - Image path relative to /img/
 * @property {number} remainingSeconds - Seconds until event fires (0 for past)
 * @property {boolean} past - Whether this event has already occurred
 */
class Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 * @param {number} data.remainingSeconds
	 * @param {boolean} [data.past]
	 */
  constructor(data) {
    this.id = data.id
    this.textKey = data.textKey
    this.icon = data.icon
    this.remainingSeconds = data.remainingSeconds
    this.past = data.past ?? false
  }
}

export default Event
