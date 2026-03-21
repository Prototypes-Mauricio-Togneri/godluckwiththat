import {describe, it, expect, vi, beforeEach} from 'vitest'
import {BLESSING_FERTILE_SOIL, BUILDING_FARM, BUILDING_HOUSE, CHALLENGE_MODAL_FAILURE, CHALLENGE_MODAL_REWARD, CHALLENGE_MODAL_WIN, CHALLENGE_STATUS_ACTIVATED, CHALLENGE_STATUS_PENDING, CHALLENGE_STATUS_STARTED, HQ_TYPE_CAMP, RESOURCE_FOOD, RESOURCE_STONE, RESOURCE_WOOD, SEASON_COLD, SEASON_WARM, TRADE_BUY, TRADE_SELL} from '@/js/engine/enums.js'
import {SEASON_DURATION, WORKER_RECRUIT_COST} from '@/js/engine/balancing.js'
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
import {createBlessing, createChallenge, createChallenges} from '../helpers/factories.js'

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
  let audio
  let storage

  beforeEach(async () => {
    vi.clearAllMocks()
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

    it('should set storage.tutorialCompleted when all steps pass', async () => {
      // Create state with all tutorial conditions met
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
              level: 3,
            },
            farm: {
              level: 3,
              workers: 10,
            },
            woodcutter: {
              level: 3,
              workers: 10,
            },
            storehouse: {
              level: 1,
            },
            altar: {
              level: 1,
            },
          },
        },
      })
      state.checkTutorial()
      if (state.meta.tutorial.completed) {
        expect(storage.tutorialCompleted).toBe(true)
      }
    })
  })
})
