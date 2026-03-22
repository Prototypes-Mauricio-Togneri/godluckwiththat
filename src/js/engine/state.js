// Central game state container — mutation handler, game loop, and player actions.

import {MONUMENT_FAITH_PER_LEVEL, PRODUCTION_RATES, RESEARCH_COSTS, SEASON_COLD_FOOD_MODIFIER, SEASON_COLD_WOOD_MODIFIER, SEASON_WARM_FOOD_MODIFIER, SEASON_WARM_WOOD_MODIFIER, SHORTAGE_MAX_PENALTY, WORKER_FOOD_CONSUMPTION, WORKER_RECRUIT_COST, WORKER_WOOD_CONSUMPTION} from '@/js/engine/balancing.js'
import {IMG_OTHER_TERRITORY, IMG_RESOURCE_FAITH, IMG_RESOURCE_KNOWLEDGE, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER, SND_BUILDING_CREATED, SND_HEADQUARTERS_UPGRADED, SND_NOTIFICATION_ALERT, SND_NOTIFICATION_SEASON, SND_RESEARCH_COMPLETED, SND_TERRITORY_EXPANDED, SND_WORKER_ACADEMY, SND_WORKER_CREATED, SND_WORKER_FARM, SND_WORKER_MINE, SND_WORKER_TEMPLE, SND_WORKER_WOODCUTTER} from '@/js/engine/assets.js'
import audio from '@/js/engine/audio.js'
import storage from '@/js/engine/storage.js'
import {BOUNDED_RESOURCES, BUILDING_CLASS_MAP, BUILDING_IMAGE_MAP, DOWNGRADABLE_BUILDINGS, IMG_BUILDING_HEADQUARTERS_MAP, RESEARCH_TREE, RESOURCE_LIMIT_EVENT_CONFIG, RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG, TUTORIAL_STEPS} from '@/js/engine/constants.js'
import Colony from '@/js/models/colony.js'
import Consumption from '@/js/models/consumption.js'
import Meta from '@/js/models/meta.js'
import Production from '@/js/models/production.js'
import {BLESSING_BLESSED_MARKETS, BLESSING_CELESTIAL_PROSPERITY, BLESSING_FAVORABLE_WEATHER, BLESSING_FERTILE_SOIL, BLESSING_FOREST_BLOOM, BLESSING_GIFT_FROM_THE_HEAVENS, BLESSING_HOLY_EXPANSION, BLESSING_RAPID_CONSTRUCTION, BLESSING_RICH_MINES, BLESSING_WISDOM_OF_THE_GODS, BONUS_CONSTRUCTION_TIME, BONUS_EXPANSION_COST, BONUS_FAITH_PRODUCTION, BONUS_FOOD_CONSUMPTION, BONUS_FOOD_PRODUCTION, BONUS_HABITATION, BONUS_KNOWLEDGE_PRODUCTION, BONUS_MINING_PRODUCTION, BONUS_STORAGE_CAPACITY, BONUS_WOOD_CONSUMPTION, BONUS_WOOD_PRODUCTION, BONUS_WORKER_PRODUCTIVITY, BUILDING_ACADEMY, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_STOREHOUSE, BUILDING_TEMPLE, BUILDING_WOODCUTTER, CHALLENGE_MODAL_FAILURE, CHALLENGE_MODAL_REWARD, CHALLENGE_MODAL_WIN, EVENT_TYPE_BUILDING_UPGRADE, EVENT_TYPE_CHALLENGE_STARTED, EVENT_TYPE_POPULATION_LIMIT_REACHED, EVENT_TYPE_RESEARCH_COMPLETE, EVENT_TYPE_RESOURCE_LIMIT_REACHED, EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION, EVENT_TYPE_SEASON_CHANGED, EVENT_TYPE_IDLE_WORKERS, EVENT_TYPE_TERRITORY_LIMIT_REACHED, RESOURCE_FOOD, RESOURCE_WOOD, TUTORIAL_MODAL_SEASON_CHANGED, TUTORIAL_MODAL_NEGATIVE_PRODUCTION, TUTORIAL_MODAL_HQ_UPGRADE, TUTORIAL_MODAL_CHALLENGE_STARTED} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'

/**
 * Central game state container.
 * Wraps Meta and Colony instances. Holds the core game loop
 * (production, seasons, construction) and all player action methods.
 *
 * @property {Meta} meta - Game metadata (version, timestamps, challenges)
 * @property {Colony} colony - Active colony instance
 */
class State {
  /**
   * @param {Meta} meta - Meta instance
   * @param {Colony} colony - Colony instance
   */
  constructor(meta, colony) {
    this.meta = meta // Game metadata (version, timestamps, challenges)
    this.colony = colony // Active colony instance

    // Track which bounded resources are currently at their storage cap
    // (initialized empty — storage cap is 0 before the first update tick)
    this._resourcesAtCap = new Set()

    // Track which bounded resources currently have negative net production
    // (initialized empty — production is 0 before the first update tick)
    this._resourcesNegativeProduction = new Set()

    // Track whether idle workers were present on the previous tick so the
    // idle-workers event fires only on the transition (not every tick)
    this._hadIdleWorkers = false

    // Seasonal multipliers for food production and wood consumption,
    // recalculated each tick in update(). Initialized to neutral defaults.
    this.seasonMultipliers = {
      food: 1,
      wood: 1,
    }

    // Per-second gross production rates (ephemeral, recalculated each tick)
    this.production = new Production({})

    // Per-second worker upkeep (ephemeral, recalculated each tick)
    this.consumption = new Consumption({})

    // Productivity ratio 0–1, recalculated each tick in update().
    // Reduced by food/wood shortage.
    this.productivity = 1

    // Per-resource production multipliers (research + blessings + season),
    // recalculated each tick in update(). Initialized to neutral defaults.
    this.productionMultipliers = {
      food: 1,
      wood: 1,
      stone: 1,
      copper: 1,
      iron: 1,
      gold: 1,
      faith: 1,
      knowledge: 1,
    }

    // Per-resource consumption multipliers (research bonuses + season),
    // recalculated each tick in update(). Initialized to neutral defaults.
    this.consumptionMultipliers = {
      food: 1,
      wood: 1,
    }

    // Track which buildings are currently constructing so advanceConstruction()
    // only iterates the active subset instead of all 20 buildings every frame
    this._constructingKeys = new Set()
    for (const [
      key,
      building,
    ] of Object.entries(colony.buildings)) {
      if (building.isConstructing) {
        this._constructingKeys.add(key)
      }
    }

    // Track whether HQ type upgrade is in progress
    this._hqUpgrading = colony.buildings.headquarters.isUpgrading

    // Whether the game is paused (e.g. by a tutorial modal or challenge modal)
    this.paused = false

    // Which challenge modal is showing: null, CHALLENGE_MODAL_REWARD, CHALLENGE_MODAL_FAILURE, or CHALLENGE_MODAL_WIN
    this.challengeModal = null
  }

