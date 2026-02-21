import {PRODUCTION_RATES, RESEARCH_DEFINITIONS, SEASON_COLD_FOOD_MODIFIER, SEASON_COLD_WOOD_MODIFIER, SEASON_DURATION, SEASON_WARM_FOOD_MODIFIER, SEASON_WARM_WOOD_MODIFIER, WORKER_FOOD_CONSUMPTION, WORKER_RECRUIT_COST, WORKER_WOOD_CONSUMPTION} from '@/js/engine/balancing.js'
import {IMG_OTHER_TERRITORY, IMG_RESOURCE_KNOWLEDGE, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER, SND_BUILDING_CREATED, SND_HEADQUARTERS_UPGRADED, SND_NOTIFICATION_ALERT, SND_NOTIFICATION_SEASON, SND_RESEARCH_COMPLETED, SND_TERRITORY_EXPANDED, SND_WORKER_CREATED, SND_WORKER_FOOD, SND_WORKER_WOOD} from '@/js/engine/assets.js'
import audio from '@/js/engine/audio.js'
import {BOUNDED_RESOURCES, BUILDING_IMAGE_MAP, RESOURCE_LIMIT_EVENT_CONFIG, RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG} from '@/js/engine/constants.js'
import {BUILDING_FARM, BUILDING_HEADQUARTERS, BUILDING_STOREHOUSE, BUILDING_WOODCUTTER, EVENT_TYPE_BUILDING_UPGRADE, EVENT_TYPE_POPULATION_LIMIT_REACHED, EVENT_TYPE_RESEARCH_COMPLETE, EVENT_TYPE_RESOURCE_LIMIT_REACHED, EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION, EVENT_TYPE_SEASON_CHANGED, EVENT_TYPE_TERRITORY_LIMIT_REACHED, SEASON_COLD, SEASON_WARM} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'

