import Event from '@/js/models/events/event.js'

/**
 * Container for all active game events.
 * Events are ephemeral session-level data, not persisted in save data.
 *
 * @property {Event[]} items - All current events (future and past)
 */
class Events {
  constructor() {
    this.items = []
    this._nextId = 1
  }

  /**
	 * Adds a new future event with a countdown.
	 * @param {Object} data
	 * @param {string} data.textKey - i18n key
	 * @param {string} data.icon - Image path relative to /img/
	 * @param {number} data.remainingSeconds - Countdown duration
	 * @returns {Event}
	 */
  addFuture(data) {
    const event = new Event({
      id: this._nextId++,
      textKey: data.textKey,
      icon: data.icon,
      remainingSeconds: data.remainingSeconds,
      past: false,
    })
    this.items.push(event)
    return event
  }

  /**
	 * Adds a new past event (no countdown).
	 * @param {Object} data
	 * @param {string} data.textKey - i18n key
	 * @param {string} data.icon - Image path relative to /img/
	 * @returns {Event}
	 */
  addPast(data) {
    const event = new Event({
      id: this._nextId++,
      textKey: data.textKey,
      icon: data.icon,
      remainingSeconds: 0,
      past: true,
    })
    this.items.push(event)
    return event
  }

  /**
	 * Removes an event by its ID.
	 * @param {number} id
	 */
  dismiss(id) {
    const index = this.items.findIndex(e => e.id === id)
    if (index !== -1) this.items.splice(index, 1)
  }

  /**
	 * Returns future events sorted by remaining seconds ascending.
	 * @returns {Event[]}
	 */
  future() {
    return this.items.filter(e => !e.past).sort((a, b) => a.remainingSeconds - b.remainingSeconds)
  }

  /**
	 * Returns past events sorted by ID descending (most recent first).
	 * @returns {Event[]}
	 */
  past() {
    return this.items.filter(e => e.past).sort((a, b) => b.id - a.id)
  }

  /**
	 * Decrements remaining seconds on future events.
	 * Clamps at 0 — does not auto-convert to past.
	 * @param {number} delta - Seconds elapsed since last tick
	 */
  tick(delta) {
    for (const event of this.items) {
      if (!event.past && event.remainingSeconds > 0) {
        event.remainingSeconds = Math.max(0, event.remainingSeconds - delta)
      }
    }
  }
}

export default Events
