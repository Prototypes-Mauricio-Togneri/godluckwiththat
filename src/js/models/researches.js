/**
 * Research state model.
 * Tracks completed and in-progress researches.
 *
 * @property {Set<string>} completed - Set of completed research keys
 * @property {Map<string, {remainingSeconds: number, duration: number}>} active - In-progress researches
 */
class Researches {
  /**
   * @param {Object} [data] - Serialized state (from toJSON)
   * @param {string[]} [data.completed] - Array of completed research keys
   * @param {Array<{key: string, remainingSeconds: number, duration: number}>} [data.active] - Active researches
   */
  constructor(data = {}) {
    this.completed = new Set(data.completed ?? []) // Set of completed research keys
    this.active = new Map() // Map of active researches (key → {remainingSeconds, duration})
    for (const entry of (data.active ?? [])) {
      this.active.set(entry.key, {
        remainingSeconds: entry.remainingSeconds,
        duration: entry.duration,
      })
    }
  }

  /**
   * @param {string} key - Research key
   * @returns {boolean}
   */
  isCompleted(key) {
    return this.completed.has(key)
  }

  /**
   * @param {string} key - Research key
   * @returns {boolean}
   */
  isActive(key) {
    return this.active.has(key)
  }

  /**
   * @param {string} key - Research key
   * @returns {{remainingSeconds: number, duration: number}|undefined}
   */
  getActive(key) {
    return this.active.get(key)
  }

  /**
   * Starts a new research.
   * @param {string} key - Research key
   * @param {number} duration - Total duration in seconds
   */
  start(key, duration) {
    this.active.set(key, {
      remainingSeconds: duration,
      duration,
    })
  }

  /**
   * Moves a research from active to completed.
   * @param {string} key - Research key
   */
  complete(key) {
    this.active.delete(key)
    this.completed.add(key)
  }

  /**
   * Aggregates bonus values from all completed researches by bonus type.
   * @param {Array} researchTree - RESEARCH_TREE from constants.js
   * @returns {Object<string, number>} Bonus type → cumulative value
   */
  completedBonuses(researchTree) {
    const bonuses = {}
    for (const cat of researchTree) {
      for (const sub of cat.subcategories) {
        if (!sub.bonus) continue
        for (const key of sub.researches) {
          if (!this.completed.has(key)) continue
          const {
            type, value,
          } = sub.bonus
          bonuses[type] = (bonuses[type] ?? 0) + value
        }
      }
    }
    return bonuses
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object}
   */
  toJSON() {
    return {
      completed: [...this.completed],
      active: [...this.active.entries()].map(([
        key,
        data,
      ]) => ({
        key,
        remainingSeconds: data.remainingSeconds,
        duration: data.duration,
      })),
    }
  }
}

export default Researches
