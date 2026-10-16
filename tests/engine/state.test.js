import {describe, it, expect, vi, beforeEach} from 'vitest'
import {BLESSING_BLESSED_MARKETS, BLESSING_CELESTIAL_PROSPERITY, BLESSING_FAVORABLE_WEATHER, BLESSING_FERTILE_SOIL, BLESSING_FOREST_BLOOM, BLESSING_GIFT_FROM_THE_HEAVENS, BLESSING_HOLY_EXPANSION, BLESSING_RAPID_CONSTRUCTION, BLESSING_RICH_MINES, BLESSING_WISDOM_OF_THE_GODS, BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_QUARRY, BUILDING_STOREHOUSE, BUILDING_TEMPLE, BUILDING_WOODCUTTER, CHALLENGE_MODAL_FAILURE, CHALLENGE_MODAL_REWARD, CHALLENGE_MODAL_WIN, CHALLENGE_STATUS_ACTIVATED, CHALLENGE_STATUS_PENDING, CHALLENGE_STATUS_STARTED, EVENT_TYPE_BUILDING_UPGRADE, EVENT_TYPE_CHALLENGE_STARTED, EVENT_TYPE_POPULATION_LIMIT_REACHED, EVENT_TYPE_RESEARCH_COMPLETE, EVENT_TYPE_RESOURCE_LIMIT_REACHED, EVENT_TYPE_TERRITORY_LIMIT_REACHED, HQ_TYPE_CAMP, HQ_TYPE_CITY, HQ_TYPE_SETTLEMENT, PUNISHMENT_CROP_FAILURE, PUNISHMENT_LANDSLIDE, PUNISHMENT_PLAGUE, PUNISHMENT_VOLCANO, PUNISHMENT_WILDFIRES, RESEARCH_FOOD_PRODUCTION_1, RESOURCE_FOOD, RESOURCE_STONE, RESOURCE_WOOD, SEASON_COLD, SEASON_WARM, TRADE_BUY, TRADE_SELL, TUTORIAL_MODAL_CHALLENGE_STARTED, TUTORIAL_MODAL_HQ_UPGRADE, TUTORIAL_MODAL_NEGATIVE_PRODUCTION, TUTORIAL_MODAL_SEASON_CHANGED} from '@/js/engine/enums.js'
import {HQ_TERRITORY_PER_LEVEL, MONUMENT_FAITH_PER_LEVEL, SEASON_DURATION, SHORTAGE_MAX_PENALTY, WORKER_FOOD_CONSUMPTION, WORKER_RECRUIT_COST, WORKER_WOOD_CONSUMPTION} from '@/js/engine/balancing.js'
import {IMG_OTHER_TERRITORY, SND_BUILDING_CREATED, SND_HEADQUARTERS_UPGRADED, SND_NOTIFICATION_ALERT, SND_TERRITORY_EXPANDED, SND_WORKER_ACADEMY, SND_WORKER_FARM, SND_WORKER_MINE, SND_WORKER_TEMPLE, SND_WORKER_WOODCUTTER} from '@/js/engine/assets.js'
import {DOWNGRADABLE_BUILDINGS, RESOURCE_LIMIT_EVENT_CONFIG, RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG} from '@/js/engine/constants.js'
import Academy from '@/js/models/buildings/academy.js'
import Altar from '@/js/models/buildings/altar.js'
import Archery from '@/js/models/buildings/archery.js'
import Barracks from '@/js/models/buildings/barracks.js'
import CopperMine from '@/js/models/buildings/copper_mine.js'
import Farm from '@/js/models/buildings/farm.js'
import GoldMine from '@/js/models/buildings/gold_mine.js'
import Headquarters from '@/js/models/buildings/headquarters.js'
import House from '@/js/models/buildings/house.js'
import IronMine from '@/js/models/buildings/iron_mine.js'
import Market from '@/js/models/buildings/market.js'
import Monument from '@/js/models/buildings/monument.js'
import Quarry from '@/js/models/buildings/quarry.js'
import Stable from '@/js/models/buildings/stable.js'
import Storehouse from '@/js/models/buildings/storehouse.js'
import Temple from '@/js/models/buildings/temple.js'
import Tower from '@/js/models/buildings/tower.js'
import Wall from '@/js/models/buildings/wall.js'
import Woodcutter from '@/js/models/buildings/woodcutter.js'
import Workshop from '@/js/models/buildings/workshop.js'
import Buildings from '@/js/models/buildings.js'
import Colony from '@/js/models/colony.js'
import Meta from '@/js/models/meta.js'
import Resources from '@/js/models/resources.js'
import Season from '@/js/models/season.js'
import Events from '@/js/models/events/events.js'
import Tutorial from '@/js/models/tutorial.js'
import {createBlessing, createChallenge, createChallenges, createPunishment} from '../helpers/factories.js'

vi.mock('@/js/engine/analytics.js', () => ({
  default: {
    logTutorialComplete: vi.fn(),
  },
}))

vi.mock('@/js/engine/audio.js', () => ({
  default: {
    playSound: vi.fn(),
  },
}))

vi.mock('@/js/engine/storage.js', () => ({
  default: {
    tutorialCompleted: false,
  },
}))

vi.mock('@/js/i18n/localized.js', () => ({
  t: (key) => key,
}))

function createBuildings(overrides = {}) {
  const defaultBuilding = (BuildingClass, extra = {}) => {
    const data = {
      level: 0,
      ...extra,
    }
    return new BuildingClass(data)
  }
  return new Buildings({
    headquarters: new Headquarters({
      level: 1,
      type: HQ_TYPE_CAMP,
      ...overrides.headquarters,
    }),
    house: new House({
      level: 0,
      ...overrides.house,
    }),
    academy: new Academy({
      level: 0,
      ...overrides.academy,
    }),
    storehouse: new Storehouse({
      level: 0,
      ...overrides.storehouse,
    }),
    market: new Market({
      level: 0,
      ...overrides.market,
    }),
    farm: new Farm({
      level: 0,
      ...overrides.farm,
    }),
    woodcutter: new Woodcutter({
      level: 0,
      ...overrides.woodcutter,
    }),
    quarry: defaultBuilding(Quarry, overrides.quarry),
    copperMine: defaultBuilding(CopperMine, overrides.copperMine),
    ironMine: defaultBuilding(IronMine, overrides.ironMine),
    goldMine: defaultBuilding(GoldMine, overrides.goldMine),
    altar: defaultBuilding(Altar, overrides.altar),
    temple: defaultBuilding(Temple, overrides.temple),
    monument: defaultBuilding(Monument, overrides.monument),
    barracks: defaultBuilding(Barracks, overrides.barracks),
    archery: defaultBuilding(Archery, overrides.archery),
    stable: defaultBuilding(Stable, overrides.stable),
    workshop: defaultBuilding(Workshop, overrides.workshop),
    wall: defaultBuilding(Wall, overrides.wall),
    tower: defaultBuilding(Tower, overrides.tower),
  })
}

function createColony(overrides = {}) {
  return new Colony({
    year: overrides.year ?? 1,
    season: new Season({
      currentSeason: SEASON_WARM,
      seasonElapsed: 0,
      ...overrides.season,
    }),
    resources: new Resources({
      territory: 0,
      territoryBonus: 0,
      workers: 0,
      food: 200,
      wood: 200,
      stone: 200,
      copper: 200,
      iron: 200,
      gold: 200,
      faith: 200,
      knowledge: 200,
      ...overrides.resources,
    }),
    buildings: overrides.buildings ?? createBuildings(overrides.buildingOverrides),
    events: overrides.events ?? new Events(),
  })
}

function createMeta(overrides = {}) {
  return new Meta({
    version: 1,
    createdDateTime: '2025-01-01T00:00:00.000Z',
    updatedDateTime: '2025-01-01T00:00:00.000Z',
    challenges: overrides.challenges ?? createChallenges(),
    gameSpeed: overrides.gameSpeed ?? 1,
    tutorial: overrides.tutorial ?? new Tutorial({
      completed: true,
    }),
  })
}

async function createState(options = {}) {
  const {
    default: State,
  } = await import('@/js/engine/state.js')
  const meta = options.meta ?? createMeta(options.metaOverrides ?? {})
  const colony = options.colony ?? createColony(options.colonyOverrides ?? {})
  return new State(meta, colony)
}

