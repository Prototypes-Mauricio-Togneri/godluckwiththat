import {SEASON_DURATION} from '@/js/engine/balancing.js'
import {SEASON_COLD, SEASON_WARM} from '@/js/engine/enums.js'

/**
 * Season data model. Tracks the current season and elapsed time within it.
 *
 * @property {string} currentSeason - Current season ('warm' or 'cold')
 * @property {number} seasonElapsed - Seconds elapsed in current season
 */
class Season {
  /**
   * @param {Object} data
   * @param {string} data.currentSeason - Season identifier
   * @param {number} data.seasonElapsed - Seconds elapsed
   */
  constructor(data) {
    this.currentSeason = data.currentSeason // Current season ('warm' or 'cold')
    this.seasonElapsed = data.seasonElapsed // Seconds elapsed in current season
  }

  /** @returns {boolean} Whether the current season is warm */
  get isWarm() {
    return this.currentSeason === SEASON_WARM
  }

  /** @returns {boolean} Whether the current season is cold */
  get isCold() {
    return this.currentSeason === SEASON_COLD
  }

  /**
   * Advances the season timer and flips the season when the duration is reached.
   * @param {number} delta - Seconds since last tick
   * @returns {boolean} Whether the season changed
   */
  advance(delta) {
    this.seasonElapsed += delta
    if (this.seasonElapsed >= SEASON_DURATION) {
      this.seasonElapsed -= SEASON_DURATION
      this.currentSeason = this.isWarm ? SEASON_COLD : SEASON_WARM
      return true
    }
    return false
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      currentSeason: this.currentSeason,
      seasonElapsed: this.seasonElapsed,
    }
  }
}

export default Season
