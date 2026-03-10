// Central game state container — mutation handler, game loop, and player actions.

import {MONUMENT_FAITH_PER_LEVEL, PRODUCTION_BONUS_MAP, PRODUCTION_RATES, RESEARCH_COSTS, SEASON_COLD_FOOD_MODIFIER, SEASON_COLD_WOOD_MODIFIER, SEASON_WARM_FOOD_MODIFIER, SEASON_WARM_WOOD_MODIFIER, SHORTAGE_MAX_PENALTY, WORKER_FOOD_CONSUMPTION, WORKER_RECRUIT_COST, WORKER_WOOD_CONSUMPTION} from '@/js/engine/balancing.js'
import {IMG_OTHER_TERRITORY, IMG_RESOURCE_KNOWLEDGE, IMG_SEASON_COLD, IMG_SEASON_WARM, IMG_UNIT_WORKER, SND_BUILDING_CREATED, SND_HEADQUARTERS_UPGRADED, SND_NOTIFICATION_ALERT, SND_NOTIFICATION_SEASON, SND_RESEARCH_COMPLETED, SND_TERRITORY_EXPANDED, SND_WORKER_ACADEMY, SND_WORKER_CREATED, SND_WORKER_FARM, SND_WORKER_MINE, SND_WORKER_TEMPLE, SND_WORKER_WOODCUTTER} from '@/js/engine/assets.js'
import audio from '@/js/engine/audio.js'
import storage from '@/js/engine/storage.js'
import {BOUNDED_RESOURCES, BUILDING_CLASS_MAP, BUILDING_IMAGE_MAP, IMG_BUILDING_HEADQUARTERS_MAP, RESEARCH_TREE, RESOURCE_LIMIT_EVENT_CONFIG, RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG, TUTORIAL_STEPS} from '@/js/engine/constants.js'
import Colony from '@/js/models/colony.js'
import Meta from '@/js/models/meta.js'
import {BONUS_CONSTRUCTION_TIME, BONUS_EXPANSION_COST, BONUS_FOOD_CONSUMPTION, BONUS_HABITATION, BONUS_STORAGE_CAPACITY, BONUS_WOOD_CONSUMPTION, BONUS_WORKER_PRODUCTIVITY, BUILDING_ACADEMY, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_STOREHOUSE, BUILDING_TEMPLE, BUILDING_WOODCUTTER, EVENT_TYPE_BUILDING_UPGRADE, EVENT_TYPE_POPULATION_LIMIT_REACHED, EVENT_TYPE_RESEARCH_COMPLETE, EVENT_TYPE_RESOURCE_LIMIT_REACHED, EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION, EVENT_TYPE_SEASON_CHANGED, EVENT_TYPE_IDLE_WORKERS, EVENT_TYPE_TERRITORY_LIMIT_REACHED, RESOURCE_FOOD, RESOURCE_WOOD, TUTORIAL_MODAL_SEASON_CHANGED, TUTORIAL_MODAL_NEGATIVE_PRODUCTION, TUTORIAL_MODAL_HQ_UPGRADE} from '@/js/engine/enums.js'
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

    // Whether the game is paused (e.g. by a tutorial modal)
    this.paused = false
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
      resources, production, buildings, consumption,
    } = this.colony

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

    // Zero out all production rates — they are recomputed from scratch each
    // tick so that changes (worker reassignment, building destruction, research
    // completion) take effect immediately without stale carryover
    production.food = 0
    production.wood = 0
    production.stone = 0
    production.copper = 0
    production.iron = 0
    production.gold = 0
    production.faith = 0
    production.knowledge = 0

    // Compute per-second production rates for every production building.
    // Two formulas depending on building type:
    //   Passive (e.g. altar): level × baseRate × resourceBonus
    //   Worker-based (e.g. farm): workers × baseRate × resourceBonus × workerBonus
    // workerMult: global productivity bonus from Transportation research (+5%/tier)
    // resMult: per-resource bonus from research (e.g. Food Production, Mining)
    const workerMult = 1 + (bonuses[BONUS_WORKER_PRODUCTIVITY] ?? 0)
    for (const [
      buildingKey,
      config,
    ] of Object.entries(PRODUCTION_RATES)) {
      const building = buildings[buildingKey]
      if (building.level > 0) {
        const bonusType = PRODUCTION_BONUS_MAP[buildingKey]
        const resMult = 1 + (bonusType ? (bonuses[bonusType] ?? 0) : 0)
        if (config.passive) {
          production[config.resource] += building.level * config.rate * resMult
        } else if (building.workers > 0) {
          production[config.resource] += building.workers * config.rate * resMult * workerMult
        }
      }
    }

    // Seasonal post-multiplier on total food production: warm +20%, cold −20%
    const foodSeasonMod = this.colony.season.isWarm ? SEASON_WARM_FOOD_MODIFIER : SEASON_COLD_FOOD_MODIFIER
    production.food *= 1 + foodSeasonMod

    // Wood seasonal modifier — applied to wood *consumption* below, not production.
    // Warm −20% (less heating needed), cold +20% (more heating needed)
    const woodSeasonMod = this.colony.season.isWarm ? SEASON_WARM_WOOD_MODIFIER : SEASON_COLD_WOOD_MODIFIER

    // Productivity ratio: starts at 1 (100%) and is reduced when food or wood
    // has negative net production (from previous tick). The reduction is
    // proportional to the deficit ratio (uncovered consumption / total
    // consumption), scaled by SHORTAGE_MAX_PENALTY. Worst-of: only the
    // largest deficit applies. Uses previous tick's consumption (still on
    // colony.consumption) and current gross production
    let productivity = 1
    if (resources.workers === 0) {
      productivity = 0
    }
    const prevConsumption = this.colony.consumption
    if (this._resourcesNegativeProduction.has('food') && prevConsumption.food > 0) {
      const deficit = Math.max(0, prevConsumption.food - production.food)
      productivity = Math.min(productivity, 1 - (deficit / prevConsumption.food) * SHORTAGE_MAX_PENALTY)
    }
    if (this._resourcesNegativeProduction.has('wood') && prevConsumption.wood > 0) {
      const deficit = Math.max(0, prevConsumption.wood - production.wood)
      productivity = Math.min(productivity, 1 - (deficit / prevConsumption.wood) * SHORTAGE_MAX_PENALTY)
    }
    this.colony.productivity = productivity
    if (productivity < 1) {
      production.food *= productivity
      production.wood *= productivity
      production.stone *= productivity
      production.copper *= productivity
      production.iron *= productivity
      production.gold *= productivity
      production.faith *= productivity
      production.knowledge *= productivity
    }

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

    // Worker upkeep: every worker (idle and assigned) consumes food and wood
    // each second. Research bonuses reduce the base consumption rates (−5%/tier).
    // Wood upkeep is additionally scaled by seasonal modifier (cold = more heating).
    // Consumption rates are per-second and also used by the UI (header tooltips)
    const effFoodCons = WORKER_FOOD_CONSUMPTION * (1 - (bonuses[BONUS_FOOD_CONSUMPTION] ?? 0))
    const effWoodCons = WORKER_WOOD_CONSUMPTION * (1 - (bonuses[BONUS_WOOD_CONSUMPTION] ?? 0))
    if (resources.workers > 0) {
      consumption.food = resources.workers * effFoodCons
      consumption.wood = resources.workers * effWoodCons * (1 + woodSeasonMod)
    } else {
      consumption.food = 0
      consumption.wood = 0
    }

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
      if (this.colony.netProduction(resource) < 0) {
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
   * Starts construction of a non-HQ building: deducts cost, reserves territory, begins build timer.
   * @param {string} buildingKey - Key in colony.buildings
   */
  levelUpBuilding(buildingKey) {
    const {
      resources, buildings,
    } = this.colony
    const building = buildings[buildingKey]
    const cost = building.levelUpCost

    if (building.isConstructing || !resources.canAfford(cost) || resources.territory >= buildings.headquarters.territoryCap) {
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
    if (resources.territory >= buildings.headquarters.territoryCap) {
      this.colony.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
        icon: IMG_OTHER_TERRITORY,
      })
      audio.playSound(SND_NOTIFICATION_ALERT)
    }
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
   */
  executeTrade(resource, direction) {
    const {
      resources, buildings,
    } = this.colony
    const market = buildings[BUILDING_MARKET]

    const bonuses = buildings.academy.completedBonuses(RESEARCH_TREE)
    const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
    if (market.executeTrade(resource, direction, resources, buildings.storehouse.storageCap(storageBonus))) {
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
    const mult = 1 - (bonuses[BONUS_EXPANSION_COST] ?? 0)
    return baseCost.multiplyFloor(mult)
  }

  /**
   * Duration multiplier from completed construction-time research bonuses.
   * @returns {number} Multiplier in (0, 1] — lower means faster construction
   */
  get _constructionDurationMult() {
    const bonuses = this.colony.buildings.academy.completedBonuses(RESEARCH_TREE)
    return 1 - (bonuses[BONUS_CONSTRUCTION_TIME] ?? 0)
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
    }
  }
}

export default State
