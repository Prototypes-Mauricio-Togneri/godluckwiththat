import Building from '@/js/models/buildings/building.js'

/**
 * Base class for buildings that accept worker assignments.
 *
 * @property {number} workers - Number of workers assigned to this building
 */
class Producer extends Building {
  /**
   * @param {Object} data - Initial building data
   */
  constructor(data) {
    super(data)
    this.workers = data.workers ?? 0 // Assigned workers (default 0)
  }
}

export default Producer