/**
 * Central game state container.
 * Wraps Meta, Colony, and Events instances. Holds the core game loop
 * (production, seasons, construction) and all player action methods.
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
          audio.playSound(SND_NOTIFICATION_ALERT)
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
          audio.playSound(SND_NOTIFICATION_ALERT)
        }
      } else if (this._resourcesNegativeProduction.has(resource)) {
        this._resourcesNegativeProduction.delete(resource)
        const config = RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG[resource]
        this.events.dismissPastByTextKey(config.textKey)
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
      audio.playSound(SND_NOTIFICATION_SEASON)
      this.events.dismissPastByType(EVENT_TYPE_SEASON_CHANGED)
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
      if (building.isConstructing) {
        building.constructionRemaining = Math.max(0, building.constructionRemaining - delta)
        if (building.constructionRemaining === 0) {
          building.level += 1
          building.constructionDuration = 0

          if (key === BUILDING_HEADQUARTERS) {
            this.events.convertToPast(key, {
              type: EVENT_TYPE_BUILDING_UPGRADE,
              textKey: 'event.territoryExpanded',
              icon: IMG_OTHER_TERRITORY,
              buildingKey: key,
            })
            audio.playSound(SND_TERRITORY_EXPANDED)
            this.events.dismissPastByType(EVENT_TYPE_TERRITORY_LIMIT_REACHED)
          } else {
            audio.playSound(SND_BUILDING_CREATED)
            this.events.dismissFuture(key)
            if (key === BUILDING_STOREHOUSE) {
              this.events.dismissPastByType(EVENT_TYPE_RESOURCE_LIMIT_REACHED)
            }
          }
        }
      }
    }
    const hq = buildings.headquarters
    if (hq.isUpgrading) {
      hq.upgradeRemaining = Math.max(0, hq.upgradeRemaining - delta)
      if (hq.upgradeRemaining === 0) {
        hq.type = hq.nextType()
        hq.upgradeDuration = 0
        audio.playSound(SND_HEADQUARTERS_UPGRADED)
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
    if (building.isConstructing) return
    const cost = building.levelUpCost()
    if (!resources.canAfford(cost) || resources.territory >= stockpile.territory) return
    resources.deduct(cost)

    const duration = cost.toSeconds()
    building.constructionDuration = duration
    building.constructionRemaining = duration

    const isNewBuilding = building.isUnbuilt
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
      audio.playSound(SND_NOTIFICATION_ALERT)
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
    if (hq.isConstructing || hq.isUpgrading) return
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
      buildingKey: BUILDING_HEADQUARTERS,
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
    if (hq.isConstructing || hq.isUpgrading) return
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
    if (!this._recruit()) return
    this.colony.idleWorkers += 1
    this.update(0)
  }

  /**
   * Assigns one idle worker to a building.
   * @param {string} buildingKey - Key in colony.buildings
   */
  assignWorker(buildingKey) {
    const building = this.colony.buildings[buildingKey]
    if (this.colony.idleWorkers <= 0 || building.workers >= building.maxWorkers) return
    building.workers += 1
    this.colony.idleWorkers -= 1
    this._playAssignSound(buildingKey)
    this.update(0)
  }

  /**
   * Recruits a new worker and assigns it directly to a building.
   * @param {string} buildingKey - Key in colony.buildings
   */
  recruitAndAssignWorker(buildingKey) {
    const building = this.colony.buildings[buildingKey]
    if (building.workers >= building.maxWorkers) return
    if (!this._recruit()) return
    building.workers += 1
    this._playAssignSound(buildingKey)
    this.update(0)
  }

  /**
   * Shared recruit logic: deducts cost, increments worker count, plays sound, fires event.
   * @returns {boolean} true if recruitment succeeded
   */
  _recruit() {
    const {
      resources, stockpile,
    } = this.colony
    if (!resources.canAfford(WORKER_RECRUIT_COST) || resources.workers >= stockpile.workers) return false
    resources.deduct(WORKER_RECRUIT_COST)
    resources.workers += 1
    audio.playSound(SND_WORKER_CREATED)
    if (resources.workers >= stockpile.workers) {
      this.events.addPast({
        type: EVENT_TYPE_POPULATION_LIMIT_REACHED,
        textKey: 'event.populationLimitReached',
        icon: IMG_UNIT_WORKER,
      })
      audio.playSound(SND_NOTIFICATION_ALERT)
    }
    return true
  }

  /**
   * Plays the building-specific worker assignment sound.
   * @param {string} buildingKey
   */
  _playAssignSound(buildingKey) {
    if (buildingKey === BUILDING_FARM) audio.playSound(SND_WORKER_FOOD)
    else if (buildingKey === BUILDING_WOODCUTTER) audio.playSound(SND_WORKER_WOOD)
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
   * Starts a research: validates preconditions, deducts cost, begins timer, creates future event.
   * @param {string} key - Research key from enums
   */
  startResearch(key) {
    const {
      resources, buildings, researches,
    } = this.colony
    if (researches.isActive(key) || researches.isCompleted(key)) return
    const def = RESEARCH_DEFINITIONS[key]
    if (!def) return
    if (buildings.academy.level < def.academyLevel) return
    if (!resources.canAfford(def.cost)) return

    resources.deduct(def.cost)
    researches.start(key, def.duration)

    this.events.addFuture({
      type: EVENT_TYPE_RESEARCH_COMPLETE,
      textKey: 'event.researchInProgress',
      icon: IMG_RESOURCE_KNOWLEDGE,
      params: [t('research.' + key).toLowerCase()],
      researchKey: key,
      remainingSeconds: def.duration,
    })

    this.update(0)
  }

  /**
   * Advances research timers and handles completion.
   * @param {number} delta - Seconds since last tick
   */
  advanceResearch(delta) {
    const {
      researches,
    } = this.colony
    const completed = []
    for (const [
      key,
      entry,
    ] of researches.active) {
      entry.remainingSeconds = Math.max(0, entry.remainingSeconds - delta)
      if (entry.remainingSeconds === 0) {
        completed.push(key)
      }
    }
    for (const key of completed) {
      researches.complete(key)
      this.events.dismissFutureByResearchKey(key)
      audio.playSound(SND_RESEARCH_COMPLETED)
    }
  }

  /**
   * Returns the localized display name for a building.
   * @param {string} buildingKey
   * @returns {string}
   */
  _buildingName(buildingKey) {
    if (buildingKey === BUILDING_HEADQUARTERS) {
      return t('building.headquarters.' + this.colony.buildings.headquarters.type)
    }
    return t('building.' + buildingKey)
  }

}

export default GameState
