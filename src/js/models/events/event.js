/**
 * Base class for game events.
 *
 * @property {number} id - Unique event identifier
 * @property {string} type - Event type constant (e.g. EVENT_TYPE_SEASON_CHANGED)
 * @property {string} textKey - i18n key for the event description
 * @property {string} icon - Full image path (e.g. '/img/resources/food.png')
 * @property {string[]} params - Positional values for i18n interpolation
 * @property {string|null} buildingKey - Building key (for construction event lookup)
 * @property {string|null} researchKey - Research key (for research event lookup)
 * @property {string|null} action - Action identifier triggered on click (e.g. 'openChallengeModal')
 */
class Event {
  /**
   * @param {Object} data - Event data
   * @param {number} data.id - Unique event identifier
   * @param {string} data.type - Event type constant
   * @param {string} data.textKey - i18n key for description
   * @param {string} data.icon - Full image path
   * @param {string[]} [data.params] - Positional i18n interpolation values
   * @param {string} [data.buildingKey] - Building key for construction lookup
   * @param {string} [data.researchKey] - Research key for research lookup
   * @param {string} [data.action] - Action identifier triggered on click
   */
  constructor(data) {
    this.id = data.id // Unique event identifier
    this.type = data.type // Event type constant
    this.textKey = data.textKey // i18n key for description
    this.icon = data.icon // Full image path
    this.params = data.params ?? [] // Positional i18n interpolation values
    this.buildingKey = data.buildingKey ?? null // Building key for construction lookup
    this.researchKey = data.researchKey ?? null // Research key for research lookup
    this.action = data.action ?? null // Action identifier triggered on click
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      textKey: this.textKey,
      icon: this.icon,
      params: this.params,
      buildingKey: this.buildingKey,
      researchKey: this.researchKey,
      action: this.action,
    }
  }
}

export default Event
