import EventFuture from '@/js/models/events/event_future.js'
import EventPast from '@/js/models/events/event_past.js'

/**
 * Container for all active game events.
 *
 * @property {EventFuture[]} future - Active future events (countdowns)
 * @property {EventPast[]} past - Active past events (notifications)
 */
class Events {
  /** Initializes empty event containers. */
  constructor() {
    this.future = [] // Active future events (countdowns)
    this.past = [] // Past events (notifications)
    this._nextId = 1 // Auto-incrementing event ID counter
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
      researchKey: data.researchKey,
      remainingSeconds: data.remainingSeconds,
    })
    this.future.push(event)
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
      researchKey: data.researchKey,
    })
    this.past.push(event)
    return event
  }

  /**
	 * Finds the future event for the given building key, removes it,
	 * and adds a new past event with the provided data.
	 * @param {string} buildingKey - Building key to match
	 * @param {Object} data - Past event data (type, textKey, icon, params)
	 */
  convertToPast(buildingKey, data) {
    const index = this.future.findIndex(
      event => event.buildingKey === buildingKey,
    )
    if (index !== -1) {
      this.future.splice(index, 1)
    }
    this.addPast(data)
  }

  /**
	 * Removes a future event by its building key.
	 * @param {string} buildingKey - Building key to match
	 */
  dismissFuture(buildingKey) {
    const index = this.future.findIndex(
      event => event.buildingKey === buildingKey,
    )
    if (index !== -1) {
      this.future.splice(index, 1)
    }
  }

  /**
	 * Removes a future event by its research key.
	 * @param {string} researchKey - Research key to match
	 */
  dismissFutureByResearchKey(researchKey) {
    const index = this.future.findIndex(
      event => event.researchKey === researchKey,
    )
    if (index !== -1) {
      this.future.splice(index, 1)
    }
  }

  /**
	 * Removes an event by its ID.
	 * @param {number} id
	 */
  dismiss(id) {
    let index = this.future.findIndex(event => event.id === id)
    if (index !== -1) {
      this.future.splice(index, 1)
      return
    }
    index = this.past.findIndex(event => event.id === id)
    if (index !== -1) {
      this.past.splice(index, 1)
    }
  }

  /**
	 * Removes all past events matching the given type.
	 * @param {string} type - Event type constant
	 */
  dismissPastByType(type) {
    this.past = this.past.filter(event => event.type !== type)
  }

  /**
	 * Removes all past events matching the given text key.
	 * @param {string} textKey - i18n key to match
	 */
  dismissPastByTextKey(textKey) {
    this.past = this.past.filter(event => event.textKey !== textKey)
  }

  /**
	 * Removes all past events.
	 */
  dismissAllPast() {
    this.past = []
  }

  /**
	 * Returns future events sorted by remaining seconds ascending.
	 * @returns {EventFuture[]}
	 */
  get sortedFuture() {
    return [...this.future].sort((a, b) => a.remainingSeconds - b.remainingSeconds)
  }

  /**
	 * Returns past events sorted by ID descending (most recent first).
	 * @returns {EventPast[]}
	 */
  get sortedPast() {
    return [...this.past].sort((a, b) => b.id - a.id)
  }

  /**
	 * Decrements remaining seconds on future events.
	 * Clamps at 0 — does not auto-convert to past.
	 * @param {number} delta - Seconds elapsed since last tick
	 */
  advance(delta) {
    for (const event of this.future) {
      event.advance(delta)
    }
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object}
   */
  toJSON() {
    return {
      future: this.future.map(e => e.toJSON()),
      past: this.past.map(e => e.toJSON()),
      nextId: this._nextId,
    }
  }
}

export default Events
