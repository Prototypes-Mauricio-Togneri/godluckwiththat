import {PRODUCTION_RATES, SEASON_COLD_FOOD_MODIFIER, SEASON_DURATION, SEASON_WARM_FOOD_MODIFIER} from '@/js/balancing.js'
import {SEASON_COLD, SEASON_WARM} from '@/js/constants.js'

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
    this.meta = meta // Game metadata (version, timestamps, challenges)
    this.colony = colony // Active colony instance
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

    // Recalculate territory used and stockpile caps from building levels
    resources.territory = buildings.totalLevels()
    stockpile.territory = buildings.headquarters.territoryCap()
    stockpile.workers = buildings.house.populationCap()
    stockpile.food = buildings.storehouse.storageCap()
    stockpile.wood = buildings.storehouse.storageCap()
    stockpile.stone = buildings.storehouse.storageCap()
    stockpile.copper = buildings.storehouse.storageCap()
    stockpile.iron = buildings.storehouse.storageCap()
    stockpile.gold = buildings.storehouse.storageCap()

    // Reset production rates to zero
    production.food = 0
    production.wood = 0
    production.stone = 0
    production.copper = 0
    production.iron = 0
    production.gold = 0
    production.faith = 0
    production.knowledge = 0

    // Compute production rates (per second)
    for (const [
      buildingKey,
      config,
    ] of Object.entries(PRODUCTION_RATES)) {
      const building = buildings[buildingKey]
      if (building.level > 0) {
        if (config.passive) {
          production[config.resource] += building.level * config.rate
        } else if (building.workers > 0) {
          production[config.resource] += building.workers * config.rate
        }
      }
    }

    // Apply seasonal modifier to food production
    const seasonMod = this.colony.season === SEASON_WARM ? SEASON_WARM_FOOD_MODIFIER : SEASON_COLD_FOOD_MODIFIER
    production.food *= 1 + seasonMod

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

    // Ensure no resource goes below zero
    resources.food = Math.max(0, resources.food)
    resources.wood = Math.max(0, resources.wood)
    resources.stone = Math.max(0, resources.stone)
    resources.copper = Math.max(0, resources.copper)
    resources.iron = Math.max(0, resources.iron)
    resources.gold = Math.max(0, resources.gold)
    resources.faith = Math.max(0, resources.faith)
    resources.knowledge = Math.max(0, resources.knowledge)

    // Advance season timer
    this.colony.seasonElapsed += delta
    if (this.colony.seasonElapsed >= SEASON_DURATION) {
      this.colony.seasonElapsed -= SEASON_DURATION
      this.colony.season = this.colony.season === SEASON_WARM ? SEASON_COLD : SEASON_WARM
    }
  }
}

export default GameState
