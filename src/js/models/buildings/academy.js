import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_ACADEMY} from '@/js/engine/enums.js'
import Producer from '@/js/models/buildings/producer.js'

/**
 * Generates knowledge for the colony and manages research state.
 *
 * @property {Set<string>} completed - Set of completed research keys
 * @property {Map<string, Research>} active - In-progress researches
 */
class Academy extends Producer {
  /**
   * @param {Object} data - Initial building data
   * @param {string[]} [data.completed] - Array of completed research keys
   * @param {Array<{key: string, remainingSeconds: number, duration: number}>} [data.active] - Serialized active researches
   */
  constructor(data) {
    super(data)
    this.completed = new Set(data.completed ?? [])
    this.active = new Map()
    for (const entry of (data.active ?? [])) {
      this.active.set(entry.key, new Research(entry.duration, entry.remainingSeconds))
    }
  }

  /**
   * Cost to level up from the current level.
   * @returns {Cost}
   */
  get levelUpCost() {
    const {
      cost, multiplier,
    } = BUILDING_UPGRADES[BUILDING_ACADEMY]
    return cost.multiply(Math.pow(multiplier, this.level)).floor
  }

  /**
   * @param {string} key - Research key
   * @returns {boolean} Whether the research is completed
   */
  isCompleted(key) {
    return this.completed.has(key)
  }

  /**
   * @param {string} key - Research key
   * @returns {boolean} Whether the research is currently active
   */
  isActive(key) {
    return this.active.has(key)
  }

  /**
   * Whether the academy can start a given research.
   * @param {string} key - Research key
   * @returns {boolean}
   */
  canResearch(key) {
    return this.level >= 1 && !this.isActive(key) && !this.isCompleted(key)
  }

  /**
   * @param {string} key - Research key
   * @returns {Research|undefined} The active research instance, or undefined if not active
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
    this.active.set(key, new Research(duration))
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
   * @param {Array<Object>} researchTree - RESEARCH_TREE from constants.js
   * @returns {Object<string, number>} Bonus type → cumulative value
   */
  completedBonuses(researchTree) {
    const bonuses = {}
    for (const cat of researchTree) {
      for (const sub of cat.subcategories) {
        if (!sub.bonus) {
          continue
        }
        for (const key of sub.researches) {
          if (!this.completed.has(key)) {
            continue
          }
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
      level: this.level,
      constructionRemaining: this.constructionRemaining,
      constructionDuration: this.constructionDuration,
      workers: this.workers,
      completed: [...this.completed],
      active: [...this.active.entries()].map(([
        key,
        data,
      ]) => ({
        key: key,
        remainingSeconds: data.remainingSeconds,
        duration: data.duration,
      })),
    }
  }
}

/**
 * Tracks the progress of a single active research.
 *
 * @property {number} duration - Total duration in seconds
 * @property {number} remainingSeconds - Seconds remaining until completion
 */
class Research {
  /**
   * @param {number} duration - Total duration in seconds
   * @param {number} [remainingSeconds] - Seconds remaining (defaults to duration)
   */
  constructor(duration, remainingSeconds = duration) {
    this.duration = duration
    this.remainingSeconds = remainingSeconds
  }

  /**
   * Advances the timer by the given delta.
   * @param {number} delta - Seconds elapsed
   * @returns {boolean} True if the research just completed
   */
  advance(delta) {
    this.remainingSeconds = Math.max(0, this.remainingSeconds - delta)
    return this.remainingSeconds === 0
  }
}

export default Academy
