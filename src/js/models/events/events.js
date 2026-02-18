import EventFuture from '@/js/models/events/event_future.js'
import EventPast from '@/js/models/events/event_past.js'

/**
 * Container for all active game events.
 * Events are ephemeral session-level data, not persisted in save data.
 *
 * @property {(EventFuture|EventPast)[]} items - All current events
 */
class Events {
  constructor() {
    this.items = []
    this._nextId = 1
  }

  /**
	 * Adds a new future event with a countdown.
	 * @param {Object} data
	 * @param {string} data.type - Event type constant
	 * @param {string} data.textKey - i18n key
	 * @param {string} data.icon - Full image path (e.g. '/img/resources/food.png')
	 * @param {number} data.remainingSeconds - Countdown duration
	 * @returns {EventFuture}
	 */
  addFuture(data) {
    const event = new EventFuture({
      id: this._nextId++,
      type: data.type,
      textKey: data.textKey,
      icon: data.icon,
      params: data.params,
      buildingKey: data.buildingKey,
      remainingSeconds: data.remainingSeconds,
    })
    this.items.push(event)
    return event
  }

  /**
	 * Adds a new past event (no countdown).
	 * @param {Object} data
	 * @param {string} data.type - Event type constant
	 * @param {string} data.textKey - i18n key
	 * @param {string} data.icon - Full image path (e.g. '/img/resources/food.png')
	 * @returns {EventPast}
	 */
  addPast(data) {
    const event = new EventPast({
      id: this._nextId++,
      type: data.type,
      textKey: data.textKey,
      icon: data.icon,
      params: data.params,
      buildingKey: data.buildingKey,
    })
    this.items.push(event)
    return event
  }

  /**
	 * Finds the future event for the given building key, removes it,
	 * and adds a new past event with the provided data.
	 * @param {string} buildingKey - Building key to match
	 * @param {Object} data - Past event data (type, textKey, icon, params)
	 */
  convertToPast(buildingKey, data) {
    const index = this.items.findIndex(
      event => event instanceof EventFuture && event.buildingKey === buildingKey,
    )
    if (index !== -1) this.items.splice(index, 1)
    this.addPast(data)
  }

  /**
	 * Removes a future event by its building key.
	 * @param {string} buildingKey - Building key to match
	 */
  dismissFuture(buildingKey) {
    const index = this.items.findIndex(
      event => event instanceof EventFuture && event.buildingKey === buildingKey,
    )
    if (index !== -1) this.items.splice(index, 1)
  }

  /**
	 * Removes an event by its ID.
	 * @param {number} id
	 */
  dismiss(id) {
    const index = this.items.findIndex(event => event.id === id)
    if (index !== -1) this.items.splice(index, 1)
  }

  /**
	 * Removes all past events.
	 */
  dismissAllPast() {
    this.items = this.items.filter(event => !(event instanceof EventPast))
  }

  /**
	 * Returns future events sorted by remaining seconds ascending.
	 * @returns {EventFuture[]}
	 */
  future() {
    return this.items.filter(event => event instanceof EventFuture).sort((a, b) => a.remainingSeconds - b.remainingSeconds)
  }

  /**
	 * Returns past events sorted by ID descending (most recent first).
	 * @returns {EventPast[]}
	 */
  past() {
    return this.items.filter(event => event instanceof EventPast).sort((a, b) => b.id - a.id)
  }

  /**
	 * Decrements remaining seconds on future events.
	 * Clamps at 0 — does not auto-convert to past.
	 * @param {number} delta - Seconds elapsed since last tick
	 */
  tick(delta) {
    for (const event of this.items) {
      if (event instanceof EventFuture && event.remainingSeconds > 0) {
        event.remainingSeconds = Math.max(0, event.remainingSeconds - delta)
      }
    }
  }
}

export default Events
