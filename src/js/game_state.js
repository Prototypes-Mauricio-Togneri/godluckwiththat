import {ALTAR_FAITH_RATE, HOUSE_BASE_POPULATION, HOUSE_POPULATION_PER_LEVEL, PRODUCTION_RATES} from '@/js/balancing.js'

/**
 * Central game state container.
 * Wraps Meta and Colony instances and will hold additional
 * session-level state (e.g. timers, events) as the game grows.
 *
 * @property {Meta} meta - Game metadata (version, timestamps, challenges)
 * @property {Colony} colony - Active colony instance
 */
class GameState {
  /**
   * @param {Meta} meta - Meta instance
   * @param {Colony} colony - Colony instance
   */
  constructor(meta, colony) {
    this.meta = meta
    this.colony = colony
  }

  /**
   * Advances the colony simulation by the given time delta.
   * Recomputes production rates from assigned workers and altar level,
   * applies resource gains scaled by delta, and caps at stockpile limits.
   *
   * @param {number} delta - Seconds elapsed since last tick
   */
  update(delta) {
    const {
      resources, production, stockpile, buildings,
    } = this.colony

    // Recalculate population cap from house level
    stockpile.workers = HOUSE_BASE_POPULATION + buildings.house.level * HOUSE_POPULATION_PER_LEVEL

    // Reset production rates to zero
    production.food = 0
    production.wood = 0
    production.stone = 0
    production.copper = 0
    production.iron = 0
    production.gold = 0
    production.faith = 0
    production.knowledge = 0

    // Compute worker-based production rates (per second)
    for (const [
      buildingKey,
      config,
    ] of Object.entries(PRODUCTION_RATES)) {
      const building = buildings[buildingKey]
      if (building.level > 0 && building.workers > 0) {
        production[config.resource] += building.workers * config.rate
      }
    }

    // Altar passive faith production (level-based, no workers)
    if (buildings.altar.level > 0) {
      production.faith += buildings.altar.level * ALTAR_FAITH_RATE
    }

    // Apply production to resources, scaled by delta time
    resources.food += production.food * delta
    resources.wood += production.wood * delta
    resources.stone += production.stone * delta
    resources.copper += production.copper * delta
    resources.iron += production.iron * delta
    resources.gold += production.gold * delta
    resources.faith += production.faith * delta
    resources.knowledge += production.knowledge * delta

    // Cap resources at stockpile limits
    resources.food = Math.min(resources.food, stockpile.food)
    resources.wood = Math.min(resources.wood, stockpile.wood)
    resources.stone = Math.min(resources.stone, stockpile.stone)
    resources.copper = Math.min(resources.copper, stockpile.copper)
    resources.iron = Math.min(resources.iron, stockpile.iron)
    resources.gold = Math.min(resources.gold, stockpile.gold)
    resources.faith = Math.min(resources.faith, stockpile.faith)
    resources.knowledge = Math.min(resources.knowledge, stockpile.knowledge)
  }
}

export default GameState
