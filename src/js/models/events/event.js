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
 */
class Event {
  /**
	 * @param {Object} data
	 * @param {number} data.id
	 * @param {string} data.type
	 * @param {string} data.textKey
	 * @param {string} data.icon
	 * @param {string[]} [data.params]
	 * @param {string} [data.buildingKey]
	 * @param {string} [data.researchKey]
	 */
  constructor(data) {
    this.id = data.id // Unique event identifier
    this.type = data.type // Event type constant
    this.textKey = data.textKey // i18n key for description
    this.icon = data.icon // Full image path
    this.params = data.params ?? [] // Positional i18n interpolation values
    this.buildingKey = data.buildingKey ?? null // Building key for construction lookup
    this.researchKey = data.researchKey ?? null // Research key for research lookup
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
    }
  }
}

export default Event