  /**
   * Advances the colony simulation by the given time delta.
   * Recomputes production rates from assigned workers and passive building levels,
   * applies resource gains scaled by delta, and caps at storage limits.
   *
   * @param {number} delta - Seconds elapsed since last tick
   */
  update(delta) {
    const {
      resources, buildings,
    } = this.colony
    const {
      production, consumption,
    } = this

    // Refresh derived state before production: territory counts both completed
    // building levels and buildings under construction (each reserves one slot).
    // Research bonuses are aggregated from all completed researches in the tech
    // tree — these affect production multipliers, consumption reduction, and
    // population caps, so they must be resolved before rate calculations.
    resources.territory = buildings.totalLevels + buildings.pendingTerritory
    const bonuses = buildings.academy.completedBonuses(RESEARCH_TREE)
    const habitationBonus = bonuses[BONUS_HABITATION] ?? 0
    buildings.house.workersCap = buildings.house.populationCap(habitationBonus)
    const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
    const storageCap = buildings.storehouse.storageCap(storageBonus)

    // BLESSED_MARKETS: override trade fee to 0% while active
    const blessings = this.meta.challenges.activeBlessings
    buildings.market.blessedMarkets = blessings.some(blessing => blessing.type === BLESSING_BLESSED_MARKETS)

    // Seasonal multipliers for food production and wood consumption
    this.seasonMultipliers = this._computeSeasonMultipliers(blessings)

    // Production rates from buildings, blessings, and season (before
    // productivity penalty — used for deficit calculation below)
    const {
      rates: productionRates, multipliers: productionMultipliers,
    } = this._computeProductionRates(bonuses, blessings, this.seasonMultipliers)
    this.productionMultipliers = productionMultipliers

    // Worker upkeep: every worker (idle and assigned) consumes food and wood
    // each second. Research bonuses reduce the base consumption rates (−5%/tier).
    // Wood upkeep is additionally scaled by seasonal modifier (cold = more heating).
    // Consumption rates are per-second and also used by the UI (header tooltips)
    const {
      rates: consumptionRates, multipliers: consumptionMultipliers,
    } = this._computeConsumptionRates(bonuses, this.seasonMultipliers, resources.workers)
    this.consumptionMultipliers = consumptionMultipliers

    // Productivity ratio based on current production vs consumption. Uses raw
    // production rates (not penalized) so reassigning workers takes effect
    // immediately instead of being locked by the previous tick's penalty
    const productivity = this._computeGeneralProductivity(resources.workers, productionRates, consumptionRates)
    this.productivity = productivity

    // Apply productivity penalty to production rates
    production.food = productionRates.food * productivity
    production.wood = productionRates.wood * productivity
    production.stone = productionRates.stone * productivity
    production.copper = productionRates.copper * productivity
    production.iron = productionRates.iron * productivity
    production.gold = productionRates.gold * productivity
    production.faith = productionRates.faith * productivity
    production.knowledge = productionRates.knowledge * productivity

    // Apply consumption rates from worker upkeep
    consumption.food = consumptionRates.food
    consumption.wood = consumptionRates.wood

    // Apply production gains to resources. Rates are per-second, so
    // multiplying by delta converts to the actual elapsed interval
    resources.food += production.food * delta
    resources.wood += production.wood * delta
    resources.stone += production.stone * delta
    resources.copper += production.copper * delta
    resources.iron += production.iron * delta
    resources.gold += production.gold * delta
    resources.faith += production.faith * delta
    resources.knowledge += production.knowledge * delta

    // Deduct upkeep from resources. Guarded by delta > 0 because update(0) is
    // used as a "recalculate-only" call by action methods (e.g. after assigning
    // a worker) — no resources should flow
    if (delta > 0) {
      resources.food = Math.max(0, resources.food - consumption.food * delta)
      resources.wood = Math.max(0, resources.wood - consumption.wood * delta)
    }

    // Cap all bounded resources at the storehouse storage limit.
    for (const resource of BOUNDED_RESOURCES) {
      resources[resource] = Math.min(resources[resource], storageCap)
    }

    // Edge-detection for resources hitting their storage cap. The _resourcesAtCap
    // Set tracks which resources were at cap on the previous tick, so events fire
    // only on the transition (not repeatedly every tick). When a resource drops
    // back below cap, the warning event is auto-dismissed
    for (const resource of BOUNDED_RESOURCES) {
      if (resources[resource] >= storageCap) {
        if (!this._resourcesAtCap.has(resource)) {
          this._resourcesAtCap.add(resource)
          const config = RESOURCE_LIMIT_EVENT_CONFIG[resource]
          this.colony.events.addPast({
            type: EVENT_TYPE_RESOURCE_LIMIT_REACHED,
            textKey: config.textKey,
            icon: config.icon,
          })
          audio.playSound(SND_NOTIFICATION_ALERT)
        }
      } else if (this._resourcesAtCap.has(resource)) {
        this._resourcesAtCap.delete(resource)
        const config = RESOURCE_LIMIT_EVENT_CONFIG[resource]
        this.colony.events.dismissPastByTextKey(config.textKey)
      }
    }

    // Floor all resources at zero — consumption or other deductions above
    // may have pushed values negative
    resources.food = Math.max(0, resources.food)
    resources.wood = Math.max(0, resources.wood)
    resources.stone = Math.max(0, resources.stone)
    resources.copper = Math.max(0, resources.copper)
    resources.iron = Math.max(0, resources.iron)
    resources.gold = Math.max(0, resources.gold)
    resources.faith = Math.max(0, resources.faith)
    resources.knowledge = Math.max(0, resources.knowledge)

    // Edge-detection for negative net production (same pattern as storage cap
    // events above). netProduction() = production − consumption, so this fires
    // when upkeep exceeds output. Warning auto-dismisses when production recovers
    for (const resource of BOUNDED_RESOURCES) {
      if (this.netProduction(resource) < 0) {
        if (!this._resourcesNegativeProduction.has(resource)) {
          this._resourcesNegativeProduction.add(resource)
          const config = RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG[resource]
          this.colony.events.addPast({
            type: EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION,
            textKey: config.textKey,
            icon: config.icon,
          })
          audio.playSound(SND_NOTIFICATION_ALERT)
          if (resource === RESOURCE_FOOD || resource === RESOURCE_WOOD) {
            this._triggerTutorialModal(TUTORIAL_MODAL_NEGATIVE_PRODUCTION)
          }
        }
      } else if (this._resourcesNegativeProduction.has(resource)) {
        this._resourcesNegativeProduction.delete(resource)
        const config = RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG[resource]
        this.colony.events.dismissPastByTextKey(config.textKey)
      }
    }

    // Edge-detection for idle workers (same pattern as above).
    // Event appears when idle count rises above 0, auto-dismisses when it drops to 0
    const hasIdle = this.colony.idleWorkers > 0
    if (hasIdle && !this._hadIdleWorkers) {
      this._hadIdleWorkers = true
      this.colony.events.addPast({
        type: EVENT_TYPE_IDLE_WORKERS,
        textKey: 'event.idleWorkers',
        icon: IMG_UNIT_WORKER,
      })
      audio.playSound(SND_NOTIFICATION_ALERT)
    } else if (!hasIdle && this._hadIdleWorkers) {
      this._hadIdleWorkers = false
      this.colony.events.dismissPastByType(EVENT_TYPE_IDLE_WORKERS)
    }
  }

