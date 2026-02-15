import {PRODUCTION_RATES, SEASON_COLD_FOOD_MODIFIER, SEASON_COLD_WOOD_MODIFIER, SEASON_DURATION, SEASON_WARM_FOOD_MODIFIER, SEASON_WARM_WOOD_MODIFIER, WORKER_FOOD_CONSUMPTION, WORKER_RECRUIT_COST, WORKER_WOOD_CONSUMPTION, WORKERS_PER_LEVEL} from '@/js/engine/balancing.js'
import {IMG_OTHER_TERRITORY, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER} from '@/js/engine/assets.js'
import {BOUNDED_RESOURCES, BUILDING_IMAGE_MAP, EVENT_TYPE_BUILDING_UPGRADE, EVENT_TYPE_POPULATION_LIMIT_REACHED, EVENT_TYPE_RESOURCE_LIMIT_REACHED, EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION, EVENT_TYPE_SEASON_CHANGED, EVENT_TYPE_TERRITORY_LIMIT_REACHED, RESOURCE_LIMIT_EVENT_CONFIG, RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG, SEASON_COLD, SEASON_WARM} from '@/js/engine/constants.js'
import {t} from '@/js/i18n/localized.js'

/**
 * Central game state container.
 * Wraps Meta and Colony instances and will hold additional
 * session-level state (e.g. timers, events) as the game grows.
 *
 * @property {Meta} meta - Game metadata (version, timestamps, challenges)
 * @property {Colony} colony - Active colony instance
 * @property {Events} events - Ephemeral event log (not persisted)
 */
class GameState {
  /**
   * @param {Meta} meta - Meta instance
   * @param {Colony} colony - Colony instance
   * @param {Events} events - Events instance
   */
  constructor(meta, colony, events) {
    this.meta = meta // Game metadata (version, timestamps, challenges)
    this.colony = colony // Active colony instance
    this.events = events // Ephemeral event log (not persisted)

    // Track which bounded resources are currently at their stockpile cap
    // (initialized from current state so loading a save doesn't immediately fire events)
    this._resourcesAtCap = new Set(
      BOUNDED_RESOURCES.filter(r => colony.resources[r] >= colony.stockpile[r]),
    )

    // Track which bounded resources currently have negative net production
    // (initialized empty — production is 0 before the first update tick)
    this._resourcesNegativeProduction = new Set()

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
    resources.territory = buildings.totalLevels() + buildings.pendingTerritory()
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

    // Seasonal modifier to food production
    const foodSeasonMod = this.colony.isWarmSeason ? SEASON_WARM_FOOD_MODIFIER : SEASON_COLD_FOOD_MODIFIER
    production.food *= 1 + foodSeasonMod

    // Seasonal modifier for wood consumption
    const woodSeasonMod = this.colony.isWarmSeason ? SEASON_WARM_WOOD_MODIFIER : SEASON_COLD_WOOD_MODIFIER

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
    if (delta > 0 && resources.workers > 0) {
      const totalWorkers = resources.workers
      const foodCost = totalWorkers * WORKER_FOOD_CONSUMPTION * delta
      const woodCost = totalWorkers * WORKER_WOOD_CONSUMPTION * (1 + woodSeasonMod) * delta
      resources.food = Math.max(0, resources.food - foodCost)
      resources.wood = Math.max(0, resources.wood - woodCost)
    }

    // Cap resources at stockpile limits
    resources.food = Math.min(resources.food, stockpile.food)
    resources.wood = Math.min(resources.wood, stockpile.wood)
    resources.stone = Math.min(resources.stone, stockpile.stone)
    resources.copper = Math.min(resources.copper, stockpile.copper)
    resources.iron = Math.min(resources.iron, stockpile.iron)
    resources.gold = Math.min(resources.gold, stockpile.gold)

    // Fire events for resources that just reached their stockpile cap
    for (const resource of BOUNDED_RESOURCES) {
      if (resources[resource] >= stockpile[resource]) {
        if (!this._resourcesAtCap.has(resource)) {
          this._resourcesAtCap.add(resource)
          const config = RESOURCE_LIMIT_EVENT_CONFIG[resource]
          this.events.addPast({
            type: EVENT_TYPE_RESOURCE_LIMIT_REACHED,
            textKey: config.textKey,
            icon: config.icon,
          })
        }
      } else {
        this._resourcesAtCap.delete(resource)
      }
    }

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

    // Fire events for resources whose net production just went negative
    for (const resource of BOUNDED_RESOURCES) {
      if (production[resource] < 0) {
        if (!this._resourcesNegativeProduction.has(resource)) {
          this._resourcesNegativeProduction.add(resource)
          const config = RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG[resource]
          this.events.addPast({
            type: EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION,
            textKey: config.textKey,
            icon: config.icon,
          })
        }
      } else {
        this._resourcesNegativeProduction.delete(resource)
      }
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
      if (this.colony.isColdSeason) this.colony.year++
      this.colony.season = this.colony.isWarmSeason ? SEASON_COLD : SEASON_WARM
      const isWarm = this.colony.isWarmSeason
      this.events.addPast({
        type: EVENT_TYPE_SEASON_CHANGED,
        textKey: isWarm ? 'event.warmSeason' : 'event.coldSeason',
        icon: isWarm ? IMG_SEASON_WARM : IMG_SEASON_COLD,
      })
    }
  }

