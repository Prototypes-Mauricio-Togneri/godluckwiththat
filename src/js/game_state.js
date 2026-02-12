import {PRODUCTION_RATES, SEASON_COLD_FOOD_MODIFIER, SEASON_COLD_WOOD_MODIFIER, SEASON_DURATION, SEASON_WARM_FOOD_MODIFIER, SEASON_WARM_WOOD_MODIFIER, WORKER_FOOD_CONSUMPTION, WORKER_RECRUIT_COST, WORKER_WOOD_CONSUMPTION, WORKERS_PER_LEVEL} from '@/js/balancing.js'
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

    // Worker consumption (food + wood upkeep)
    const woodSeasonMod = this.colony.season === SEASON_WARM ? SEASON_WARM_WOOD_MODIFIER : SEASON_COLD_WOOD_MODIFIER
    if (delta > 0 && resources.workers > 0) {
      const totalWorkers = resources.workers
      const foodCost = WORKER_FOOD_CONSUMPTION * delta
      const woodCost = WORKER_WOOD_CONSUMPTION * (1 + woodSeasonMod) * delta

      // Calculate deaths from each resource independently
      const foodDeaths = resources.food >= totalWorkers * foodCost
        ? 0
        : totalWorkers - Math.floor(resources.food / foodCost)
      const woodDeaths = resources.wood >= totalWorkers * woodCost
        ? 0
        : totalWorkers - Math.floor(resources.wood / woodCost)

      const workersToKill = Math.max(foodDeaths, woodDeaths)
      const surviving = totalWorkers - workersToKill

      // Deduct resources for surviving workers
      resources.food = Math.max(0, resources.food - surviving * foodCost)
      resources.wood = Math.max(0, resources.wood - surviving * woodCost)

      if (workersToKill > 0) {
        this._killWorkers(workersToKill)
      }
    }

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

    // Include worker upkeep in displayed production rates
    if (resources.workers > 0) {
      production.food -= resources.workers * WORKER_FOOD_CONSUMPTION
      production.wood -= resources.workers * WORKER_WOOD_CONSUMPTION * (1 + woodSeasonMod)
    }

  }

  /**
   * Advances the season elapsed timer and flips season when duration is reached.
   * @param {number} delta - Seconds since last season tick
   */
  advanceSeason(delta) {
    this.colony.seasonElapsed += delta
    if (this.colony.seasonElapsed >= SEASON_DURATION) {
      this.colony.seasonElapsed -= SEASON_DURATION
      if (this.colony.season === SEASON_COLD) this.colony.year++
      this.colony.season = this.colony.season === SEASON_WARM ? SEASON_COLD : SEASON_WARM
    }
  }

  /**
   * Levels up a non-HQ building: deducts cost, increments level and territory.
   * @param {string} buildingKey - Key in colony.buildings
   */
  levelUpBuilding(buildingKey) {
    const {
      resources, stockpile, buildings,
    } = this.colony
    const building = buildings[buildingKey]
    const cost = building.levelUpCost()
    if (!resources.canAfford(cost) || resources.territory >= stockpile.territory) return
    resources.deduct(cost)
    building.level += 1
    resources.territory += 1
    this.update(0)
  }

  /**
   * Levels up the headquarters: deducts cost, increments level (no territory cost).
   */
  levelUpHeadquarters() {
    const {
      resources, buildings,
    } = this.colony
    const hq = buildings.headquarters
    const cost = hq.levelUpCost()
    if (!resources.canAfford(cost)) return
    resources.deduct(cost)
    hq.level += 1
    this.update(0)
  }

  /**
   * Upgrades the headquarters to the next type: deducts cost, advances type.
   */
  upgradeHeadquarters() {
    const {
      resources, buildings,
    } = this.colony
    const hq = buildings.headquarters
    const cost = hq.upgradeCost()
    if (!cost || !resources.canAfford(cost)) return
    resources.deduct(cost)
    hq.type = hq.nextType()
    this.update(0)
  }

  /**
   * Recruits a new worker: deducts food cost, increments worker count.
   */
  recruitWorker() {
    const {
      resources, stockpile,
    } = this.colony
    if (!resources.canAfford(WORKER_RECRUIT_COST) || resources.workers >= stockpile.workers) return
    resources.deduct(WORKER_RECRUIT_COST)
    resources.workers += 1
    this.colony.idleWorkers += 1
    this.update(0)
  }

  /**
   * Assigns one idle worker to a building.
   * @param {string} buildingKey - Key in colony.buildings
   */
  assignWorker(buildingKey) {
    const building = this.colony.buildings[buildingKey]
    const maxWorkers = building.level * WORKERS_PER_LEVEL
    if (this.colony.idleWorkers <= 0 || building.workers >= maxWorkers) return
    building.workers += 1
    this.colony.idleWorkers -= 1
    this.update(0)
  }

  /**
   * Unassigns one worker from a building back to idle.
   * @param {string} buildingKey - Key in colony.buildings
   */
  unassignWorker(buildingKey) {
    const building = this.colony.buildings[buildingKey]
    if (building.workers <= 0) return
    building.workers -= 1
    this.colony.idleWorkers += 1
    this.update(0)
  }

  /**
   * Removes workers from the colony (starvation).
   * Kills idle workers first, then unassigns from buildings
   * with the most workers.
   * @param {number} count - Number of workers to remove
   */
  _killWorkers(count) {
    const {
      resources, buildings,
    } = this.colony
    let remaining = count

    // Kill idle workers first
    const idleKilled = Math.min(remaining, this.colony.idleWorkers)
    this.colony.idleWorkers -= idleKilled
    remaining -= idleKilled

    // Kill assigned workers (from buildings with the most workers first)
    while (remaining > 0) {
      let maxWorkers = 0
      let targetKey = null
      for (const [
        key,
        building,
      ] of Object.entries(buildings)) {
        if ('workers' in building && building.workers > maxWorkers) {
          maxWorkers = building.workers
          targetKey = key
        }
      }
      if (!targetKey) break
      buildings[targetKey].workers -= 1
      remaining -= 1
    }

    resources.workers -= count
  }
}

export default GameState