  /**
   * Returns the net production rate for a resource (gross minus consumption).
   * @param {string} resource - Resource key
   * @returns {number} Net production per second
   */
  netProduction(resource) {
    return this.production[resource] - (this.consumption[resource] ?? 0)
  }

  /**
   * Computes the general productivity ratio based on resource shortages.
   * Starts at 1 (100%) and is reduced when food or wood has negative net
   * production. The reduction is proportional to the deficit ratio (uncovered
   * consumption / total consumption), scaled by SHORTAGE_MAX_PENALTY.
   * Only the largest deficit applies. Uses current-tick raw production
   * (before productivity penalty) and current-tick consumption to avoid a
   * feedback loop where penalized production locks productivity at zero.
   * The _resourcesNegativeProduction guard introduces a one-tick delay:
   * the penalty only activates after a tick where negative net production
   * was detected.
   *
   * Examples (SHORTAGE_MAX_PENALTY = 1):
   *
   * | Scenario               | Workers | Food (prod/cons) | Wood (prod/cons) | Result |
   * |------------------------|---------|------------------|------------------|--------|
   * | No workers             | 0       | —                | —                | 0      |
   * | No shortage            | 5       | 10 / 8           | 6 / 4            | 1      |
   * | 50% food deficit       | 5       | 5 / 10           | 6 / 4            | 0.5    |
   * | Full food deficit      | 5       | 0 / 10           | 6 / 4            | 0      |
   * | 50% wood deficit       | 5       | 10 / 8           | 4 / 8            | 0.5    |
   * | Both, food worse       | 5       | 3 / 10           | 5 / 8            | 0.3    |
   *
   * @param {number} workers - Current worker count
   * @param {{ food: number, wood: number }} productionRates - Raw production rates (before productivity penalty)
   * @param {{ food: number, wood: number }} consumptionRates - Current-tick consumption rates
   * @returns {number} Productivity ratio between 0 and 1
   */
  _computeGeneralProductivity(workers, productionRates, consumptionRates) {
    let productivity = 1
    if (workers === 0) {
      productivity = 0
    }
    if (this._resourcesNegativeProduction.has(RESOURCE_FOOD) && consumptionRates.food > 0) {
      const deficit = Math.max(0, consumptionRates.food - productionRates.food)
      productivity = Math.min(productivity, 1 - (deficit / consumptionRates.food) * SHORTAGE_MAX_PENALTY)
    }
    if (this._resourcesNegativeProduction.has(RESOURCE_WOOD) && consumptionRates.wood > 0) {
      const deficit = Math.max(0, consumptionRates.wood - productionRates.wood)
      productivity = Math.min(productivity, 1 - (deficit / consumptionRates.wood) * SHORTAGE_MAX_PENALTY)
    }
    return productivity
  }

  /**
   * Computes seasonal multipliers for food production and wood consumption.
   * FAVORABLE_WEATHER blessing boosts food production and reduces wood consumption.
   *
   * Example output (warm/cold factor = 0.1):
   *   Scenario             | Food production | Wood consumption
   *   Warm, no blessing    |             1.2 |              0.8
   *   Warm, with blessing  |             1.3 |              0.7
   *   Cold, no blessing    |             0.8 |              1.2
   *   Cold, with blessing  |             0.9 |              1.1
   *
   * @param {Array} blessings - Active blessings from meta.challenges
   * @returns {{ food: number, wood: number }}
   */
  _computeSeasonMultipliers(blessings) {
    let foodModifier = this.colony.season.isWarm ? SEASON_WARM_FOOD_MODIFIER : SEASON_COLD_FOOD_MODIFIER
    let woodModifier = this.colony.season.isWarm ? SEASON_WARM_WOOD_MODIFIER : SEASON_COLD_WOOD_MODIFIER
    const favorableWeather = blessings.find(blessing => blessing.type === BLESSING_FAVORABLE_WEATHER)
    if (favorableWeather) {
      const seasonBonus = this.colony.season.isWarm ? favorableWeather.warm : favorableWeather.cold
      foodModifier += seasonBonus
      woodModifier -= seasonBonus
    }
    return {
      food: 1 + foodModifier,
      wood: 1 + woodModifier,
    }
  }