  /**
   * Advances construction timers for all buildings and the HQ type upgrade.
   * When a timer reaches zero, applies the upgrade (level increment or type advance).
   * Driven by requestAnimationFrame for smooth visual progress.
   * @param {number} delta - Seconds since last progress tick
   */
  advanceConstruction(delta) {
    const {
      buildings,
    } = this.colony
    for (const [
      key,
      building,
    ] of Object.entries(buildings)) {
      if (building.constructionRemaining > 0) {
        building.constructionRemaining = Math.max(0, building.constructionRemaining - delta)
        if (building.constructionRemaining === 0) {
          building.level += 1
          building.constructionDuration = 0
          if (key === 'headquarters') {
            this.events.convertToPast(key, {
              type: EVENT_TYPE_BUILDING_UPGRADE,
              textKey: 'event.territoryExpanded',
              icon: IMG_OTHER_TERRITORY,
              buildingKey: key,
            })
          } else {
            this.events.convertToPast(key, {
              type: EVENT_TYPE_BUILDING_UPGRADE,
              textKey: building.level === 1 ? 'event.buildingBuilt' : 'event.buildingUpgraded',
              icon: BUILDING_IMAGE_MAP[key],
              params: [this._buildingName(key)],
              buildingKey: key,
            })
          }
        }
      }
    }
    const hq = buildings.headquarters
    if (hq.upgradeRemaining > 0) {
      hq.upgradeRemaining = Math.max(0, hq.upgradeRemaining - delta)
      if (hq.upgradeRemaining === 0) {
        hq.type = hq.nextType()
        hq.upgradeDuration = 0
      }
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
    if (building.constructionRemaining > 0) return
    const cost = building.levelUpCost()
    if (!resources.canAfford(cost) || resources.territory >= stockpile.territory) return
    resources.deduct(cost)

    const duration = cost.toSeconds()
    building.constructionDuration = duration
    building.constructionRemaining = duration

    const isNewBuilding = building.level === 0
    this.events.addFuture({
      type: EVENT_TYPE_BUILDING_UPGRADE,
      textKey: isNewBuilding ? 'event.buildingBuilding' : 'event.buildingUpgrading',
      icon: BUILDING_IMAGE_MAP[buildingKey],
      params: [this._buildingName(buildingKey).toLowerCase()],
      buildingKey,
      remainingSeconds: duration,
    })

    this.update(0)

    // Fire territory event after update recalculates territory with pending
    if (resources.territory >= stockpile.territory) {
      this.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
        icon: IMG_OTHER_TERRITORY,
      })
    }
  }

  /**
   * Levels up the headquarters: deducts cost, increments level (no territory cost).
   */
  levelUpHeadquarters() {
    const {
      resources, buildings,
    } = this.colony
    const hq = buildings.headquarters
    if (hq.constructionRemaining > 0 || hq.upgradeRemaining > 0) return
    const cost = hq.levelUpCost()
    if (!resources.canAfford(cost)) return
    resources.deduct(cost)

    const duration = cost.toSeconds()
    hq.constructionDuration = duration
    hq.constructionRemaining = duration

    this.events.addFuture({
      type: EVENT_TYPE_BUILDING_UPGRADE,
      textKey: 'event.territoryExpanding',
      icon: IMG_OTHER_TERRITORY,
      buildingKey: 'headquarters',
      remainingSeconds: duration,
    })

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
    if (hq.constructionRemaining > 0 || hq.upgradeRemaining > 0) return
    const cost = hq.upgradeCost()
    if (!cost || !resources.canAfford(cost)) return
    resources.deduct(cost)

    const duration = cost.toSeconds()
    hq.upgradeDuration = duration
    hq.upgradeRemaining = duration

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
    if (resources.workers >= stockpile.workers) {
      this.events.addPast({
        type: EVENT_TYPE_POPULATION_LIMIT_REACHED,
        textKey: 'event.populationLimitReached',
        icon: IMG_UNIT_WORKER,
      })
    }
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
   * Returns the localized display name for a building.
   * @param {string} buildingKey
   * @returns {string}
   */
  _buildingName(buildingKey) {
    if (buildingKey === 'headquarters') {
      return t('building.headquarters.' + this.colony.buildings.headquarters.type)
    }
    return t('building.' + buildingKey)
  }

}

export default GameState
