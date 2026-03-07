import {WORKERS_PER_LEVEL} from '@/js/engine/balancing.js'
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

  /** @returns {number} Maximum assignable workers at the current level */
  get maxWorkers() {
    return this.level * WORKERS_PER_LEVEL
  }

  /** @returns {boolean} Whether this building has no workers assigned */
  get isEmpty() {
    return this.workers <= 0
  }

  /** @returns {boolean} Whether this building has the maximum workers assigned */
  get isFull() {
    return this.workers >= this.maxWorkers
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      ...super.toJSON(),
      workers: this.workers,
    }
  }
}

export default Producer