  /**
   * Computes per-second consumption rates for food and wood based on worker
   * count, research bonuses, and seasonal modifiers. Returns final rates
   * after all reductions are applied.
   *
   * Food formula:  workerCount × 0.1 × max(0, 1 − foodBonus)
   * Wood formula:  workerCount × 0.1 × max(0, 1 − woodBonus − (1 − seasonMultipliers.wood))
   *
   * Example outputs (base rate = 0.1/worker/sec, each research tier = 0.05):
   *
   *  Workers | Research | Season | Food/s | Wood/s
   *  --------|----------|--------|--------|-------
   *        0 |   0 tier |   warm |   0.00 |   0.00
   *       10 |   0 tier |   warm |   1.00 |   0.80
   *       10 |   0 tier |   cold |   1.00 |   1.20
   *       10 |  2 tiers |   warm |   0.90 |   0.70
   *       10 |  4 tiers |   warm |   0.80 |   0.60
   *       10 |  4 tiers |   cold |   0.80 |   1.00
   *       20 |   0 tier |   cold |   2.00 |   2.40
   *
   * Warm season reduces wood consumption by 20% (seasonMultipliers.wood = 0.8).
   * Cold season increases wood consumption by 20% (seasonMultipliers.wood = 1.2).
   * Food consumption is unaffected by season.
   *
   * @param {Object} bonuses - Research bonus map from academy.completedBonuses()
   * @param {{ food: number, wood: number }} seasonMultipliers - Seasonal multipliers from _computeSeasonMultipliers
   * @param {number} workerCount - Total worker count (idle + assigned)
   * @returns {{ food: number, wood: number }}
   */
  _computeConsumptionRates(bonuses, seasonMultipliers, workerCount) {
    const foodMultiplier = Math.max(0, 1 - (bonuses[BONUS_FOOD_CONSUMPTION] ?? 0))
    // Stack bonus and season reductions additively
    const woodMultiplier = Math.max(0, 1
      - (bonuses[BONUS_WOOD_CONSUMPTION] ?? 0)
      - (1 - seasonMultipliers.wood))
    const multipliers = {
      food: foodMultiplier,
      wood: woodMultiplier,
    }
    if (workerCount <= 0) {
      return {
        rates: {
          food: 0,
          wood: 0,
        },
        multipliers: multipliers,
      }
    }
    return {
      rates: {
        food: workerCount * WORKER_FOOD_CONSUMPTION * foodMultiplier,
        wood: workerCount * WORKER_WOOD_CONSUMPTION * woodMultiplier,
      },
      multipliers: multipliers,
    }
  }

  /**
   * Computes per-second production rates from building state, research bonuses,
   * active blessings, and seasonal modifiers. Returns raw rates before the
   * productivity penalty (applied externally in update()).
   *
   * Two stages:
   *   1. Base rates: workers × config.rate (or level × config.rate for passive buildings)
   *   2. Per-resource multipliers: research + worker productivity (bounded only) + blessings + season
   *
   * @param {Object} bonuses - Research bonus map from academy.completedBonuses()
   * @param {Array} blessings - Active blessings from meta.challenges
   * @param {{ food: number, wood: number }} seasonMultipliers - Seasonal multipliers from _computeSeasonMultipliers
   * @returns {{ food: number, wood: number, stone: number, copper: number, iron: number, gold: number, faith: number, knowledge: number }}
   */
  _computeProductionRates(bonuses, blessings, seasonMultipliers) {
    const {
      buildings,
    } = this.colony
    // Stage 1: Base production rates (workers/level × config.rate, no multipliers)
    const baseRates = {
      food: 0,
      wood: 0,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      faith: 0,
      knowledge: 0,
    }

    for (const [
      buildingKey,
      config,
    ] of Object.entries(PRODUCTION_RATES)) {
      const building = buildings[buildingKey]
      if (building.level > 0) {
        if (config.passive) {
          baseRates[config.resource] += building.level * config.rate
        } else if (building.workers > 0) {
          baseRates[config.resource] += building.workers * config.rate
        }
      }
    }

    // Stage 2: Per-resource multipliers (additive accumulation)
    const workerProductivityBonus = bonuses[BONUS_WORKER_PRODUCTIVITY] ?? 0
    const multipliers = {
      food: 1 + (bonuses[BONUS_FOOD_PRODUCTION] ?? 0) + workerProductivityBonus,
      wood: 1 + (bonuses[BONUS_WOOD_PRODUCTION] ?? 0) + workerProductivityBonus,
      stone: 1 + (bonuses[BONUS_MINING_PRODUCTION] ?? 0) + workerProductivityBonus,
      copper: 1 + (bonuses[BONUS_MINING_PRODUCTION] ?? 0) + workerProductivityBonus,
      iron: 1 + (bonuses[BONUS_MINING_PRODUCTION] ?? 0) + workerProductivityBonus,
      gold: 1 + (bonuses[BONUS_MINING_PRODUCTION] ?? 0) + workerProductivityBonus,
      knowledge: 1 + (bonuses[BONUS_KNOWLEDGE_PRODUCTION] ?? 0),
      faith: 1 + (bonuses[BONUS_FAITH_PRODUCTION] ?? 0),
    }

    // Blessing productivity bonuses (additive)
    for (const blessing of blessings) {
      if (blessing.type === BLESSING_FERTILE_SOIL && blessing.productivity) {
        multipliers.food += blessing.productivity
      } else if (blessing.type === BLESSING_FOREST_BLOOM && blessing.productivity) {
        multipliers.wood += blessing.productivity
      } else if (blessing.type === BLESSING_RICH_MINES && blessing.productivity) {
        multipliers.stone += blessing.productivity
        multipliers.copper += blessing.productivity
        multipliers.iron += blessing.productivity
        multipliers.gold += blessing.productivity
      } else if (blessing.type === BLESSING_WISDOM_OF_THE_GODS && blessing.productivity) {
        multipliers.knowledge += blessing.productivity
      } else if (blessing.type === BLESSING_CELESTIAL_PROSPERITY && blessing.productivity) {
        multipliers.food += blessing.productivity
        multipliers.wood += blessing.productivity
        multipliers.stone += blessing.productivity
        multipliers.copper += blessing.productivity
        multipliers.iron += blessing.productivity
        multipliers.gold += blessing.productivity
        multipliers.faith += blessing.productivity
        multipliers.knowledge += blessing.productivity
      }
    }

    // Season modifier on food production (additive)
    multipliers.food += seasonMultipliers.food - 1

    // Combine base rates with multipliers
    const rates = {}
    for (const resource of Object.keys(baseRates)) {
      rates[resource] = baseRates[resource] * multipliers[resource]
    }

    return {
      rates: rates,
      multipliers: multipliers,
    }
  }