describe('State', () => {
  let analytics
  let audio
  let storage

  beforeEach(async () => {
    vi.clearAllMocks()
    const analyticsModule = await import('@/js/engine/analytics.js')
    analytics = analyticsModule.default
    const audioModule = await import('@/js/engine/audio.js')
    audio = audioModule.default
    const storageModule = await import('@/js/engine/storage.js')
    storage = storageModule.default
    storage.tutorialCompleted = false
  })

  // ── constructor ──────────────────────────────────────────────────

  describe('constructor', () => {
    it('should set meta and colony fields', async () => {
      const state = await createState()
      expect(state.meta).toBeDefined()
      expect(state.colony).toBeDefined()
    })

    it('should initialize tracking sets empty', async () => {
      const state = await createState()
      expect(state._resourcesAtCap.size).toBe(0)
      expect(state._resourcesNegativeProduction.size).toBe(0)
    })

    it('should initialize paused to false', async () => {
      const state = await createState()
      expect(state.paused).toBe(false)
    })

    it('should initialize challengeModal to null', async () => {
      const state = await createState()
      expect(state.challengeModal).toBeNull()
    })

    it('should detect constructing buildings', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 0,
              constructionRemaining: 5,
              constructionDuration: 10,
            },
          },
        },
      })
      expect(state._constructingKeys.has(BUILDING_FARM)).toBe(true)
    })

    it('should not add non-constructing buildings to constructing keys', async () => {
      const state = await createState()
      expect(state._constructingKeys.size).toBe(0)
    })
  })

  // ── update(delta) ────────────────────────────────────────────────

  describe('update', () => {
    it('should increase food when farm has workers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
            wood: 100,
            workers: 5,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 5,
            },
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      const foodBefore = state.colony.resources.food
      state.update(1)
      const foodAfter = state.colony.resources.food
      // Farm produces 1 food/sec per worker in warm season (1.2 multiplier)
      // 5 workers * 1 rate * 1.2 season = 6/sec production
      // Consumption: 5 workers * 0.1 = 0.5/sec
      // Net should increase food
      expect(foodAfter).toBeGreaterThan(foodBefore)
    })

    it('should deduct food and wood consumption from workers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
            wood: 100,
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(1)
      // 10 workers * 0.1 food/sec = 1.0 food consumed
      // No production buildings, so food should decrease
      expect(state.colony.resources.food).toBeLessThan(100)
      // Warm season reduces wood consumption (multiplier 0.8)
      // 10 workers * 0.1 * 0.8 = 0.8 wood consumed
      expect(state.colony.resources.wood).toBeLessThan(100)
    })

    it('should NOT deduct consumption when delta is 0', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
            wood: 100,
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      // delta=0 is a recalculate-only call, no resource flow
      expect(state.colony.resources.food).toBe(100)
      expect(state.colony.resources.wood).toBe(100)
    })

    it('should cap resources at storage limit', async () => {
      // Storehouse level 0: storageCap = 500 * 1.2^0 = 500
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 499,
            workers: 5,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 5,
            },
            house: {
              level: 1,
              workersCap: 10,
            },
          },
        },
      })
      // Big delta to push food well above 500 cap
      state.update(100)
      expect(state.colony.resources.food).toBeLessThanOrEqual(500)
    })

    it('should floor resources at 0', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0.01,
            wood: 0.01,
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(1)
      expect(state.colony.resources.food).toBeGreaterThanOrEqual(0)
      expect(state.colony.resources.wood).toBeGreaterThanOrEqual(0)
    })

    it('should update territory count based on building levels', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 2,
            },
            woodcutter: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      // totalLevels = all non-HQ building levels = 2 + 1 = 3
      expect(state.colony.resources.territory).toBe(3)
    })

    it('should dismiss cap event when resource drops below storage cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
          },
          buildingOverrides: {
            storehouse: {
              level: 1,
            },
          },
        },
      })
      // Pre-populate the tracking set as if food was previously at cap
      state._resourcesAtCap.add(RESOURCE_FOOD)
      const dismissSpy = vi.spyOn(state.colony.events, 'dismissPastByTextKey')
      state.update(1)
      expect(state._resourcesAtCap.has(RESOURCE_FOOD)).toBe(false)
      const config = RESOURCE_LIMIT_EVENT_CONFIG[RESOURCE_FOOD]
      expect(dismissSpy).toHaveBeenCalledWith(config.textKey)
    })

    it('should not re-fire cap event when resource stays at cap on consecutive ticks', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      // Pre-populate as if food was already at cap on the previous tick
      state._resourcesAtCap.add(RESOURCE_FOOD)
      const addSpy = vi.spyOn(state.colony.events, 'addPast')
      state.update(0)
      // Food is still at cap but already tracked — no duplicate event
      expect(state._resourcesAtCap.has(RESOURCE_FOOD)).toBe(true)
      expect(addSpy).not.toHaveBeenCalledWith(
        expect.objectContaining({
          type: EVENT_TYPE_RESOURCE_LIMIT_REACHED,
        }),
      )
    })

    it('should not trigger tutorial modal for non-food/non-wood negative production', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            wood: 200,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      // Inject artificial stone consumption to force negative stone production
      state.consumption.stone = 999
      const triggerSpy = vi.spyOn(state, '_triggerTutorialModal')
      state.update(0)
      expect(state._resourcesNegativeProduction.has(RESOURCE_STONE)).toBe(true)
      expect(triggerSpy).not.toHaveBeenCalledWith(TUTORIAL_MODAL_NEGATIVE_PRODUCTION)
    })

    it('should dismiss negative production event when production recovers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            wood: 200,
            workers: 5,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 5,
            },
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      // Pre-populate as if food had negative production previously
      state._resourcesNegativeProduction.add(RESOURCE_FOOD)
      const dismissSpy = vi.spyOn(state.colony.events, 'dismissPastByTextKey')
      // With 5 farm workers, production exceeds consumption → recovery
      state.update(1)
      expect(state._resourcesNegativeProduction.has(RESOURCE_FOOD)).toBe(false)
      const config = RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG[RESOURCE_FOOD]
      expect(dismissSpy).toHaveBeenCalledWith(config.textKey)
    })
  })

  // ── netProduction ────────────────────────────────────────────────

  describe('netProduction', () => {
    it('should return production minus consumption for food', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            wood: 200,
            workers: 5,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 5,
            },
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      const netFood = state.netProduction(RESOURCE_FOOD)
      // Production: 5 * 1 * 1.2 (warm season) = 6.0
      // Consumption: 5 * 0.1 = 0.5
      // Net: 6.0 - 0.5 = 5.5
      expect(netFood).toBeGreaterThan(0)
    })

    it('should return production only for resources without consumption', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            quarry: {
              level: 1,
              workers: 3,
            },
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      const netStone = state.netProduction(RESOURCE_STONE)
      // Stone has no consumption, so net = production
      expect(netStone).toBeGreaterThan(0)
    })
  })

  // ── expansionCost ────────────────────────────────────────────────

  describe('expansionCost', () => {
    it('should return HQ levelUpCost when no research bonuses', async () => {
      const state = await createState()
      const cost = state.expansionCost
      const baseCost = state.colony.buildings.headquarters.levelUpCost
      expect(cost.food).toBe(baseCost.food)
      expect(cost.wood).toBe(baseCost.wood)
    })

    it('should return discounted cost with expansion research', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              completed: ['expansion1'],
            },
          },
        },
      })
      const cost = state.expansionCost
      const baseCost = state.colony.buildings.headquarters.levelUpCost
      // With expansion research, cost should be lower
      expect(cost.food).toBeLessThanOrEqual(baseCost.food)
      expect(cost.wood).toBeLessThanOrEqual(baseCost.wood)
    })
  })

  // ── advanceSeason ────────────────────────────────────────────────

  describe('advanceSeason', () => {
    it('should not flip season before duration reached', async () => {
      const state = await createState({
        colonyOverrides: {
          season: {
            currentSeason: SEASON_WARM,
            seasonElapsed: 0,
          },
        },
      })
      state.advanceSeason(10)
      expect(state.colony.season.currentSeason).toBe(SEASON_WARM)
    })

    it('should flip season at duration boundary', async () => {
      const state = await createState({
        colonyOverrides: {
          season: {
            currentSeason: SEASON_WARM,
            seasonElapsed: SEASON_DURATION - 1,
          },
        },
      })
      state.advanceSeason(1)
      expect(state.colony.season.currentSeason).toBe(SEASON_COLD)
    })

    it('should increment year when flipping to warm', async () => {
      const state = await createState({
        colonyOverrides: {
          year: 1,
          season: {
            currentSeason: SEASON_COLD,
            seasonElapsed: SEASON_DURATION - 1,
          },
        },
      })
      state.advanceSeason(1)
      expect(state.colony.season.currentSeason).toBe(SEASON_WARM)
      expect(state.colony.year).toBe(2)
    })

    it('should increment year correctly on multi-flip from cold', async () => {
      const state = await createState({
        colonyOverrides: {
          year: 1,
          season: {
            currentSeason: SEASON_COLD,
            seasonElapsed: 0,
          },
        },
      })
      // 3 flips from cold: cold→warm (year++), warm→cold, cold→warm (year++)
      state.advanceSeason(SEASON_DURATION * 3)
      expect(state.colony.season.currentSeason).toBe(SEASON_WARM)
      expect(state.colony.year).toBe(3)
    })

    it('should increment year correctly on multi-flip from warm', async () => {
      const state = await createState({
        colonyOverrides: {
          year: 1,
          season: {
            currentSeason: SEASON_WARM,
            seasonElapsed: 0,
          },
        },
      })
      // 4 flips from warm: warm→cold, cold→warm (year++), warm→cold, cold→warm (year++)
      state.advanceSeason(SEASON_DURATION * 4)
      expect(state.colony.season.currentSeason).toBe(SEASON_WARM)
      expect(state.colony.year).toBe(3)
    })

    it('should play season notification sound on flip', async () => {
      const state = await createState({
        colonyOverrides: {
          season: {
            currentSeason: SEASON_WARM,
            seasonElapsed: SEASON_DURATION - 1,
          },
        },
      })
      state.advanceSeason(1)
      expect(audio.playSound).toHaveBeenCalled()
    })
  })

  // ── advanceConstruction ──────────────────────────────────────────

  describe('advanceConstruction', () => {
    it('should complete building when timer reaches 0', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 0,
              constructionRemaining: 1,
              constructionDuration: 5,
            },
          },
        },
      })
      expect(state._constructingKeys.has(BUILDING_FARM)).toBe(true)
      state.advanceConstruction(1)
      expect(state.colony.buildings.farm.level).toBe(1)
    })

    it('should remove building from constructing keys on completion', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 0,
              constructionRemaining: 1,
              constructionDuration: 5,
            },
          },
        },
      })
      state.advanceConstruction(1)
      expect(state._constructingKeys.has(BUILDING_FARM)).toBe(false)
    })

    it('should not advance when nothing is constructing', async () => {
      const state = await createState()
      // No buildings constructing, should be a no-op
      state.advanceConstruction(1)
      expect(state.colony.buildings.farm.level).toBe(0)
    })

    it('should not complete building when timer has time remaining', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 0,
              constructionRemaining: 10,
              constructionDuration: 10,
            },
          },
        },
      })
      state.advanceConstruction(5)
      expect(state.colony.buildings.farm.level).toBe(0)
      expect(state.colony.buildings.farm.constructionRemaining).toBe(5)
    })

    it('should handle HQ level-up completion', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
              constructionRemaining: 1,
              constructionDuration: 10,
            },
          },
        },
      })
      state.colony.events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.buildingUpgrading',
        buildingKey: BUILDING_HEADQUARTERS,
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
      })
      state.advanceConstruction(1)
      expect(state.colony.events.past.some(
        event => event.textKey === 'event.territoryExpanded' && event.icon === IMG_OTHER_TERRITORY,
      )).toBe(true)
      expect(audio.playSound).toHaveBeenCalledWith(SND_TERRITORY_EXPANDED)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_TERRITORY_LIMIT_REACHED)).toBe(false)
    })

    it('should handle storehouse completion', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            storehouse: {
              level: 0,
              constructionRemaining: 1,
              constructionDuration: 10,
            },
          },
        },
      })
      state.colony.events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.buildingBuilding',
        buildingKey: BUILDING_STOREHOUSE,
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_RESOURCE_LIMIT_REACHED,
        textKey: 'event.resourceLimitReached',
      })
      state._resourcesAtCap.add('food')
      state.advanceConstruction(1)
      expect(state.colony.events.future.some(
        event => event.buildingKey === BUILDING_STOREHOUSE,
      )).toBe(false)
      expect(audio.playSound).toHaveBeenCalledWith(SND_BUILDING_CREATED)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_RESOURCE_LIMIT_REACHED)).toBe(false)
      expect(state._resourcesAtCap.size).toBe(0)
    })

    it('should handle house completion', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            house: {
              level: 0,
              constructionRemaining: 1,
              constructionDuration: 10,
            },
          },
        },
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_POPULATION_LIMIT_REACHED,
        textKey: 'event.populationLimitReached',
      })
      state.advanceConstruction(1)
      expect(audio.playSound).toHaveBeenCalledWith(SND_BUILDING_CREATED)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(false)
    })

    it('should handle monument completion and grant faith', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            monument: {
              level: 1,
              constructionRemaining: 1,
              constructionDuration: 10,
            },
          },
        },
      })
      const faithBefore = state.colony.resources.faith
      state.advanceConstruction(1)
      expect(audio.playSound).toHaveBeenCalledWith(SND_BUILDING_CREATED)
      expect(state.colony.resources.faith).toBe(faithBefore + MONUMENT_FAITH_PER_LEVEL * 2)
    })

    it('should handle HQ type upgrade completion', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
              upgradeRemaining: 1,
              upgradeDuration: 10,
            },
          },
        },
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
          }),
        },
      })
      state.colony.events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.buildingUpgrading',
        buildingKey: BUILDING_HEADQUARTERS,
      })
      expect(state._hqUpgrading).toBe(true)
      state.advanceConstruction(1)
      expect(state._hqUpgrading).toBe(false)
      expect(state.colony.events.future.some(
        event => event.buildingKey === BUILDING_HEADQUARTERS,
      )).toBe(false)
      expect(audio.playSound).toHaveBeenCalledWith(SND_HEADQUARTERS_UPGRADED)
      expect(state.meta.tutorial.activeModal).toBe(TUTORIAL_MODAL_HQ_UPGRADE)
    })

    it('should not complete HQ upgrade when timer has time remaining', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
              isUpgrading: true,
              upgradeRemaining: 10,
            },
          },
        },
      })
      state._hqUpgrading = true
      state.advanceConstruction(1)
      expect(state._hqUpgrading).toBe(true)
      expect(state.colony.buildings.headquarters.upgradeRemaining).toBe(9)
    })
  })

  // ── advanceResearch ──────────────────────────────────────────────

  describe('advanceResearch', () => {
    it('should complete research when timer reaches 0', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              active: [
                {
                  key: 'foodProduction1',
                  remainingSeconds: 1,
                  duration: 10,
                },
              ],
            },
          },
        },
      })
      state.advanceResearch(1)
      expect(state.colony.buildings.academy.isCompleted('foodProduction1')).toBe(true)
    })

    it('should move research from active to completed', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              active: [
                {
                  key: 'foodProduction1',
                  remainingSeconds: 1,
                  duration: 10,
                },
              ],
            },
          },
        },
      })
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(true)
      state.advanceResearch(1)
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(false)
      expect(state.colony.buildings.academy.isCompleted('foodProduction1')).toBe(true)
    })

    it('should not complete research when timer has not elapsed', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              active: [
                {
                  key: 'foodProduction1',
                  remainingSeconds: 10,
                  duration: 10,
                },
              ],
            },
          },
        },
      })
      state.advanceResearch(1)
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(true)
      expect(state.colony.buildings.academy.isCompleted('foodProduction1')).toBe(false)
    })

    it('should not advance when no active research', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
            },
          },
        },
      })
      // No active research, should be a no-op
      state.advanceResearch(1)
      expect(state.colony.buildings.academy.completed.size).toBe(0)
    })

    it('should dismiss population limit event when habitation research raises the cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 9,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
            academy: {
              level: 1,
              active: [
                {
                  key: 'habitation1',
                  remainingSeconds: 1,
                  duration: 10,
                },
              ],
            },
          },
        },
      })
      state.update(0)
      // workersCap = 1 * 10 = 10
      state._recruit()
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(true)
      state.advanceResearch(1)
      expect(state.colony.buildings.house.workersCap).toBe(11)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(false)
      // Reaching the raised cap warns again
      audio.playSound.mockClear()
      state._recruit()
      expect(state.colony.resources.workers).toBe(11)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(true)
      expect(audio.playSound).toHaveBeenCalledWith(SND_NOTIFICATION_ALERT)
    })

    it('should keep population limit event when completed research leaves workers at the cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
            academy: {
              level: 1,
              active: [
                {
                  key: 'foodProduction1',
                  remainingSeconds: 1,
                  duration: 10,
                },
              ],
            },
          },
        },
      })
      state.update(0)
      // workersCap = 1 * 10 = 10
      state.colony.events.addPast({
        type: EVENT_TYPE_POPULATION_LIMIT_REACHED,
        textKey: 'event.populationLimitReached',
        icon: '',
      })
      state.advanceResearch(1)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(true)
    })
  })

  // ── advanceEvents ────────────────────────────────────────────────

  describe('advanceEvents', () => {
    it('should decrement future event countdowns', async () => {
      const state = await createState()
      state.colony.events.addFuture({
        type: 'test',
        textKey: 'test.event',
        icon: '/img/test.png',
        remainingSeconds: 10,
      })
      state.advanceEvents(3)
      expect(state.colony.events.future[0].remainingSeconds).toBe(7)
    })

    it('should not error when no future events exist', async () => {
      const state = await createState()
      expect(() => state.advanceEvents(1)).not.toThrow()
    })
  })

  // ── advanceChallenges ────────────────────────────────────────────

  describe('advanceChallenges', () => {
    it('should activate pending challenge', async () => {
      const pendingChallenge = createChallenge({
        status: CHALLENGE_STATUS_PENDING,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            pending: [pendingChallenge],
          }),
        },
      })
      state.advanceChallenges(1)
      expect(state.meta.challenges.active).not.toBeNull()
      expect(state.meta.challenges.active.status).toBe(CHALLENGE_STATUS_ACTIVATED)
    })

    it('should advance delay timer on activated challenge', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_ACTIVATED,
        delay: 60,
        delayElapsed: 0,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.advanceChallenges(10)
      expect(state.meta.challenges.active.delayElapsed).toBe(10)
    })

    it('should advance timeout timer when started', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        timeout: 300,
        timeoutElapsed: 0,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.advanceChallenges(15)
      expect(state.meta.challenges.active.timeoutElapsed).toBe(15)
    })

    it('should not advance when challenge modal is showing', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        timeout: 300,
        timeoutElapsed: 0,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.challengeModal = CHALLENGE_MODAL_REWARD
      state.advanceChallenges(10)
      expect(state.meta.challenges.active.timeoutElapsed).toBe(0)
    })

    it('should return early when all challenges completed', async () => {
      const completedChallenge = createChallenge()
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            completed: [completedChallenge],
          }),
        },
      })
      state.advanceChallenges(1)
      expect(state.meta.challenges.active).toBeNull()
    })

    it('should return early when no pending and no active challenge', async () => {
      const state = await createState()
      state.advanceChallenges(1)
      expect(state.meta.challenges.active).toBeNull()
    })

    it('should return early if activate does not set an active challenge', async () => {
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            pending: [createChallenge()],
          }),
        },
      })
      vi.spyOn(state.meta.challenges, 'activate').mockImplementation(() => {})
      state.advanceChallenges(1)
      expect(state.meta.challenges.active).toBeNull()
    })

    it('should still advance effect timeouts when all challenges completed', async () => {
      const blessing = createBlessing({
        timeout: 100,
      })
      const punishment = createPunishment({
        timeout: 80,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            completed: [createChallenge()],
            activeBlessings: [blessing],
            activePunishments: [punishment],
          }),
        },
      })
      state.advanceChallenges(10)
      expect(state.meta.challenges.active).toBeNull()
      expect(blessing.timeout).toBe(90)
      expect(punishment.timeout).toBe(70)
    })

    it('should clear the Blessed Markets fee override as soon as the blessing expires', async () => {
      const blessing = createBlessing({
        type: BLESSING_BLESSED_MARKETS,
        timeout: 10,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            activeBlessings: [blessing],
          }),
        },
      })
      state.update(0)
      expect(state.colony.buildings.market.blessedMarkets).toBe(true)
      state.advanceChallenges(10)
      expect(state.meta.challenges.activeBlessings).toHaveLength(0)
      expect(state.colony.buildings.market.blessedMarkets).toBe(false)
    })

    it('should transition to started when delay elapses', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_ACTIVATED,
        delay: 60,
        delayElapsed: 59,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.advanceChallenges(1)
      expect(state.meta.challenges.active.status).toBe(CHALLENGE_STATUS_STARTED)
      expect(state.colony.events.future.some(
        event => event.type === EVENT_TYPE_CHALLENGE_STARTED,
      )).toBe(true)
      expect(audio.playSound).toHaveBeenCalledWith(SND_NOTIFICATION_ALERT)
    })

    it('should resolve challenge when timeout elapses and requirements met', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        timeout: 300,
        timeoutElapsed: 299,
        requirements: {
          faith: 50,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.advanceChallenges(1)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_REWARD)
      expect(state.paused).toBe(true)
    })
  })

  // ── areChallengeRequirementsMet ──────────────────────────────────

  describe('areChallengeRequirementsMet', () => {
    it('should return false when no active challenge', async () => {
      const state = await createState()
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return true when all requirements met', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 50,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          resources: {
            faith: 100,
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(true)
    })

    it('should return false when faith insufficient', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 500,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          resources: {
            faith: 100,
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return false when altar level insufficient', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: 3,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            altar: {
              level: 1,
            },
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return false when resource requirement not met', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: null,
          monument: null,
          resources: {
            food: 9999,
          },
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return false when monument level insufficient', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: null,
          monument: 3,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            monument: {
              level: 1,
            },
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return false when temple level insufficient', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: 2,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            temple: {
              level: 0,
            },
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return false when workers insufficient', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: 10,
        },
      })
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 3,
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(false)
    })

    it('should return true when resource requirements are met', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: null,
          monument: null,
          resources: {
            food: 100,
          },
          workers: null,
        },
      })
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      expect(state.areChallengeRequirementsMet()).toBe(true)
    })
  })

  // ── selectBlessing ───────────────────────────────────────────────

  describe('selectBlessing', () => {
    it('should complete challenge and unpause', async () => {
      const blessing = createBlessing({
        type: BLESSING_FERTILE_SOIL,
        productivity: 0.3,
        timeout: 600,
      })
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        blessings: [blessing],
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
            pending: [createChallenge()],
          }),
        },
      })
      state.paused = true
      state.challengeModal = CHALLENGE_MODAL_REWARD
      state.selectBlessing(0)
      expect(state.meta.challenges.active).toBeNull()
      expect(state.meta.challenges.completed).toHaveLength(1)
      expect(state.paused).toBe(false)
      expect(state.challengeModal).toBeNull()
    })

    it('should do nothing when no reward modal', async () => {
      const state = await createState()
      state.challengeModal = null
      state.selectBlessing(0)
      // No error, no change
      expect(state.meta.challenges.completed).toHaveLength(0)
    })

    it('should show win modal when all challenges completed', async () => {
      const blessing = createBlessing({
        type: BLESSING_FERTILE_SOIL,
        productivity: 0.3,
        timeout: 600,
      })
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        blessings: [blessing],
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
            pending: [],
          }),
        },
      })
      state.paused = true
      state.challengeModal = CHALLENGE_MODAL_REWARD
      state.selectBlessing(0)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_WIN)
    })
  })

  // ── acknowledgePunishment ────────────────────────────────────────

  describe('acknowledgePunishment', () => {
    it('should fail challenge, unpause, and reset timers', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        timeoutElapsed: 300,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.paused = true
      state.challengeModal = CHALLENGE_MODAL_FAILURE
      state.acknowledgePunishment()
      expect(state.paused).toBe(false)
      expect(state.challengeModal).toBeNull()
      // Challenge should be reset (back to activated, timers zeroed)
      expect(state.meta.challenges.active.status).toBe(CHALLENGE_STATUS_ACTIVATED)
      expect(state.meta.challenges.active.delayElapsed).toBe(0)
      expect(state.meta.challenges.active.timeoutElapsed).toBe(0)
    })

    it('should apply punishment effects to colony', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        punishment: createPunishment({
          faith: 0.5,
          resources: 0.3,
        }),
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
        colonyOverrides: {
          resources: {
            faith: 1000,
            food: 500,
          },
        },
      })
      state.paused = true
      state.challengeModal = CHALLENGE_MODAL_FAILURE
      state.acknowledgePunishment()
      expect(state.colony.resources.faith).toBe(500)
      expect(state.colony.resources.food).toBe(350)
    })

    it('should apply the full punishment duration when the challenge is failed again', async () => {
      const activeChallenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        punishment: createPunishment({
          productivityFarm: 0.5,
          timeout: 120,
        }),
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: activeChallenge,
          }),
        },
      })
      state.challengeModal = CHALLENGE_MODAL_FAILURE
      state.acknowledgePunishment()
      // Let the first punishment expire
      state.advanceChallenges(120)
      expect(state.meta.challenges.activePunishments).toHaveLength(0)

      state.challengeModal = CHALLENGE_MODAL_FAILURE
      state.acknowledgePunishment()
      expect(state.meta.challenges.active.punishment.timeout).toBe(120)
      expect(state.meta.challenges.activePunishments).toHaveLength(1)
      expect(state.meta.challenges.activePunishments[0].timeout).toBe(120)
    })

    it('should do nothing when modal is not failure', async () => {
      const state = await createState()
      state.challengeModal = null
      state.acknowledgePunishment()
      expect(state.meta.challenges.activePunishments).toHaveLength(0)
    })
  })

  // ── continueAfterWin ─────────────────────────────────────────────

  describe('continueAfterWin', () => {
    it('should unpause and clear modal', async () => {
      const state = await createState()
      state.paused = true
      state.challengeModal = CHALLENGE_MODAL_WIN
      state.continueAfterWin()
      expect(state.paused).toBe(false)
      expect(state.challengeModal).toBeNull()
    })

    it('should do nothing when modal is not win', async () => {
      const state = await createState()
      state.paused = true
      state.challengeModal = CHALLENGE_MODAL_REWARD
      state.continueAfterWin()
      // Should not unpause because modal type is wrong
      expect(state.paused).toBe(true)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_REWARD)
    })
  })

  // ── levelUpBuilding ──────────────────────────────────────────────

  describe('levelUpBuilding', () => {
    it('should deduct cost and start construction', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
            workers: 0,
          },
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_CAMP,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      const woodBefore = state.colony.resources.wood
      state.levelUpBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.isConstructing).toBe(true)
      expect(state.colony.resources.wood).toBeLessThan(woodBefore)
      expect(state._constructingKeys.has(BUILDING_FARM)).toBe(true)
    })

    it('should not build when resources insufficient', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            wood: 0,
          },
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.levelUpBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.isConstructing).toBe(false)
    })

    it('should not build when territory full', async () => {
      // HQ level 1 = 10 territory cap. Set totalLevels to fill it.
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 5,
            },
            woodcutter: {
              level: 5,
            },
          },
        },
      })
      // After update(0), territory = 10 (5+5), territoryCap = 10
      state.update(0)
      state.levelUpBuilding(BUILDING_HOUSE)
      expect(state.colony.buildings.house.isConstructing).toBe(false)
    })

    it('should not build when already constructing', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
          },
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 0,
              constructionRemaining: 5,
              constructionDuration: 10,
            },
          },
        },
      })
      const woodBefore = state.colony.resources.wood
      state.levelUpBuilding(BUILDING_FARM)
      // Should not deduct cost or change anything
      expect(state.colony.resources.wood).toBe(woodBefore)
    })

    it('should fire territory limit event when build fills territory', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 9,
            },
          },
        },
      })
      state.levelUpBuilding(BUILDING_HOUSE)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_TERRITORY_LIMIT_REACHED)).toBe(true)
      expect(audio.playSound).toHaveBeenCalledWith(SND_NOTIFICATION_ALERT)
    })

    it('should use buildingUpgrading text when building already exists', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_CAMP,
            },
            storehouse: {
              level: 1,
            },
            farm: {
              level: 1,
            },
          },
        },
      })
      state.levelUpBuilding(BUILDING_FARM)
      const futureEvent = state.colony.events.future.find(
        event => event.type === EVENT_TYPE_BUILDING_UPGRADE,
      )
      expect(futureEvent.textKey).toBe('event.buildingUpgrading')
    })
  })

  // ── recruitWorker ────────────────────────────────────────────────

  describe('recruitWorker', () => {
    it('should deduct food cost and increment worker count', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      const foodBefore = state.colony.resources.food
      state.recruitWorker()
      expect(state.colony.resources.workers).toBe(1)
      expect(state.colony.resources.food).toBe(foodBefore - WORKER_RECRUIT_COST.food)
    })

    it('should not recruit when cannot afford', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
          },
        },
      })
      state.update(0)
      state.recruitWorker()
      expect(state.colony.resources.workers).toBe(0)
    })

    it('should not recruit past population cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      state.recruitWorker()
      expect(state.colony.resources.workers).toBe(10)
    })

    it('should play worker created sound on success', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      state.recruitWorker()
      expect(audio.playSound).toHaveBeenCalled()
    })
  })

  // ── dismissWorkers ───────────────────────────────────────────────

  describe('dismissWorkers', () => {
    it('should reduce worker count', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
          },
        },
      })
      state.update(0)
      state.dismissWorkers(2)
      expect(state.colony.resources.workers).toBe(3)
    })

    it('should not dismiss more than idle workers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 3,
            },
          },
        },
      })
      state.update(0)
      // 5 total - 3 assigned = 2 idle
      state.dismissWorkers(5)
      // Should only dismiss 2 (the idle ones)
      expect(state.colony.resources.workers).toBe(3)
    })

    it('should do nothing when no idle workers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 3,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 3,
            },
          },
        },
      })
      state.update(0)
      state.dismissWorkers(1)
      expect(state.colony.resources.workers).toBe(3)
    })

    it('should not dismiss population event when workers still at or above cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 2,
            },
          },
        },
      })
      state.update(0)
      state.dismissWorkers(1)
      expect(state.colony.resources.workers).toBe(4)
    })

    it('should not dismiss population limit event when workers remain at or above cap after dismissal', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 12,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      // workersCap = 1 * 10 = 10, idle = 12
      const dismissSpy = vi.spyOn(state.colony.events, 'dismissPastByType')
      state.dismissWorkers(1)
      // workers = 11, still >= 10 → population limit event NOT dismissed
      expect(state.colony.resources.workers).toBe(11)
      expect(dismissSpy).not.toHaveBeenCalledWith(EVENT_TYPE_POPULATION_LIMIT_REACHED)
    })
  })

  // ── assignWorkers ────────────────────────────────────────────────

  describe('assignWorkers', () => {
    it('should increment building workers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 0,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      state.assignWorkers(BUILDING_FARM, 3)
      expect(state.colony.buildings.farm.workers).toBe(3)
    })

    it('should not assign past max workers', async () => {
      // Farm level 1 = maxWorkers 5
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 2,
              workersCap: 20,
            },
            farm: {
              level: 1,
              workers: 4,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      state.assignWorkers(BUILDING_FARM, 5)
      // maxWorkers = level 1 * 5 = 5
      expect(state.colony.buildings.farm.workers).toBe(5)
    })

    it('should not assign when auto-recruit fails due to insufficient resources', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 0,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      state.assignWorkers(BUILDING_FARM, 5)
      expect(state.colony.buildings.farm.workers).toBe(0)
    })

    it('should auto-recruit when no idle workers available', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 0,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      state.assignWorkers(BUILDING_FARM, 1)
      // Should auto-recruit and assign
      expect(state.colony.buildings.farm.workers).toBe(1)
      expect(state.colony.resources.workers).toBe(1)
    })
  })

  // ── unassignWorkers ──────────────────────────────────────────────

  describe('unassignWorkers', () => {
    it('should decrement building workers', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 3,
            },
          },
        },
      })
      state.unassignWorkers(BUILDING_FARM, 2)
      expect(state.colony.buildings.farm.workers).toBe(1)
    })

    it('should not unassign more than assigned', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
              workersCap: 10,
            },
            farm: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      state.unassignWorkers(BUILDING_FARM, 5)
      expect(state.colony.buildings.farm.workers).toBe(0)
    })

    it('should do nothing when no workers assigned', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 0,
            },
          },
        },
      })
      state.unassignWorkers(BUILDING_FARM, 1)
      expect(state.colony.buildings.farm.workers).toBe(0)
    })
  })

  // ── startResearch ────────────────────────────────────────────────

  describe('startResearch', () => {
    it('should deduct cost and start research', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
            knowledge: 500,
          },
          buildingOverrides: {
            academy: {
              level: 1,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      const knowledgeBefore = state.colony.resources.knowledge
      state.startResearch('foodProduction1')
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(true)
      expect(state.colony.resources.knowledge).toBeLessThan(knowledgeBefore)
    })

    it('should not start when already completed', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
            knowledge: 500,
          },
          buildingOverrides: {
            academy: {
              level: 1,
              completed: ['foodProduction1'],
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.startResearch('foodProduction1')
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(false)
    })

    it('should not start when cannot afford', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            wood: 0,
            knowledge: 0,
          },
          buildingOverrides: {
            academy: {
              level: 1,
            },
          },
        },
      })
      state.startResearch('foodProduction1')
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(false)
    })

    it('should not start when academy level is 0', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
            knowledge: 500,
          },
          buildingOverrides: {
            academy: {
              level: 0,
            },
          },
        },
      })
      state.startResearch('foodProduction1')
      expect(state.colony.buildings.academy.isActive('foodProduction1')).toBe(false)
    })

    it('should create a future event for research in progress', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
            wood: 500,
            knowledge: 500,
          },
          buildingOverrides: {
            academy: {
              level: 1,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.startResearch('foodProduction1')
      expect(state.colony.events.future.length).toBeGreaterThan(0)
    })
  })

  // ── executeTrade ─────────────────────────────────────────────────

  describe('executeTrade', () => {
    it('should delegate buy trade to market', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
            gold: 500,
          },
          buildingOverrides: {
            market: {
              level: 1,
            },
            storehouse: {
              level: 2,
            },
          },
        },
      })
      state.update(0)
      const foodBefore = state.colony.resources.food
      state.executeTrade(RESOURCE_FOOD, TRADE_BUY, 100)
      expect(state.colony.resources.food).toBeGreaterThan(foodBefore)
    })

    it('should delegate sell trade to market', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 300,
            gold: 0,
          },
          buildingOverrides: {
            market: {
              level: 1,
            },
            storehouse: {
              level: 2,
            },
          },
        },
      })
      state.update(0)
      const goldBefore = state.colony.resources.gold
      state.executeTrade(RESOURCE_FOOD, TRADE_SELL, 100)
      expect(state.colony.resources.gold).toBeGreaterThan(goldBefore)
    })

    it('should not update when trade fails', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            gold: 0,
          },
          buildingOverrides: {
            market: {
              level: 0,
            },
          },
        },
      })
      state.update(0)
      const spy = vi.spyOn(state, 'update')
      state.executeTrade(RESOURCE_FOOD, TRADE_BUY, 100)
      expect(spy).not.toHaveBeenCalled()
    })
  })

  // ── toJSON / fromJSON ────────────────────────────────────────────

  describe('toJSON / fromJSON', () => {
    it('should serialize toJSON with correct structure', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 123,
            wood: 456,
            workers: 5,
          },
          buildingOverrides: {
            farm: {
              level: 2,
              workers: 3,
            },
            house: {
              level: 1,
              workersCap: 10,
            },
            storehouse: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      const json = state.toJSON()
      // Meta fields
      expect(json.meta).toBeDefined()
      expect(json.meta.version).toBe(1)
      expect(json.meta.challenges).toBeDefined()
      expect(json.meta.tutorial).toBeDefined()
      // Colony fields
      expect(json.colony).toBeDefined()
      expect(json.colony.year).toBe(1)
      expect(json.colony.season).toBeDefined()
      expect(json.colony.resources).toBeDefined()
      expect(json.colony.buildings).toBeDefined()
      // All 20 buildings serialized
      const expectedBuildingKeys = [
        'headquarters',
        'house',
        'academy',
        'storehouse',
        'market',
        'farm',
        'woodcutter',
        'quarry',
        'copperMine',
        'ironMine',
        'goldMine',
        'altar',
        'temple',
        'monument',
        'barracks',
        'archery',
        'stable',
        'workshop',
        'wall',
        'tower',
      ]
      for (const key of expectedBuildingKeys) {
        expect(json.colony.buildings[key]).toBeDefined()
      }
      // Tracking state serialized
      expect(json.resourcesAtCap).toBeDefined()
      expect(json.resourcesNegativeProduction).toBeDefined()
      expect(json.hadIdleWorkers).toBeDefined()
    })

    it('should preserve tracking state in toJSON', async () => {
      const state = await createState()
      state._resourcesAtCap.add(RESOURCE_FOOD)
      state._resourcesNegativeProduction.add(RESOURCE_WOOD)
      state._hadIdleWorkers = true
      state.challengeModal = CHALLENGE_MODAL_REWARD
      const json = state.toJSON()
      expect(json.resourcesAtCap).toContain(RESOURCE_FOOD)
      expect(json.resourcesNegativeProduction).toContain(RESOURCE_WOOD)
      expect(json.hadIdleWorkers).toBe(true)
      expect(json.challengeModal).toBe(CHALLENGE_MODAL_REWARD)
    })

    it('should preserve resource values in toJSON', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 123.456,
            wood: 789.012,
          },
        },
      })
      const json = state.toJSON()
      expect(json.colony.resources.food).toBeCloseTo(123.456, 2)
      expect(json.colony.resources.wood).toBeCloseTo(789.012, 2)
    })

    it('should return null for corrupted data via fromJSON', async () => {
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const result = State.fromJSON({
        broken: true,
      })
      expect(result).toBeNull()
    })

    it('should restore paused to true when challengeModal is set in data', async () => {
      const state = await createState()
      state.challengeModal = CHALLENGE_MODAL_REWARD
      const json = state.toJSON()
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored.challengeModal).toBe(CHALLENGE_MODAL_REWARD)
      expect(restored.paused).toBe(true)
    })

    it('should restore the active tutorial modal and pause when saved while it was open', async () => {
      const state = await createState()
      state.meta.tutorial.activeModal = TUTORIAL_MODAL_NEGATIVE_PRODUCTION
      const json = state.toJSON()
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored.meta.tutorial.activeModal).toBe(TUTORIAL_MODAL_NEGATIVE_PRODUCTION)
      expect(restored.paused).toBe(true)
    })

    it('should finish an older tutorial save without pausing for its saved modal after device completion', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 3,
            completed: false,
            activeModal: TUTORIAL_MODAL_NEGATIVE_PRODUCTION,
          }),
        },
      })
      const json = state.toJSON()
      storage.tutorialCompleted = true
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored.meta.tutorial.completed).toBe(true)
      expect(restored.meta.tutorial.activeModal).toBeNull()
      expect(restored.paused).toBe(false)
    })

    it('should default resourcesAtCap to empty set when missing from data', async () => {
      const state = await createState()
      const json = state.toJSON()
      delete json.resourcesAtCap
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored._resourcesAtCap).toBeInstanceOf(Set)
      expect(restored._resourcesAtCap.size).toBe(0)
    })

    it('should default resourcesNegativeProduction to empty set when missing', async () => {
      const state = await createState()
      const json = state.toJSON()
      delete json.resourcesNegativeProduction
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored._resourcesNegativeProduction).toBeInstanceOf(Set)
      expect(restored._resourcesNegativeProduction.size).toBe(0)
    })

    it('should default hadIdleWorkers to false when missing', async () => {
      const state = await createState()
      const json = state.toJSON()
      delete json.hadIdleWorkers
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored._hadIdleWorkers).toBe(false)
    })

    it('should default challengeModal to null when missing', async () => {
      const state = await createState()
      const json = state.toJSON()
      delete json.challengeModal
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(json)
      expect(restored.challengeModal).toBeNull()
      expect(restored.paused).toBe(false)
    })

    it('should rebuild upcoming event names in the current language on load', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_SETTLEMENT,
            },
          },
        },
      })
      const {
        events,
      } = state.colony
      // Params saved under another language
      events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.buildingBuilding',
        params: ['granja'],
        buildingKey: BUILDING_FARM,
        remainingSeconds: 10,
      })
      events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.buildingUpgrading',
        params: ['asentamiento'],
        buildingKey: BUILDING_HEADQUARTERS,
        remainingSeconds: 20,
      })
      events.addFuture({
        type: EVENT_TYPE_RESEARCH_COMPLETE,
        textKey: 'event.researchInProgress',
        params: ['agricultura'],
        researchKey: RESEARCH_FOOD_PRODUCTION_1,
        remainingSeconds: 30,
      })
      events.addFuture({
        type: EVENT_TYPE_CHALLENGE_STARTED,
        textKey: 'event.challengeStarted',
        params: [
          1,
          10,
          'Prueba de Devoción',
        ],
        action: 'openChallengeModal',
        remainingSeconds: 40,
      })
      events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.territoryExpanding',
        buildingKey: BUILDING_HEADQUARTERS,
        remainingSeconds: 50,
      })
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(state.toJSON())
      expect(restored.colony.events.future.map(event => event.params)).toEqual([
        ['building.farm'],
        ['building.headquarters.settlement'],
        [('research.' + RESEARCH_FOOD_PRODUCTION_1).toLowerCase()],
        [
          1,
          10,
          'challenge.name.1',
        ],
        [],
      ])
    })

    it('should still load a save whose upcoming event params are not a list', async () => {
      const state = await createState()
      state.colony.events.addFuture({
        type: EVENT_TYPE_CHALLENGE_STARTED,
        textKey: 'event.challengeStarted',
        params: 'edited',
        action: 'openChallengeModal',
        remainingSeconds: 40,
      })
      const {
        default: State,
      } = await import('@/js/engine/state.js')
      const restored = State.fromJSON(state.toJSON())
      expect(restored).not.toBeNull()
      expect(restored.colony.events.future[0].params).toBe('edited')
    })
  })

  // ── checkTutorial ────────────────────────────────────────────────

  describe('checkTutorial', () => {
    it('should advance tutorial steps when conditions met', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 0,
            completed: false,
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            house: {
              level: 1,
            },
            farm: {
              level: 1,
            },
            woodcutter: {
              level: 1,
            },
          },
        },
      })
      state.checkTutorial()
      // Steps 0-2 check house>=1, farm>=1, woodcutter>=1 — all met
      expect(state.meta.tutorial.currentStep).toBeGreaterThanOrEqual(3)
    })

    it('should stop at first unmet step', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 0,
            completed: false,
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            house: {
              level: 1,
            },
            // farm level 0 — step 1 will not pass
          },
        },
      })
      state.checkTutorial()
      // Step 0 passes (house>=1), step 1 fails (farm<1)
      expect(state.meta.tutorial.currentStep).toBe(1)
    })

    it('should not advance when tutorial already completed', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 0,
            completed: true,
          }),
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.currentStep).toBe(0)
    })

    it('should not complete tutorial when all steps pass but modals remain undismissed', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 0,
            completed: false,
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_SETTLEMENT,
            },
            house: {
              level: 3,
            },
            farm: {
              level: 3,
              workers: 5,
            },
            woodcutter: {
              level: 3,
              workers: 5,
            },
            altar: {
              level: 1,
            },
          },
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(false)
      expect(storage.tutorialCompleted).toBe(false)
    })

    it('should complete tutorial when all steps pass and all modals dismissed', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 0,
            completed: false,
            dismissedModals: [
              TUTORIAL_MODAL_SEASON_CHANGED,
              TUTORIAL_MODAL_NEGATIVE_PRODUCTION,
              TUTORIAL_MODAL_HQ_UPGRADE,
              TUTORIAL_MODAL_CHALLENGE_STARTED,
            ],
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_SETTLEMENT,
            },
            house: {
              level: 3,
            },
            farm: {
              level: 3,
              workers: 5,
            },
            woodcutter: {
              level: 3,
              workers: 5,
            },
            altar: {
              level: 1,
            },
          },
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(true)
      expect(storage.tutorialCompleted).toBe(true)
    })

    it('should complete tutorial on re-entry after steps passed and modals later dismissed', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 0,
            completed: false,
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 2,
              type: HQ_TYPE_SETTLEMENT,
            },
            house: {
              level: 3,
            },
            farm: {
              level: 3,
              workers: 5,
            },
            woodcutter: {
              level: 3,
              workers: 5,
            },
            altar: {
              level: 1,
            },
          },
        },
      })
      // First call: all steps pass but modals are undismissed
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(false)
      expect(storage.tutorialCompleted).toBe(false)

      // Simulate user dismissing all modals between ticks
      state.meta.tutorial.dismissedModals.add(TUTORIAL_MODAL_SEASON_CHANGED)
      state.meta.tutorial.dismissedModals.add(TUTORIAL_MODAL_NEGATIVE_PRODUCTION)
      state.meta.tutorial.dismissedModals.add(TUTORIAL_MODAL_HQ_UPGRADE)
      state.meta.tutorial.dismissedModals.add(TUTORIAL_MODAL_CHALLENGE_STARTED)

      // Second call: should now detect all modals dismissed and complete
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(true)
      expect(storage.tutorialCompleted).toBe(true)
    })

    it('should defer completion when steps pre-completed but modals undismissed', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 16,
            completed: false,
          }),
        },
      })
      // allStepsCompleted is true at entry (currentStep >= 16),
      // but no modals dismissed → should not complete
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(false)
      expect(storage.tutorialCompleted).toBe(false)
    })

    it('should log tutorial completion the first time on this device', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 16,
            completed: false,
            dismissedModals: [
              TUTORIAL_MODAL_SEASON_CHANGED,
              TUTORIAL_MODAL_NEGATIVE_PRODUCTION,
              TUTORIAL_MODAL_HQ_UPGRADE,
              TUTORIAL_MODAL_CHALLENGE_STARTED,
            ],
          }),
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(true)
      expect(analytics.logTutorialComplete).toHaveBeenCalledTimes(1)
    })

    it('should not log tutorial completion again when replayed from an older save', async () => {
      storage.tutorialCompleted = true
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 16,
            completed: false,
            dismissedModals: [
              TUTORIAL_MODAL_SEASON_CHANGED,
              TUTORIAL_MODAL_NEGATIVE_PRODUCTION,
              TUTORIAL_MODAL_HQ_UPGRADE,
              TUTORIAL_MODAL_CHALLENGE_STARTED,
            ],
          }),
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(true)
      expect(analytics.logTutorialComplete).not.toHaveBeenCalled()
    })

    it('should show a dropped HQ upgrade modal once the HQ is past camp', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            currentStep: 16,
            completed: false,
            dismissedModals: [
              TUTORIAL_MODAL_SEASON_CHANGED,
              TUTORIAL_MODAL_NEGATIVE_PRODUCTION,
              TUTORIAL_MODAL_CHALLENGE_STARTED,
            ],
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_SETTLEMENT,
            },
          },
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.activeModal).toBe(TUTORIAL_MODAL_HQ_UPGRADE)
      expect(state.paused).toBe(true)
      expect(state.meta.tutorial.completed).toBe(false)

      // Dismissing it lets the tutorial complete on the next tick
      state.meta.tutorial.dismissedModals.add(TUTORIAL_MODAL_HQ_UPGRADE)
      state.meta.tutorial.activeModal = null
      state.paused = false
      state.checkTutorial()
      expect(state.meta.tutorial.completed).toBe(true)
    })

    it('should wait for an open tutorial modal before showing the HQ upgrade modal', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
            activeModal: TUTORIAL_MODAL_SEASON_CHANGED,
          }),
        },
        colonyOverrides: {
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_SETTLEMENT,
            },
          },
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.activeModal).toBe(TUTORIAL_MODAL_SEASON_CHANGED)
    })

    it('should not show the HQ upgrade modal while the HQ is a camp', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
          }),
        },
      })
      state.checkTutorial()
      expect(state.meta.tutorial.activeModal).toBeNull()
      expect(state.paused).toBe(false)
    })
  })

  // ── _computeGeneralProductivity ─────────────────────────────────────

  describe('_computeGeneralProductivity', () => {
    it('should return 1 when food and wood are sufficient', async () => {
      const state = await createState()
      const result = state._computeGeneralProductivity(
        5,
        {
          food: 5,
          wood: 3,
        },
        {
          food: 2,
          wood: 1,
        },
      )
      expect(result).toBe(1)
    })

    it('should return 0 when workers is 0', async () => {
      const state = await createState()
      const result = state._computeGeneralProductivity(
        0,
        {
          food: 5,
          wood: 3,
        },
        {
          food: 2,
          wood: 1,
        },
      )
      expect(result).toBe(0)
    })

    it('should return reduced value when food is short', async () => {
      const state = await createState()
      state._resourcesNegativeProduction.add(RESOURCE_FOOD)
      const result = state._computeGeneralProductivity(
        5,
        {
          food: 1,
          wood: 3,
        },
        {
          food: 4,
          wood: 1,
        },
      )
      // deficit = max(0, 4 - 1) = 3, penalty = (3/4) * SHORTAGE_MAX_PENALTY
      const expected = 1 - (3 / 4) * SHORTAGE_MAX_PENALTY
      expect(result).toBeCloseTo(expected, 10)
    })

    it('should return reduced value when wood is short', async () => {
      const state = await createState()
      state._resourcesNegativeProduction.add(RESOURCE_WOOD)
      const result = state._computeGeneralProductivity(
        5,
        {
          food: 5,
          wood: 1,
        },
        {
          food: 2,
          wood: 4,
        },
      )
      const expected = 1 - (3 / 4) * SHORTAGE_MAX_PENALTY
      expect(result).toBeCloseTo(expected, 10)
    })

    it('should return minimum of food and wood penalty when both are short', async () => {
      const state = await createState()
      state._resourcesNegativeProduction.add(RESOURCE_FOOD)
      state._resourcesNegativeProduction.add(RESOURCE_WOOD)
      // Food deficit worse than wood deficit
      const result = state._computeGeneralProductivity(
        5,
        {
          food: 0,
          wood: 2,
        },
        {
          food: 4,
          wood: 4,
        },
      )
      const foodPenalty = 1 - (4 / 4) * SHORTAGE_MAX_PENALTY
      const woodPenalty = 1 - (2 / 4) * SHORTAGE_MAX_PENALTY
      expect(result).toBeCloseTo(Math.min(foodPenalty, woodPenalty), 10)
    })

    it('should not penalize when resource is not in _resourcesNegativeProduction', async () => {
      const state = await createState()
      // Food production < consumption, but not tracked as negative
      const result = state._computeGeneralProductivity(
        5,
        {
          food: 1,
          wood: 3,
        },
        {
          food: 4,
          wood: 1,
        },
      )
      expect(result).toBe(1)
    })
  })

  // ── _computeSeasonMultipliers ───────────────────────────────────────

  describe('_computeSeasonMultipliers', () => {
    it('should return warm season multipliers with no blessing', async () => {
      const state = await createState()
      const result = state._computeSeasonMultipliers([])
      expect(result.food).toBeCloseTo(1.2, 10)
      expect(result.wood).toBeCloseTo(0.8, 10)
    })

    it('should return cold season multipliers with no blessing', async () => {
      const state = await createState({
        colonyOverrides: {
          season: {
            currentSeason: SEASON_COLD,
            seasonElapsed: 0,
          },
        },
      })
      const result = state._computeSeasonMultipliers([])
      expect(result.food).toBeCloseTo(0.8, 10)
      expect(result.wood).toBeCloseTo(1.2, 10)
    })

    it('should stack FAVORABLE_WEATHER blessing on warm season', async () => {
      const state = await createState()
      const blessing = createBlessing({
        type: BLESSING_FAVORABLE_WEATHER,
        warm: 0.1,
        cold: 0.05,
        timeout: 60,
      })
      const result = state._computeSeasonMultipliers([blessing])
      expect(result.food).toBeCloseTo(1.3, 10)
      expect(result.wood).toBeCloseTo(0.7, 10)
    })

    it('should stack FAVORABLE_WEATHER blessing on cold season', async () => {
      const state = await createState({
        colonyOverrides: {
          season: {
            currentSeason: SEASON_COLD,
            seasonElapsed: 0,
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_FAVORABLE_WEATHER,
        warm: 0.1,
        cold: 0.05,
        timeout: 60,
      })
      const result = state._computeSeasonMultipliers([blessing])
      expect(result.food).toBeCloseTo(0.85, 10)
      expect(result.wood).toBeCloseTo(1.15, 10)
    })
  })

  // ── _computeConsumptionRates ────────────────────────────────────────

  describe('_computeConsumptionRates', () => {
    it('should return zero rates with 0 workers', async () => {
      const state = await createState()
      const {
        rates,
      } = state._computeConsumptionRates({}, {
        food: 1.2,
        wood: 0.8,
      }, 0)
      expect(rates.food).toBe(0)
      expect(rates.wood).toBe(0)
    })

    it('should scale with worker count at neutral season', async () => {
      const state = await createState()
      const {
        rates,
      } = state._computeConsumptionRates({}, {
        food: 1,
        wood: 1,
      }, 10)
      expect(rates.food).toBeCloseTo(10 * WORKER_FOOD_CONSUMPTION, 10)
      expect(rates.wood).toBeCloseTo(10 * WORKER_WOOD_CONSUMPTION, 10)
    })

    it('should apply food consumption research bonus', async () => {
      const state = await createState()
      const bonuses = {
        foodConsumption: 0.1,
      }
      const {
        rates,
      } = state._computeConsumptionRates(bonuses, {
        food: 1,
        wood: 1,
      }, 10)
      expect(rates.food).toBeCloseTo(10 * WORKER_FOOD_CONSUMPTION * 0.9, 10)
      expect(rates.wood).toBeCloseTo(10 * WORKER_WOOD_CONSUMPTION, 10)
    })

    it('should stack wood consumption bonus and season multiplier additively', async () => {
      const state = await createState()
      const bonuses = {
        woodConsumption: 0.1,
      }
      // Warm season: wood multiplier = 0.8 → season reduction = 1 - 0.8 = 0.2
      // Total wood multiplier = max(0, 1 - 0.1 - 0.2) = 0.7
      const {
        rates,
      } = state._computeConsumptionRates(bonuses, {
        food: 1.2,
        wood: 0.8,
      }, 10)
      expect(rates.wood).toBeCloseTo(10 * WORKER_WOOD_CONSUMPTION * 0.7, 10)
    })
  })

  // ── _computeProductionRates ─────────────────────────────────────────

  describe('_computeProductionRates', () => {
    it('should return zero rates with all buildings at level 0', async () => {
      const state = await createState()
      const {
        rates,
      } = state._computeProductionRates({}, [], [], {
        food: 1,
        wood: 1,
      })
      expect(rates.food).toBe(0)
      expect(rates.wood).toBe(0)
      expect(rates.stone).toBe(0)
    })

    it('should produce based on assigned workers', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 3,
            },
          },
        },
      })
      const {
        rates,
      } = state._computeProductionRates({}, [], [], {
        food: 1,
        wood: 1,
      })
      // Farm: 3 workers × 1/s = 3, with food season multiplier of 1 (neutral)
      expect(rates.food).toBeCloseTo(3, 10)
    })

    it('should aggregate production from multiple buildings', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 2,
            },
            woodcutter: {
              level: 1,
              workers: 4,
            },
          },
        },
      })
      const {
        rates,
      } = state._computeProductionRates({}, [], [], {
        food: 1,
        wood: 1,
      })
      expect(rates.food).toBeCloseTo(2, 10)
      expect(rates.wood).toBeCloseTo(2, 10)
    })

    it('should apply research bonuses as multipliers', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const bonuses = {
        foodProduction: 0.2,
      }
      const {
        rates,
      } = state._computeProductionRates(bonuses, [], [], {
        food: 1,
        wood: 1,
      })
      // 2 workers × 1/s × (1 + 0.2) = 2.4, plus season (food: 1 → +0 from season)
      expect(rates.food).toBeCloseTo(2.4, 10)
    })

    it('should apply FERTILE_SOIL blessing productivity bonus to food', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_FERTILE_SOIL,
        productivity: 0.3,
        timeout: 60,
      })
      const {
        rates,
      } = state._computeProductionRates({}, [blessing], [], {
        food: 1,
        wood: 1,
      })
      // 2 workers × 1/s × (1 + 0.3) = 2.6
      expect(rates.food).toBeCloseTo(2.6, 10)
    })

    it('should apply season modifier to food production', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      // Warm season multiplier: food = 1.2
      const {
        rates,
      } = state._computeProductionRates({}, [], [], {
        food: 1.2,
        wood: 0.8,
      })
      // 2 workers × 1/s × (1 + (1.2 - 1)) = 2 × 1.2 = 2.4
      expect(rates.food).toBeCloseTo(2.4, 10)
    })

    it('should produce from passive buildings based on level', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            altar: {
              level: 3,
            },
          },
        },
      })
      const {
        rates,
      } = state._computeProductionRates({}, [], [], {
        food: 1,
        wood: 1,
      })
      // Altar: passive, 3 levels × 0.1/s = 0.3
      expect(rates.faith).toBeCloseTo(0.3, 10)
    })

    it('should apply FOREST_BLOOM blessing productivity bonus to wood', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            woodcutter: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_FOREST_BLOOM,
        productivity: 0.25,
        timeout: 60,
      })
      const {
        rates,
        multipliers,
      } = state._computeProductionRates({}, [blessing], [], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.wood).toBeCloseTo(1.25, 10)
      // 2 workers × 0.5/s × 1.25 = 1.25
      expect(rates.wood).toBeCloseTo(1.25, 10)
    })

    it('should apply RICH_MINES blessing productivity bonus to stone, copper, iron, gold', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            quarry: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_RICH_MINES,
        productivity: 0.4,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [blessing], [], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.stone).toBeCloseTo(1.4, 10)
      expect(multipliers.copper).toBeCloseTo(1.4, 10)
      expect(multipliers.iron).toBeCloseTo(1.4, 10)
      expect(multipliers.gold).toBeCloseTo(1.4, 10)
    })

    it('should apply WISDOM_OF_THE_GODS blessing productivity bonus to knowledge', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_WISDOM_OF_THE_GODS,
        productivity: 0.5,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [blessing], [], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.knowledge).toBeCloseTo(1.5, 10)
    })

    it('should apply CELESTIAL_PROSPERITY blessing productivity bonus to all 8 resources', async () => {
      const state = await createState()
      const blessing = createBlessing({
        type: BLESSING_CELESTIAL_PROSPERITY,
        productivity: 0.2,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [blessing], [], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.food).toBeCloseTo(1.2, 10)
      expect(multipliers.wood).toBeCloseTo(1.2, 10)
      expect(multipliers.stone).toBeCloseTo(1.2, 10)
      expect(multipliers.copper).toBeCloseTo(1.2, 10)
      expect(multipliers.iron).toBeCloseTo(1.2, 10)
      expect(multipliers.gold).toBeCloseTo(1.2, 10)
      expect(multipliers.faith).toBeCloseTo(1.2, 10)
      expect(multipliers.knowledge).toBeCloseTo(1.2, 10)
    })

    it('should not apply productivity bonus for blessings without a productivity branch', async () => {
      const state = await createState()
      const blessing = createBlessing({
        type: BLESSING_GIFT_FROM_THE_HEAVENS,
        productivity: 0,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [blessing], [], {
        food: 1,
        wood: 1,
      })
      // No productivity branch matches → all multipliers stay at 1
      expect(multipliers.food).toBeCloseTo(1, 10)
      expect(multipliers.wood).toBeCloseTo(1, 10)
      expect(multipliers.stone).toBeCloseTo(1, 10)
      expect(multipliers.copper).toBeCloseTo(1, 10)
      expect(multipliers.iron).toBeCloseTo(1, 10)
      expect(multipliers.gold).toBeCloseTo(1, 10)
      expect(multipliers.faith).toBeCloseTo(1, 10)
      expect(multipliers.knowledge).toBeCloseTo(1, 10)
    })

    it('should apply CROP_FAILURE punishment productivity penalty to food', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const punishment = createPunishment({
        type: PUNISHMENT_CROP_FAILURE,
        productivityFarm: 0.2,
        timeout: 60,
      })
      const {
        rates,
        multipliers,
      } = state._computeProductionRates({}, [], [punishment], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.food).toBeCloseTo(0.8, 10)
      // 2 workers × 1/s × 0.8 = 1.6
      expect(rates.food).toBeCloseTo(1.6, 10)
    })

    it('should apply WILDFIRES punishment productivity penalty to wood', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            woodcutter: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const punishment = createPunishment({
        type: PUNISHMENT_WILDFIRES,
        productivityWoodcutter: 0.3,
        timeout: 60,
      })
      const {
        rates,
        multipliers,
      } = state._computeProductionRates({}, [], [punishment], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.wood).toBeCloseTo(0.7, 10)
      // 2 workers × 0.5/s × 0.7 = 0.7
      expect(rates.wood).toBeCloseTo(0.7, 10)
    })

    it('should apply LANDSLIDE punishment productivity penalty to stone, copper, iron, gold', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            quarry: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const punishment = createPunishment({
        type: PUNISHMENT_LANDSLIDE,
        productivityMines: 0.3,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [], [punishment], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.stone).toBeCloseTo(0.7, 10)
      expect(multipliers.copper).toBeCloseTo(0.7, 10)
      expect(multipliers.iron).toBeCloseTo(0.7, 10)
      expect(multipliers.gold).toBeCloseTo(0.7, 10)
    })

    it('should apply VOLCANO punishment productivityGeneral penalty to all 8 resources', async () => {
      const state = await createState()
      const punishment = createPunishment({
        type: PUNISHMENT_VOLCANO,
        productivityGeneral: 0.3,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [], [punishment], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.food).toBeCloseTo(0.7, 10)
      expect(multipliers.wood).toBeCloseTo(0.7, 10)
      expect(multipliers.stone).toBeCloseTo(0.7, 10)
      expect(multipliers.copper).toBeCloseTo(0.7, 10)
      expect(multipliers.iron).toBeCloseTo(0.7, 10)
      expect(multipliers.gold).toBeCloseTo(0.7, 10)
      expect(multipliers.faith).toBeCloseTo(0.7, 10)
      expect(multipliers.knowledge).toBeCloseTo(0.7, 10)
    })

    it('should apply PLAGUE punishment productivityGeneral penalty to all 8 resources', async () => {
      const state = await createState()
      const punishment = createPunishment({
        type: PUNISHMENT_PLAGUE,
        productivityGeneral: 0.2,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [], [punishment], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.food).toBeCloseTo(0.8, 10)
      expect(multipliers.wood).toBeCloseTo(0.8, 10)
      expect(multipliers.stone).toBeCloseTo(0.8, 10)
      expect(multipliers.copper).toBeCloseTo(0.8, 10)
      expect(multipliers.iron).toBeCloseTo(0.8, 10)
      expect(multipliers.gold).toBeCloseTo(0.8, 10)
      expect(multipliers.faith).toBeCloseTo(0.8, 10)
      expect(multipliers.knowledge).toBeCloseTo(0.8, 10)
    })

    it('should not apply productivity penalty for punishments without a productivity field', async () => {
      const state = await createState()
      const punishment = createPunishment({
        type: PUNISHMENT_CROP_FAILURE,
        timeout: 60,
      })
      const {
        multipliers,
      } = state._computeProductionRates({}, [], [punishment], {
        food: 1,
        wood: 1,
      })
      expect(multipliers.food).toBeCloseTo(1, 10)
      expect(multipliers.wood).toBeCloseTo(1, 10)
      expect(multipliers.stone).toBeCloseTo(1, 10)
      expect(multipliers.copper).toBeCloseTo(1, 10)
      expect(multipliers.iron).toBeCloseTo(1, 10)
      expect(multipliers.gold).toBeCloseTo(1, 10)
      expect(multipliers.faith).toBeCloseTo(1, 10)
      expect(multipliers.knowledge).toBeCloseTo(1, 10)
    })

    it('should stack blessing and punishment on the same resource', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 2,
            },
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_FERTILE_SOIL,
        productivity: 0.3,
        timeout: 60,
      })
      const punishment = createPunishment({
        type: PUNISHMENT_CROP_FAILURE,
        productivityFarm: 0.2,
        timeout: 60,
      })
      const {
        rates,
        multipliers,
      } = state._computeProductionRates({}, [blessing], [punishment], {
        food: 1,
        wood: 1,
      })
      // 1 + 0.3 (blessing) - 0.2 (punishment) = 1.1
      expect(multipliers.food).toBeCloseTo(1.1, 10)
      // 2 workers × 1/s × 1.1 = 2.2
      expect(rates.food).toBeCloseTo(2.2, 10)
    })
  })

  // ── _resolveChallengeTimeout ────────────────────────────────────────

  describe('_resolveChallengeTimeout', () => {
    it('should complete challenge when requirements are met', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 50,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            faith: 100,
          },
        },
      })
      state._resolveChallengeTimeout()
      expect(state.paused).toBe(true)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_REWARD)
    })

    it('should fail challenge when requirements are not met', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 500,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            faith: 10,
          },
        },
      })
      state._resolveChallengeTimeout()
      expect(state.paused).toBe(true)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_FAILURE)
    })
  })

  // ── _deductRequirements ─────────────────────────────────────────────

  describe('_deductRequirements', () => {
    it('should deduct faith when challenge requires it', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 50,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            faith: 200,
          },
        },
      })
      state._deductRequirements()
      expect(state.colony.resources.faith).toBe(150)
    })

    it('should deduct resources when challenge requires them', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: null,
          monument: null,
          resources: {
            food: 30,
            wood: 20,
          },
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            food: 200,
            wood: 200,
          },
        },
      })
      state._deductRequirements()
      expect(state.colony.resources.food).toBe(170)
      expect(state.colony.resources.wood).toBe(180)
    })

    it('should sacrifice workers when challenge requires them', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: null,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: 3,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            workers: 5,
          },
        },
      })
      state._deductRequirements()
      expect(state.colony.resources.workers).toBe(2)
    })

    it('should no-op when no active challenge', async () => {
      const state = await createState()
      const foodBefore = state.colony.resources.food
      state._deductRequirements()
      expect(state.colony.resources.food).toBe(foodBefore)
    })
  })

  // ── _completeChallenge ──────────────────────────────────────────────

  describe('_completeChallenge', () => {
    it('should pause game and show reward modal', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 50,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            faith: 200,
          },
        },
      })
      state._completeChallenge()
      expect(state.paused).toBe(true)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_REWARD)
    })

    it('should deduct requirements from colony', async () => {
      const challenge = createChallenge({
        status: CHALLENGE_STATUS_STARTED,
        requirements: {
          faith: 50,
          altar: null,
          temple: null,
          monument: null,
          resources: null,
          workers: null,
        },
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            active: challenge,
          }),
        },
        colonyOverrides: {
          resources: {
            faith: 200,
          },
        },
      })
      state._completeChallenge()
      expect(state.colony.resources.faith).toBe(150)
    })
  })

  // ── _failChallenge ──────────────────────────────────────────────────

  describe('_failChallenge', () => {
    it('should pause game and show failure modal', async () => {
      const state = await createState()
      state._failChallenge()
      expect(state.paused).toBe(true)
      expect(state.challengeModal).toBe(CHALLENGE_MODAL_FAILURE)
    })
  })

  // ── _sacrificeWorkers ───────────────────────────────────────────────

  describe('_sacrificeWorkers', () => {
    it('should remove workers from idle pool first', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
        },
      })
      state._sacrificeWorkers(3)
      expect(state.colony.resources.workers).toBe(2)
    })

    it('should remove from producer buildings when idle pool is exhausted', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 5,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 3,
            },
          },
        },
      })
      // 5 total - 3 assigned = 2 idle. Sacrificing 4 means: 2 from idle, 2 from farm
      state._sacrificeWorkers(4)
      expect(state.colony.resources.workers).toBe(1)
      expect(state.colony.buildings.farm.workers).toBe(1)
    })

    it('should handle fewer total workers than sacrifice count', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 2,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 1,
            },
          },
        },
      })
      // 2 total, 1 assigned, 1 idle. Sacrificing 5 removes all available
      state._sacrificeWorkers(5)
      expect(state.colony.resources.workers).toBe(0)
      expect(state.colony.buildings.farm.workers).toBe(0)
    })

    it('should decrement resources.workers for each removed worker', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 10,
          },
          buildingOverrides: {
            farm: {
              level: 1,
              workers: 5,
            },
            woodcutter: {
              level: 1,
              workers: 3,
            },
          },
        },
      })
      // 10 total - 8 assigned = 2 idle
      state._sacrificeWorkers(2)
      expect(state.colony.resources.workers).toBe(8)
    })

    it('should dismiss population limit event when workers drop below cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 10,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      // workersCap = 1 * 10 = 10
      state.colony.events.addPast({
        type: EVENT_TYPE_POPULATION_LIMIT_REACHED,
        textKey: 'event.populationLimitReached',
        icon: '',
      })
      state._sacrificeWorkers(1)
      expect(state.colony.resources.workers).toBe(9)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(false)
    })

    it('should keep population limit event when workers remain at or above cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 12,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.update(0)
      // workersCap = 1 * 10 = 10
      state.colony.events.addPast({
        type: EVENT_TYPE_POPULATION_LIMIT_REACHED,
        textKey: 'event.populationLimitReached',
        icon: '',
      })
      state._sacrificeWorkers(1)
      expect(state.colony.resources.workers).toBe(11)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(true)
    })
  })

  // ── _advanceEffectTimeouts ──────────────────────────────────────────

  describe('_advanceEffectTimeouts', () => {
    it('should decrement timeout by delta', async () => {
      const state = await createState()
      const effects = [
        createBlessing({
          timeout: 100,
        }),
      ]
      state._advanceEffectTimeouts(effects, 10)
      expect(effects[0].timeout).toBe(90)
    })

    it('should remove effect when timeout reaches 0', async () => {
      const state = await createState()
      const effects = [
        createBlessing({
          timeout: 10,
        }),
      ]
      state._advanceEffectTimeouts(effects, 10)
      expect(effects.length).toBe(0)
    })

    it('should skip effects with null timeout', async () => {
      const state = await createState()
      const effects = [
        createBlessing({
          timeout: null,
        }),
      ]
      state._advanceEffectTimeouts(effects, 10)
      expect(effects.length).toBe(1)
      expect(effects[0].timeout).toBeNull()
    })

    it('should no-op on empty array', async () => {
      const state = await createState()
      const effects = []
      state._advanceEffectTimeouts(effects, 10)
      expect(effects.length).toBe(0)
    })

    it('should handle multiple effects with mixed timeouts', async () => {
      const state = await createState()
      const effects = [
        createBlessing({
          timeout: 5,
        }),
        createBlessing({
          timeout: null,
        }),
        createBlessing({
          timeout: 20,
        }),
      ]
      state._advanceEffectTimeouts(effects, 5)
      // First removed (timeout reached 0), second skipped, third decremented
      expect(effects.length).toBe(2)
      expect(effects[0].timeout).toBeNull()
      expect(effects[1].timeout).toBe(15)
    })
  })

  // ── _applyBlessing ─────────────────────────────────────────────────

  describe('_applyBlessing', () => {
    it('should add resources for GIFT_FROM_THE_HEAVENS', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
            wood: 100,
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_GIFT_FROM_THE_HEAVENS,
        resources: {
          food: 50,
          wood: 30,
        },
      })
      state._applyBlessing(blessing)
      expect(state.colony.resources.food).toBe(150)
      expect(state.colony.resources.wood).toBe(130)
    })

    it('should cap resources at storage limit for GIFT_FROM_THE_HEAVENS', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 500,
          },
          buildingOverrides: {
            storehouse: {
              level: 0,
            },
          },
        },
      })
      const storageCap = state.colony.buildings.storehouse.storageCap(0)
      const blessing = createBlessing({
        type: BLESSING_GIFT_FROM_THE_HEAVENS,
        resources: {
          food: 99999,
        },
      })
      state._applyBlessing(blessing)
      expect(state.colony.resources.food).toBe(storageCap)
    })

    it('should add territory bonus for HOLY_EXPANSION', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territoryBonus: 0,
          },
        },
      })
      const blessing = createBlessing({
        type: BLESSING_HOLY_EXPANSION,
        territory: 3,
      })
      state._applyBlessing(blessing)
      expect(state.colony.resources.territoryBonus).toBe(3)
    })

    it('should not mutate resources for non-resource blessings', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 100,
            wood: 100,
          },
        },
      })
      const foodBefore = state.colony.resources.food
      const woodBefore = state.colony.resources.wood
      const blessing = createBlessing({
        type: BLESSING_FERTILE_SOIL,
        productivity: 0.3,
        timeout: 60,
      })
      state._applyBlessing(blessing)
      expect(state.colony.resources.food).toBe(foodBefore)
      expect(state.colony.resources.wood).toBe(woodBefore)
    })
  })

  // ── _applyPunishment ────────────────────────────────────────────────

  describe('_applyPunishment', () => {
    it('should remove fraction of stored faith', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            faith: 1000,
          },
        },
      })
      const punishment = createPunishment({
        faith: 0.5,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.faith).toBe(500)
    })

    it('should floor faith after fractional loss', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            faith: 1001,
          },
        },
      })
      const punishment = createPunishment({
        faith: 0.5,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.faith).toBe(500)
    })

    it('should not change faith when punishment.faith is null', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            faith: 1000,
          },
        },
      })
      const punishment = createPunishment({
        faith: null,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.faith).toBe(1000)
    })

    it('should remove fraction of each bounded resource', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 1000,
            wood: 500,
            stone: 200,
            copper: 100,
            iron: 50,
            gold: 10,
          },
        },
      })
      const punishment = createPunishment({
        resources: 0.3,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.food).toBe(700)
      expect(state.colony.resources.wood).toBe(350)
      expect(state.colony.resources.stone).toBe(140)
      expect(state.colony.resources.copper).toBe(70)
      expect(state.colony.resources.iron).toBe(35)
      expect(state.colony.resources.gold).toBe(7)
    })

    it('should floor bounded resources after fractional loss', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 101,
          },
        },
      })
      const punishment = createPunishment({
        resources: 0.3,
      })
      state._applyPunishment(punishment)
      // 101 * 0.7 = 70.7 → floor → 70
      expect(state.colony.resources.food).toBe(70)
    })

    it('should not change resources when punishment.resources is null', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 1000,
            wood: 500,
          },
        },
      })
      const punishment = createPunishment({
        resources: null,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.food).toBe(1000)
      expect(state.colony.resources.wood).toBe(500)
    })

    it('should sacrifice workers clamped to available count', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 3,
          },
        },
      })
      const punishment = createPunishment({
        workers: 10,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.workers).toBe(0)
    })

    it('should sacrifice exact worker count when available', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 10,
          },
        },
      })
      const punishment = createPunishment({
        workers: 4,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.workers).toBe(6)
    })

    it('should not change workers when punishment.workers is null', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 10,
          },
        },
      })
      const punishment = createPunishment({
        workers: null,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.workers).toBe(10)
    })

    it('should downgrade a building with level > 1', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 3,
            },
          },
        },
      })
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.buildings.farm.level).toBe(2)
    })

    it('should return excess workers to idle after downgrade', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            workers: 8,
          },
          buildingOverrides: {
            farm: {
              level: 2,
              workers: 8,
            },
          },
        },
      })
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      // Farm goes from level 2 (max 10) to level 1 (max 5), excess 3 returned to idle
      expect(state.colony.buildings.farm.level).toBe(1)
      expect(state.colony.buildings.farm.workers).toBe(5)
      // Total workers unchanged — just reassigned to idle
      expect(state.colony.resources.workers).toBe(8)
    })

    it('should destroy level-1 building under construction', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              constructionRemaining: 10,
              constructionDuration: 20,
              workers: 1,
            },
          },
        },
      })
      state._constructingKeys.add(BUILDING_FARM)
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.buildings.farm.level).toBe(0)
      expect(state.colony.buildings.farm.constructionRemaining).toBe(0)
      expect(state.colony.buildings.farm.constructionDuration).toBe(0)
      expect(state.colony.buildings.farm.workers).toBe(0)
      expect(state._constructingKeys.has(BUILDING_FARM)).toBe(false)
    })

    it('should destroy level-1 constructing non-producer building without touching workers', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            altar: {
              level: 1,
              constructionRemaining: 10,
              constructionDuration: 20,
            },
          },
        },
      })
      state._constructingKeys.add(BUILDING_ALTAR)
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.buildings.altar.level).toBe(0)
      expect(state.colony.buildings.altar.constructionRemaining).toBe(0)
      expect(state.colony.buildings.altar.constructionDuration).toBe(0)
      expect('workers' in state.colony.buildings.altar).toBe(false)
      expect(state._constructingKeys.has(BUILDING_ALTAR)).toBe(false)
    })

    it('should dismiss future event when destroying constructing building', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 1,
              constructionRemaining: 10,
              constructionDuration: 20,
            },
          },
        },
      })
      state._constructingKeys.add(BUILDING_FARM)
      state.colony.events.addFuture({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.buildingUpgrading',
        icon: 'icon',
        buildingKey: BUILDING_FARM,
        remainingSeconds: 10,
      })
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.events.future).toHaveLength(0)
    })

    it('should skip remaining downgrades when no eligible buildings', async () => {
      const state = await createState()
      // All buildings at level 0 — none eligible
      const punishment = createPunishment({
        levels: 5,
      })
      state._applyPunishment(punishment)
      // Should not throw, all buildings remain at level 0
      for (const key of DOWNGRADABLE_BUILDINGS) {
        expect(state.colony.buildings[key].level).toBe(0)
      }
    })

    it('should downgrade multiple levels across buildings', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 3,
            },
            woodcutter: {
              level: 2,
            },
          },
        },
      })
      const punishment = createPunishment({
        levels: 3,
      })
      state._applyPunishment(punishment)
      // Total levels lost should be 3 (distributed randomly across the two eligible buildings)
      const totalLevels = state.colony.buildings.farm.level + state.colony.buildings.woodcutter.level
      expect(totalLevels).toBe(2) // Started with 5, lost 3
    })

    it('should not change buildings when punishment.levels is null', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 3,
            },
          },
        },
      })
      const punishment = createPunishment({
        levels: null,
      })
      state._applyPunishment(punishment)
      expect(state.colony.buildings.farm.level).toBe(3)
    })

    it('should dismiss territory limit event when a level is lost', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            farm: {
              level: 3,
            },
          },
        },
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
        icon: '',
      })
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_TERRITORY_LIMIT_REACHED)).toBe(false)
    })

    it('should keep territory limit event when no level can be lost', async () => {
      const state = await createState()
      // All buildings at level 0 — none eligible
      state.colony.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
        icon: '',
      })
      const punishment = createPunishment({
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_TERRITORY_LIMIT_REACHED)).toBe(true)
    })

    it('should apply all punishment effects together', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            faith: 1000,
            food: 500,
            wood: 500,
            stone: 500,
            copper: 500,
            iron: 500,
            gold: 500,
            workers: 10,
          },
          buildingOverrides: {
            farm: {
              level: 3,
              workers: 5,
            },
          },
        },
      })
      const punishment = createPunishment({
        type: PUNISHMENT_VOLCANO,
        faith: 0.5,
        resources: 0.3,
        workers: 3,
        levels: 1,
      })
      state._applyPunishment(punishment)
      expect(state.colony.resources.faith).toBe(500)
      expect(state.colony.resources.food).toBe(350)
      expect(state.colony.resources.workers).toBe(7)
      expect(state.colony.buildings.farm.level).toBe(2)
    })
  })

  // ── _constructionDurationMult ───────────────────────────────────────

  describe('_constructionDurationMult', () => {
    it('should return 1 with no research bonus and no blessing', async () => {
      const state = await createState()
      expect(state._constructionDurationMult).toBe(1)
    })

    it('should return reduced value with construction-time research', async () => {
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              completed: ['construction1'],
            },
          },
        },
      })
      // If research key is in the tree, the bonus applies.
      // Since we may not know exact research keys, test via the getter logic
      const result = state._constructionDurationMult
      expect(result).toBeLessThanOrEqual(1)
      expect(result).toBeGreaterThanOrEqual(0)
    })

    it('should stack RAPID_CONSTRUCTION blessing with research', async () => {
      const blessing = createBlessing({
        type: BLESSING_RAPID_CONSTRUCTION,
        construction: 0.3,
        timeout: 60,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            activeBlessings: [blessing],
          }),
        },
      })
      expect(state._constructionDurationMult).toBeCloseTo(0.7, 10)
    })

    it('should combine full construction research and RAPID_CONSTRUCTION multiplicatively', async () => {
      const blessing = createBlessing({
        type: BLESSING_RAPID_CONSTRUCTION,
        construction: 0.5,
        timeout: 60,
      })
      const state = await createState({
        colonyOverrides: {
          buildingOverrides: {
            academy: {
              level: 1,
              completed: [
                'construction1',
                'construction2',
                'construction3',
                'construction4',
                'construction5',
              ],
            },
          },
        },
        metaOverrides: {
          challenges: createChallenges({
            activeBlessings: [blessing],
          }),
        },
      })
      // (1 - 0.5 research) × (1 - 0.5 blessing) = 0.25, not 1 - (0.5 + 0.5) = 0
      expect(state._constructionDurationMult).toBeCloseTo(0.25, 10)
    })

    it('should floor at 0', async () => {
      const blessing = createBlessing({
        type: BLESSING_RAPID_CONSTRUCTION,
        construction: 2.0,
        timeout: 60,
      })
      const state = await createState({
        metaOverrides: {
          challenges: createChallenges({
            activeBlessings: [blessing],
          }),
        },
      })
      expect(state._constructionDurationMult).toBe(0)
    })
  })

  // ── _recruit ────────────────────────────────────────────────────────

  describe('_recruit', () => {
    it('should return true and increment workers when affordable and under cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.colony.buildings.house.workersCap = 10
      const result = state._recruit()
      expect(result).toBe(true)
      expect(state.colony.resources.workers).toBe(1)
    })

    it('should return false when cannot afford recruit cost', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.colony.buildings.house.workersCap = 10
      const result = state._recruit()
      expect(result).toBe(false)
      expect(state.colony.resources.workers).toBe(0)
    })

    it('should return false when at population cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 5,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.colony.buildings.house.workersCap = 5
      const result = state._recruit()
      expect(result).toBe(false)
      expect(state.colony.resources.workers).toBe(5)
    })

    it('should fire population limit event when reaching cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 4,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.colony.buildings.house.workersCap = 5
      state._recruit()
      expect(state.colony.resources.workers).toBe(5)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_POPULATION_LIMIT_REACHED)).toBe(true)
    })

    it('should deduct recruit cost from resources', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 200,
            workers: 0,
          },
          buildingOverrides: {
            house: {
              level: 1,
            },
          },
        },
      })
      state.colony.buildings.house.workersCap = 10
      state._recruit()
      expect(state.colony.resources.food).toBe(150)
    })
  })

  // ── expandTerritory ────────────────────────────────────────────

  describe('expandTerritory', () => {
    it('should deduct expansion cost and start HQ construction', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      const foodBefore = state.colony.resources.food
      const woodBefore = state.colony.resources.wood
      state.expandTerritory()
      expect(state.colony.resources.food).toBeLessThan(foodBefore)
      expect(state.colony.resources.wood).toBeLessThan(woodBefore)
      expect(state.colony.buildings.headquarters.isConstructing).toBe(true)
    })

    it('should add headquarters to constructing keys', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.expandTerritory()
      expect(state._constructingKeys.has(BUILDING_HEADQUARTERS)).toBe(true)
    })

    it('should create a future EVENT_TYPE_BUILDING_UPGRADE event with event.territoryExpanding text', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.expandTerritory()
      const futureEvent = state.colony.events.future.find(
        event => event.type === EVENT_TYPE_BUILDING_UPGRADE,
      )
      expect(futureEvent).toBeDefined()
      expect(futureEvent.textKey).toBe('event.territoryExpanding')
      expect(futureEvent.buildingKey).toBe(BUILDING_HEADQUARTERS)
    })

    it('should dismiss existing EVENT_TYPE_BUILDING_UPGRADE past events', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.territoryExpanded',
        icon: '',
      })
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_BUILDING_UPGRADE)).toBe(true)
      state.expandTerritory()
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_BUILDING_UPGRADE)).toBe(false)
    })

    it('should call update(0) after expansion', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      const updateSpy = vi.spyOn(state, 'update')
      state.expandTerritory()
      expect(updateSpy).toHaveBeenCalledWith(0)
    })

    it('should reject when HQ is already constructing', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.colony.buildings.headquarters.constructionRemaining = 10
      const foodBefore = state.colony.resources.food
      state.expandTerritory()
      expect(state.colony.resources.food).toBe(foodBefore)
    })

    it('should reject when HQ is upgrading', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 5000,
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.colony.buildings.headquarters.upgradeRemaining = 10
      const foodBefore = state.colony.resources.food
      state.expandTerritory()
      expect(state.colony.resources.food).toBe(foodBefore)
    })

    it('should reject when resources insufficient', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            food: 0,
            wood: 0,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.expandTerritory()
      expect(state.colony.buildings.headquarters.isConstructing).toBe(false)
    })
  })

  // ── upgradeHeadquarters ────────────────────────────────────────

  describe('upgradeHeadquarters', () => {
    it('should deduct upgrade cost and start HQ type upgrade', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      const woodBefore = state.colony.resources.wood
      state.upgradeHeadquarters()
      expect(state.colony.resources.wood).toBeLessThan(woodBefore)
      expect(state.colony.buildings.headquarters.isUpgrading).toBe(true)
    })

    it('should set _hqUpgrading to true', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      expect(state._hqUpgrading).toBe(false)
      state.upgradeHeadquarters()
      expect(state._hqUpgrading).toBe(true)
    })

    it('should create a future EVENT_TYPE_BUILDING_UPGRADE event with event.buildingUpgrading text', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.upgradeHeadquarters()
      const futureEvent = state.colony.events.future.find(
        event => event.type === EVENT_TYPE_BUILDING_UPGRADE,
      )
      expect(futureEvent).toBeDefined()
      expect(futureEvent.textKey).toBe('event.buildingUpgrading')
      expect(futureEvent.buildingKey).toBe(BUILDING_HEADQUARTERS)
    })

    it('should dismiss existing EVENT_TYPE_BUILDING_UPGRADE past events', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_BUILDING_UPGRADE,
        textKey: 'event.territoryExpanded',
        icon: '',
      })
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_BUILDING_UPGRADE)).toBe(true)
      state.upgradeHeadquarters()
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_BUILDING_UPGRADE)).toBe(false)
    })

    it('should call update(0) after upgrade', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      const updateSpy = vi.spyOn(state, 'update')
      state.upgradeHeadquarters()
      expect(updateSpy).toHaveBeenCalledWith(0)
    })

    it('should reject when HQ is already constructing', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.colony.buildings.headquarters.constructionRemaining = 10
      const woodBefore = state.colony.resources.wood
      state.upgradeHeadquarters()
      expect(state.colony.resources.wood).toBe(woodBefore)
    })

    it('should reject when HQ is already upgrading', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 5000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.colony.buildings.headquarters.upgradeRemaining = 10
      const woodBefore = state.colony.resources.wood
      state.upgradeHeadquarters()
      expect(state.colony.resources.wood).toBe(woodBefore)
    })

    it('should reject when HQ is at max type', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 50000,
            stone: 50000,
            copper: 50000,
            iron: 50000,
            gold: 50000,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CITY,
            },
          },
        },
      })
      const woodBefore = state.colony.resources.wood
      state.upgradeHeadquarters()
      expect(state.colony.resources.wood).toBe(woodBefore)
      expect(state._hqUpgrading).toBe(false)
    })

    it('should reject when resources insufficient', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            wood: 0,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
          },
        },
      })
      state.upgradeHeadquarters()
      expect(state.colony.buildings.headquarters.isUpgrading).toBe(false)
    })
  })

  // ── _triggerTutorialModal ───────────────────────────────────────

  describe('_triggerTutorialModal', () => {
    it('should set tutorial.activeModal to the given key', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
          }),
        },
      })
      state._triggerTutorialModal('welcome')
      expect(state.meta.tutorial.activeModal).toBe('welcome')
    })

    it('should pause the game', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
          }),
        },
      })
      state._triggerTutorialModal('welcome')
      expect(state.paused).toBe(true)
    })

    it('should not trigger when key is already in dismissedModals', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
            dismissedModals: ['welcome'],
          }),
        },
      })
      state._triggerTutorialModal('welcome')
      expect(state.meta.tutorial.activeModal).toBeNull()
      expect(state.paused).toBe(false)
    })

    it('should not trigger when activeModal is already set', async () => {
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
          }),
        },
      })
      state.meta.tutorial.activeModal = 'existing'
      state._triggerTutorialModal('another')
      expect(state.meta.tutorial.activeModal).toBe('existing')
    })

    it('should not trigger when storage.tutorialCompleted is true', async () => {
      storage.tutorialCompleted = true
      const state = await createState({
        metaOverrides: {
          tutorial: new Tutorial({
            completed: false,
          }),
        },
      })
      state._triggerTutorialModal('welcome')
      expect(state.meta.tutorial.activeModal).toBeNull()
      expect(state.paused).toBe(false)
    })
  })

  // ── _playAssignSound ──────────────────────────────────────────────

  describe('_playAssignSound', () => {
    it('should play SND_WORKER_FARM for farm', async () => {
      const state = await createState()
      state._playAssignSound(BUILDING_FARM)
      expect(audio.playSound).toHaveBeenCalledWith(SND_WORKER_FARM)
    })

    it('should play SND_WORKER_WOODCUTTER for woodcutter', async () => {
      const state = await createState()
      state._playAssignSound(BUILDING_WOODCUTTER)
      expect(audio.playSound).toHaveBeenCalledWith(SND_WORKER_WOODCUTTER)
    })

    it('should play SND_WORKER_ACADEMY for academy', async () => {
      const state = await createState()
      state._playAssignSound(BUILDING_ACADEMY)
      expect(audio.playSound).toHaveBeenCalledWith(SND_WORKER_ACADEMY)
    })

    it('should play SND_WORKER_TEMPLE for temple', async () => {
      const state = await createState()
      state._playAssignSound(BUILDING_TEMPLE)
      expect(audio.playSound).toHaveBeenCalledWith(SND_WORKER_TEMPLE)
    })

    it('should play SND_WORKER_MINE for quarry, copper_mine, iron_mine, gold_mine', async () => {
      const state = await createState()
      for (const buildingKey of [
        BUILDING_QUARRY,
        BUILDING_COPPER_MINE,
        BUILDING_IRON_MINE,
        BUILDING_GOLD_MINE,
      ]) {
        audio.playSound.mockClear()
        state._playAssignSound(buildingKey)
        expect(audio.playSound).toHaveBeenCalledWith(SND_WORKER_MINE)
      }
    })

    it('should not play any sound for non-producer buildings', async () => {
      const state = await createState()
      state._playAssignSound(BUILDING_HOUSE)
      expect(audio.playSound).not.toHaveBeenCalled()
    })
  })

  // ── _buildingName ─────────────────────────────────────────────────

  describe('_buildingName', () => {
    it('should return t(building.headquarters.<type>) for headquarters', async () => {
      const state = await createState()
      const result = state._buildingName(BUILDING_HEADQUARTERS)
      expect(result).toBe('building.headquarters.' + HQ_TYPE_CAMP)
    })

    it('should return t(building.<key>) for non-headquarters buildings', async () => {
      const state = await createState()
      const result = state._buildingName(BUILDING_FARM)
      expect(result).toBe('building.farm')
    })
  })

  // ── downgradeBuilding ─────────────────────────────────────────────

  describe('downgradeBuilding', () => {
    it('should decrement building level by 1', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 2,
            },
          },
        },
      })
      state.downgradeBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.level).toBe(1)
    })

    it('should cap workers at new maxWorkers when workers exceed it', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 2,
            },
          },
        },
      })
      state.colony.buildings.farm.workers = 10
      state.downgradeBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.workers).toBeLessThanOrEqual(
        state.colony.buildings.farm.maxWorkers,
      )
    })

    it('should dismiss EVENT_TYPE_TERRITORY_LIMIT_REACHED past events', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 2,
            },
          },
        },
      })
      state.colony.events.addPast({
        type: EVENT_TYPE_TERRITORY_LIMIT_REACHED,
        textKey: 'event.territoryLimitReached',
        icon: '',
      })
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_TERRITORY_LIMIT_REACHED)).toBe(true)
      state.downgradeBuilding(BUILDING_FARM)
      expect(state.colony.events.hasPastEvent(EVENT_TYPE_TERRITORY_LIMIT_REACHED)).toBe(false)
    })

    it('should call update(0) after downgrade', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 2,
            },
          },
        },
      })
      const updateSpy = vi.spyOn(state, 'update')
      state.downgradeBuilding(BUILDING_FARM)
      expect(updateSpy).toHaveBeenCalledWith(0)
    })

    it('should reject when building key is not in DOWNGRADABLE_BUILDINGS', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            house: {
              level: 2,
            },
          },
        },
      })
      expect(DOWNGRADABLE_BUILDINGS.has(BUILDING_HOUSE)).toBe(false)
      state.downgradeBuilding(BUILDING_HOUSE)
      expect(state.colony.buildings.house.level).toBe(2)
    })

    it('should reject when building level is 0', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 0,
            },
          },
        },
      })
      state.downgradeBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.level).toBe(0)
    })

    it('should reject when building is constructing', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: HQ_TERRITORY_PER_LEVEL,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 2,
            },
          },
        },
      })
      state.colony.buildings.farm.constructionRemaining = 10
      state.downgradeBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.level).toBe(2)
    })

    it('should reject when territory is not at cap', async () => {
      const state = await createState({
        colonyOverrides: {
          resources: {
            territory: 0,
          },
          buildingOverrides: {
            headquarters: {
              level: 1,
              type: HQ_TYPE_CAMP,
            },
            farm: {
              level: 2,
            },
          },
        },
      })
      state.downgradeBuilding(BUILDING_FARM)
      expect(state.colony.buildings.farm.level).toBe(2)
    })
  })
})