  /**
   * Advances the season elapsed timer and flips season when duration is reached.
   * Driven by requestAnimationFrame for smooth visual progress.
   * @param {number} delta - Seconds since last season tick
   */
  advanceSeason(delta) {
    if (this.colony.season.advance(delta)) {
      const isWarm = this.colony.season.isWarm
      if (isWarm) {
        this.colony.year++
      }
      audio.playSound(SND_NOTIFICATION_SEASON)
      this.colony.events.dismissPastByType(EVENT_TYPE_SEASON_CHANGED)
      this.colony.events.addPast({
        type: EVENT_TYPE_SEASON_CHANGED,
        textKey: isWarm ? 'event.warmSeason' : 'event.coldSeason',
        icon: isWarm ? IMG_SEASON_WARM : IMG_SEASON_COLD,
      })
      this._triggerTutorialModal(TUTORIAL_MODAL_SEASON_CHANGED)
    }
  }

  /**
   * Advances construction timers for all buildings and the HQ type upgrade.
   * When a timer reaches zero, applies the upgrade (level increment or type advance).
   * Driven by requestAnimationFrame for smooth visual progress.
   * @param {number} delta - Seconds since last progress tick
   */
  advanceConstruction(delta) {
    if (this._constructingKeys.size === 0 && !this._hqUpgrading) {
      return
    }
    const {
      buildings,
    } = this.colony
    const completed = []
    for (const key of this._constructingKeys) {
      const building = buildings[key]
      if (building.advance(delta)) {
        completed.push(key)
        if (key === BUILDING_HEADQUARTERS) {
          this.colony.events.convertToPast(key, {
            type: EVENT_TYPE_BUILDING_UPGRADE,
            textKey: 'event.territoryExpanded',
            icon: IMG_OTHER_TERRITORY,
            buildingKey: key,
          })
          audio.playSound(SND_TERRITORY_EXPANDED)
          this.colony.events.dismissPastByType(EVENT_TYPE_TERRITORY_LIMIT_REACHED)
        } else {
          audio.playSound(SND_BUILDING_CREATED)
          this.colony.events.dismissFutureByBuildingKey(key)
          if (key === BUILDING_STOREHOUSE) {
            this.colony.events.dismissPastByType(EVENT_TYPE_RESOURCE_LIMIT_REACHED)
            this._resourcesAtCap.clear()
          } else if (key === BUILDING_HOUSE) {
            this.colony.events.dismissPastByType(EVENT_TYPE_POPULATION_LIMIT_REACHED)
          } else if (key === BUILDING_MONUMENT) {
            this.colony.resources.faith += MONUMENT_FAITH_PER_LEVEL * building.level
          }
        }
      }
    }
    for (const key of completed) {
      this._constructingKeys.delete(key)
    }
    if (this._hqUpgrading) {
      if (buildings.headquarters.advanceUpgrade(delta)) {
        this._hqUpgrading = false
        this.colony.events.dismissFutureByBuildingKey(BUILDING_HEADQUARTERS)
        audio.playSound(SND_HEADQUARTERS_UPGRADED)
        this._triggerTutorialModal(TUTORIAL_MODAL_HQ_UPGRADE)
      }
    }
  }

  /**
   * Advances research timers and handles completion.
   * Driven by requestAnimationFrame for smooth visual progress.
   * @param {number} delta - Seconds since last tick
   */
  advanceResearch(delta) {
    const {
      academy,
    } = this.colony.buildings
    if (academy.active.size === 0) {
      return
    }
    const completed = []
    for (const [
      key,
      research,
    ] of academy.active) {
      if (research.advance(delta)) {
        completed.push(key)
      }
    }
    for (const key of completed) {
      academy.complete(key)
      this.colony.events.dismissFutureByResearchKey(key)
      audio.playSound(SND_RESEARCH_COMPLETED)
    }
    if (completed.length > 0) {
      this.update(0)
    }
  }

  /**
   * Advances event countdown timers by the elapsed delta.
   * Driven by requestAnimationFrame for smooth visual progress.
   * @param {number} delta - Seconds elapsed since last tick
   */
  advanceEvents(delta) {
    if (this.colony.events.future.length === 0) {
      return
    }
    this.colony.events.advance(delta)
  }

  /**
   * Advances challenge timers. Activates pending challenges, transitions delay→started,
   * and resolves timeouts. Driven by requestAnimationFrame for smooth progress.
   * @param {number} delta - Seconds since last tick
   */
  advanceChallenges(delta) {
    if (this.challengeModal) {
      return
    }
    const challenges = this.meta.challenges

    // Decrement ongoing blessing/punishment timeouts (ticks even after all challenges completed)
    this._advanceEffectTimeouts(challenges.activeBlessings, delta)
    this._advanceEffectTimeouts(challenges.activePunishments, delta)

    if (challenges.allCompleted) {
      return
    }

    // Activate first pending if no active challenge
    if (!challenges.active && challenges.pending.length > 0) {
      challenges.activate()
    }
    if (!challenges.active) {
      return
    }

    challenges.advance(delta)

    // Delay expired → transition to started, fire future event
    if (challenges.active.isDelayElapsed) {
      challenges.start()
      this.colony.events.addFuture({
        type: EVENT_TYPE_CHALLENGE_STARTED,
        textKey: 'event.challengeStarted',
        icon: IMG_RESOURCE_FAITH,
        params: [
          challenges.active.index,
          challenges.totalCount,
          t('challenge.name.' + challenges.active.index),
        ],
        action: 'openChallengeModal',
        remainingSeconds: challenges.active.timeout,
      })
      audio.playSound(SND_NOTIFICATION_ALERT)
      this._triggerTutorialModal(TUTORIAL_MODAL_CHALLENGE_STARTED)
    }

    // Timeout expired → resolve
    if (challenges.active.isTimeoutElapsed) {
      this._resolveChallengeTimeout()
    }
  }

  /**
   * Checks whether challenge requirements are met and branches to complete or fail.
   */
  _resolveChallengeTimeout() {
    if (this.areChallengeRequirementsMet()) {
      this._completeChallenge()
    } else {
      this._failChallenge()
    }
  }

  /**
   * Checks whether all requirements for the active challenge are currently met.
   * @returns {boolean} True if all requirements are satisfied
   */
  areChallengeRequirementsMet() {
    const challenge = this.meta.challenges.active
    if (!challenge) {
      return false
    }
    const {
      requirements,
    } = challenge
    const {
      resources, buildings,
    } = this.colony

    if (requirements.faith !== null && resources.faith < requirements.faith) {
      return false
    }
    if (requirements.altar !== null && buildings.altar.level < requirements.altar) {
      return false
    }
    if (requirements.temple !== null && buildings.temple.level < requirements.temple) {
      return false
    }
    if (requirements.monument !== null && buildings.monument.level < requirements.monument) {
      return false
    }
    if (requirements.resources !== null) {
      for (const [
        resource,
        amount,
      ] of Object.entries(requirements.resources)) {
        if (resources[resource] < amount) {
          return false
        }
      }
    }
    if (requirements.workers !== null && resources.workers < requirements.workers) {
      return false
    }
    return true
  }

  /**
   * Deducts challenge requirements from the colony (faith, resources, workers).
   */
  _deductRequirements() {
    const challenge = this.meta.challenges.active
    if (!challenge) {
      return
    }
    const {
      requirements,
    } = challenge
    const {
      resources,
    } = this.colony

    if (requirements.faith !== null) {
      resources.faith = Math.max(0, resources.faith - requirements.faith)
    }
    if (requirements.resources !== null) {
      for (const [
        resource,
        amount,
      ] of Object.entries(requirements.resources)) {
        resources[resource] = Math.max(0, resources[resource] - amount)
      }
    }
    if (requirements.workers !== null) {
      this._sacrificeWorkers(requirements.workers)
    }
  }

  /**
   * Removes workers from the colony: first from idle pool, then randomly
   * unassigned from producer buildings that have workers.
   * @param {number} count - Number of workers to sacrifice
   */
  _sacrificeWorkers(count) {
    const {
      resources, buildings,
    } = this.colony
    let remaining = count

    // First from idle pool
    const idleToRemove = Math.min(remaining, this.colony.idleWorkers)
    resources.workers -= idleToRemove
    remaining -= idleToRemove

    // Then randomly from producer buildings with assigned workers
    while (remaining > 0) {
      const producerKeys = []
      for (const [
        key,
        building,
      ] of Object.entries(buildings)) {
        if ('workers' in building && building.workers > 0) {
          producerKeys.push(key)
        }
      }
      if (producerKeys.length === 0) {
        break
      }
      const randomKey = producerKeys[Math.floor(Math.random() * producerKeys.length)]
      buildings[randomKey].workers -= 1
      resources.workers -= 1
      remaining -= 1
    }
  }

  /**
   * Handles a successful challenge: deducts requirements, pauses game,
   * and signals the UI to show the reward modal.
   */
  _completeChallenge() {
    this._deductRequirements()
    this.paused = true
    this.challengeModal = CHALLENGE_MODAL_REWARD
  }

  /**
   * Handles a failed challenge: pauses game and signals the UI
   * to show the failure modal.
   */
  _failChallenge() {
    this.paused = true
    this.challengeModal = CHALLENGE_MODAL_FAILURE
  }

  /**
   * Player action: selects a blessing reward after completing a challenge.
   * Moves the challenge to completed, dismisses the event, and activates
   * the next challenge or triggers the win state.
   * @param {number} blessingIndex - Index into the active challenge's blessings array
   */
  selectBlessing(blessingIndex) {
    const challenge = this.meta.challenges.active
    if (!challenge || this.challengeModal !== CHALLENGE_MODAL_REWARD) {
      return
    }

    const blessing = challenge.blessings[blessingIndex]

    this.meta.challenges.complete(blessing)
    this._applyBlessing(blessing)

    this.colony.events.dismissFutureByType(EVENT_TYPE_CHALLENGE_STARTED)

    if (this.meta.challenges.allCompleted) {
      this.challengeModal = CHALLENGE_MODAL_WIN
    } else {
      this.challengeModal = null
      this.paused = false
    }

    this.update(0)
  }

  /**
   * Player action: acknowledges a challenge failure punishment.
   * Resets the challenge timers and unpauses the game.
   */
  acknowledgePunishment() {
    if (!this.meta.challenges.active || this.challengeModal !== CHALLENGE_MODAL_FAILURE) {
      return
    }

    const challenge = this.meta.challenges.active

    this.colony.events.dismissFutureByType(EVENT_TYPE_CHALLENGE_STARTED)

    this.meta.challenges.fail(challenge.punishment)
    this.challengeModal = null
    this.paused = false
    this.update(0)
  }

  /**
   * Decrements timeout on each effect in the array by delta. Removes entries whose timeout reaches 0.
   * Entries with null timeout (instant effects) are skipped.
   * @param {Array} effects - Array of Blessing or Punishment instances
   * @param {number} delta - Seconds since last tick
   */
  _advanceEffectTimeouts(effects, delta) {
    for (let i = effects.length - 1; i >= 0; i--) {
      if (effects[i].timeout === null) {
        continue
      }
      effects[i].timeout = Math.max(0, effects[i].timeout - delta)
      if (effects[i].timeout === 0) {
        effects.splice(i, 1)
      }
    }
  }

  /**
   * Applies instant blessing effects after the player selects a reward.
   * @param {Blessing} blessing - The chosen blessing
   */
  _applyBlessing(blessing) {
    const {
      resources, buildings,
    } = this.colony
    if (blessing.type === BLESSING_GIFT_FROM_THE_HEAVENS && blessing.resources) {
      const bonuses = buildings.academy.completedBonuses(RESEARCH_TREE)
      const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
      const storageCap = buildings.storehouse.storageCap(storageBonus)
      for (const [
        resource,
        amount,
      ] of Object.entries(blessing.resources)) {
        resources[resource] = Math.min(resources[resource] + amount, storageCap)
      }
    } else if (blessing.type === BLESSING_HOLY_EXPANSION && blessing.territory) {
      resources.territoryBonus += blessing.territory
      this.colony.events.dismissPastByType(EVENT_TYPE_TERRITORY_LIMIT_REACHED)
    }
  }

  /**
   * Player action: continues playing after winning (all challenges completed).
   */
  continueAfterWin() {
    if (this.challengeModal !== CHALLENGE_MODAL_WIN) {
      return
    }
    this.challengeModal = null
    this.paused = false
  }

  /**
   * Starts construction of a non-HQ building: deducts cost, reserves territory, begins build timer.
   * @param {string} buildingKey - Key in colony.buildings
   */
  levelUpBuilding(buildingKey) {
    const {
      resources, buildings,
    } = this.colony
    const building = buildings[buildingKey]
    const cost = building.levelUpCost

    if (building.isConstructing || !resources.canAfford(cost) || resources.territory >= buildings.headquarters.territoryCap + resources.territoryBonus) {
      return
    }

    resources.deduct(cost)
    const duration = building.levelUp(cost, this._constructionDurationMult)
    this._constructingKeys.add(buildingKey)

    this.colony.events.dismissPastByType(EVENT_TYPE_BUILDING_UPGRADE)
    this.colony.events.addFuture({
      type: EVENT_TYPE_BUILDING_UPGRADE,
      textKey: building.isUnbuilt ? 'event.buildingBuilding' : 'event.buildingUpgrading',
      icon: BUILDING_IMAGE_MAP[buildingKey],
      params: [this._buildingName(buildingKey).toLowerCase()],
      buildingKey: buildingKey,
      remainingSeconds: duration,
    })

    this.update(0)

    // Fire territory event after update recalculates territory with pending
    if (resources.territory >= buildings.headquarters.territoryCap + resources.territoryBonus) {
      this.colony.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
        icon: IMG_OTHER_TERRITORY,
      })
      audio.playSound(SND_NOTIFICATION_ALERT)
    }
  }

  /**
   * Downgrades a producer building by one level, freeing a territory slot.
   * Excess workers above the new capacity are returned to the idle pool.
   * Only allowed when territory is full.
   * @param {string} buildingKey - Key in colony.buildings
   */
  downgradeBuilding(buildingKey) {
    const {
      resources, buildings,
    } = this.colony
    const building = buildings[buildingKey]

    if (!DOWNGRADABLE_BUILDINGS.has(buildingKey)
      || building.level <= 0
      || building.isConstructing
      || resources.territory < buildings.headquarters.territoryCap + resources.territoryBonus) {
      return
    }

    building.level -= 1
    if (building.workers > building.maxWorkers) {
      building.workers = building.maxWorkers
    }

    this.colony.events.dismissPastByType(EVENT_TYPE_TERRITORY_LIMIT_REACHED)
    this.update(0)
  }

  /**
   * Starts HQ territory expansion: deducts cost, begins construction timer.
   */
  expandTerritory() {
    const {
      resources, buildings,
    } = this.colony
    const hq = buildings.headquarters
    const cost = this.expansionCost

    if (hq.isConstructing || hq.isUpgrading || !resources.canAfford(cost)) {
      return
    }

    resources.deduct(cost)
    const duration = hq.levelUp(cost, this._constructionDurationMult)
    this._constructingKeys.add(BUILDING_HEADQUARTERS)

    this.colony.events.dismissPastByType(EVENT_TYPE_BUILDING_UPGRADE)
    this.colony.events.addFuture({
      type: EVENT_TYPE_BUILDING_UPGRADE,
      textKey: 'event.territoryExpanding',
      icon: IMG_OTHER_TERRITORY,
      buildingKey: BUILDING_HEADQUARTERS,
      remainingSeconds: duration,
    })

    this.update(0)
  }

  /**
   * Starts a headquarters type upgrade: deducts cost, begins upgrade timer.
   */
  upgradeHeadquarters() {
    const {
      resources, buildings,
    } = this.colony
    const hq = buildings.headquarters
    const cost = hq.upgradeCost

    if (hq.isConstructing || hq.isUpgrading || !cost || !resources.canAfford(cost)) {
      return
    }

    resources.deduct(cost)
    const duration = hq.upgradeType(cost, this._constructionDurationMult)
    this._hqUpgrading = true

    this.colony.events.dismissPastByType(EVENT_TYPE_BUILDING_UPGRADE)
    this.colony.events.addFuture({
      type: EVENT_TYPE_BUILDING_UPGRADE,
      textKey: 'event.buildingUpgrading',
      icon: IMG_BUILDING_HEADQUARTERS_MAP[hq.nextType],
      params: [this._buildingName(BUILDING_HEADQUARTERS).toLowerCase()],
      buildingKey: BUILDING_HEADQUARTERS,
      remainingSeconds: duration,
    })

    this.update(0)
  }

  /**
   * Recruits a new worker: deducts food cost, increments worker count.
   */
  recruitWorker() {
    if (!this._recruit()) {
      return
    }
    this.update(0)
  }

  /**
   * Dismisses up to `count` idle workers from the colony permanently.
   * @param {number} count - Maximum workers to dismiss
   */
  dismissWorkers(count) {
    const {
      resources, buildings,
    } = this.colony
    const actual = Math.min(count, this.colony.idleWorkers)
    if (actual <= 0) {
      return
    }
    resources.workers -= actual
    if (resources.workers < buildings.house.workersCap) {
      this.colony.events.dismissPastByType(EVENT_TYPE_POPULATION_LIMIT_REACHED)
    }
    this.update(0)
  }

  /**
   * Assigns up to `count` workers to a building (recruiting as needed).
   * Plays sound and updates state only once at the end.
   * @param {string} buildingKey - Key in colony.buildings
   * @param {number} count - Maximum workers to assign
   */
  assignWorkers(buildingKey, count) {
    const building = this.colony.buildings[buildingKey]
    let assigned = 0
    for (let i = 0; i < count; i++) {
      if (building.isFull) {
        break
      }
      if (this.colony.idleWorkers <= 0 && !this._recruit()) {
        break
      }
      building.workers += 1
      assigned += 1
    }
    if (assigned > 0) {
      this._playAssignSound(buildingKey)
      this.update(0)
    }
  }

  /**
   * Unassigns up to `count` workers from a building back to idle.
   * Updates state only once at the end.
   * @param {string} buildingKey - Key in colony.buildings
   * @param {number} count - Maximum workers to unassign
   */
  unassignWorkers(buildingKey, count) {
    const building = this.colony.buildings[buildingKey]
    const actual = Math.min(count, building.workers)
    if (actual <= 0) {
      return
    }
    building.workers -= actual
    this.update(0)
  }

  /**
   * Starts a research: validates preconditions, deducts cost, begins timer, creates future event.
   * @param {string} key - Research key from enums
   */
  startResearch(key) {
    const {
      resources, buildings,
    } = this.colony
    const {
      academy,
    } = buildings
    const cost = RESEARCH_COSTS[key]

    if (!academy.canResearch(key) || !cost || !resources.canAfford(cost)) {
      return
    }

    const duration = cost.toSeconds
    resources.deduct(cost)
    academy.start(key, duration)

    this.colony.events.addFuture({
      type: EVENT_TYPE_RESEARCH_COMPLETE,
      textKey: 'event.researchInProgress',
      icon: IMG_RESOURCE_KNOWLEDGE,
      params: [t('research.' + key).toLowerCase()],
      researchKey: key,
      remainingSeconds: duration,
    })

    this.update(0)
  }

  /**
   * Executes a market trade: buy or sell a resource for gold.
   * @param {string} resource - Resource key (food, wood, stone, copper, iron)
   * @param {'buy'|'sell'} direction - Trade direction
   * @param {number} [amount] - Number of resource units to trade
   */
  executeTrade(resource, direction, amount) {
    const {
      resources, buildings,
    } = this.colony
    const market = buildings[BUILDING_MARKET]

    const bonuses = buildings.academy.completedBonuses(RESEARCH_TREE)
    const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
    if (market.executeTrade(resource, direction, resources, buildings.storehouse.storageCap(storageBonus), amount)) {
      this.update(0)
    }
  }

  /**
   * Discounted territory expansion cost after applying expansion-cost research bonuses.
   * @returns {Cost} The discounted cost for the next territory level
   */
  get expansionCost() {
    const baseCost = this.colony.buildings.headquarters.levelUpCost
    const bonuses = this.colony.buildings.academy.completedBonuses(RESEARCH_TREE)
    const multiplier = 1 - (bonuses[BONUS_EXPANSION_COST] ?? 0)
    return baseCost.multiplyFloor(multiplier)
  }

  /**
   * Duration multiplier from completed construction-time research bonuses.
   * @returns {number} Multiplier in (0, 1] — lower means faster construction
   */
  get _constructionDurationMult() {
    const bonuses = this.colony.buildings.academy.completedBonuses(RESEARCH_TREE)
    let reduction = bonuses[BONUS_CONSTRUCTION_TIME] ?? 0
    const rapidConstruction = this.meta.challenges.activeBlessings.find(blessing => blessing.type === BLESSING_RAPID_CONSTRUCTION)
    if (rapidConstruction) {
      reduction += rapidConstruction.construction
    }
    return Math.max(0, 1 - reduction)
  }

  /**
   * Checks sequential tutorial progress and auto-advances past completed steps.
   * Called every gameTick (1s interval).
   */
  checkTutorial() {
    const tutorial = this.meta.tutorial
    if (!tutorial.isActive) {
      return
    }
    let step = TUTORIAL_STEPS[tutorial.currentStep]
    while (step?.check(this.colony.buildings)) {
      tutorial.currentStep++
      if (tutorial.currentStep >= TUTORIAL_STEPS.length) {
        tutorial.completed = true
        storage.tutorialCompleted = true
        return
      }
      step = TUTORIAL_STEPS[tutorial.currentStep]
    }
  }

  /**
   * Triggers a reactive tutorial modal if not already dismissed.
   * @param {string} key - Tutorial modal key from enums
   */
  _triggerTutorialModal(key) {
    if (storage.tutorialCompleted) {
      return
    }
    const tutorial = this.meta.tutorial
    if (!tutorial.dismissedModals.has(key) && !tutorial.activeModal) {
      tutorial.activeModal = key
      this.paused = true
    }
  }

  /**
   * Shared recruit logic: deducts cost, increments worker count, plays sound, fires event.
   * @returns {boolean} true if recruitment succeeded
   */
  _recruit() {
    const {
      resources, buildings,
    } = this.colony
    if (!resources.canAfford(WORKER_RECRUIT_COST) || resources.workers >= buildings.house.workersCap) {
      return false
    }
    resources.deduct(WORKER_RECRUIT_COST)
    resources.workers += 1
    audio.playSound(SND_WORKER_CREATED)
    if (resources.workers >= buildings.house.workersCap
      && !this.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)) {
      this.colony.events.addPast({
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
   * @param {string} buildingKey - Key in colony.buildings
   */
  _playAssignSound(buildingKey) {
    if (buildingKey === BUILDING_FARM) {
      audio.playSound(SND_WORKER_FARM)
    } else if (buildingKey === BUILDING_WOODCUTTER) {
      audio.playSound(SND_WORKER_WOODCUTTER)
    } else if (buildingKey === BUILDING_ACADEMY) {
      audio.playSound(SND_WORKER_ACADEMY)
    } else if (buildingKey === BUILDING_TEMPLE) {
      audio.playSound(SND_WORKER_TEMPLE)
    } else if ([
      BUILDING_QUARRY,
      BUILDING_COPPER_MINE,
      BUILDING_IRON_MINE,
      BUILDING_GOLD_MINE,
    ].includes(buildingKey)) {
      audio.playSound(SND_WORKER_MINE)
    }
  }

  /**
   * Returns the localized display name for a building.
   * @param {string} buildingKey - Key in colony.buildings
   * @returns {string} Localized building display name
   */
  _buildingName(buildingKey) {
    if (buildingKey === BUILDING_HEADQUARTERS) {
      return t('building.headquarters.' + this.colony.buildings.headquarters.type)
    } else {
      return t('building.' + buildingKey)
    }
  }

  /**
   * Reconstructs a State instance from serialized data.
   * Returns null if data is corrupted or invalid.
   * @param {Object} data - Serialized state data
   * @returns {State|null} Restored State instance, or null on failure
   */
  static fromJSON(data) {
    try {
      const meta = Meta.fromJSON(data.meta)
      const colony = Colony.fromJSON(data.colony, BUILDING_CLASS_MAP)
      const state = new State(meta, colony)

      // Restore edge-detection tracking state so update(0) doesn't
      // re-fire events that are already in the loaded past list
      state._resourcesAtCap = new Set(data.resourcesAtCap ?? [])
      state._resourcesNegativeProduction = new Set(data.resourcesNegativeProduction ?? [])
      state._hadIdleWorkers = data.hadIdleWorkers ?? false
      state.challengeModal = data.challengeModal ?? null
      if (state.challengeModal) {
        state.paused = true
      }

      state.update(0)
      return state
    } catch {
      return null
    }
  }

  /**
   * Serializable snapshot for save/load.
   * @returns {Object} Plain object snapshot for serialization
   */
  toJSON() {
    return {
      meta: this.meta.toJSON(),
      colony: this.colony.toJSON(),
      resourcesAtCap: [...this._resourcesAtCap],
      resourcesNegativeProduction: [...this._resourcesNegativeProduction],
      hadIdleWorkers: this._hadIdleWorkers,
      challengeModal: this.challengeModal,
    }
  }
}

export default State
