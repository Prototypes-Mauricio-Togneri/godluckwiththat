import {BLESSING_FERTILE_SOIL, CHALLENGE_STATUS_PENDING, HQ_TYPE_CAMP, PUNISHMENT_CROP_FAILURE, SEASON_WARM} from '@/js/engine/enums.js'
import Blessing from '@/js/models/blessing.js'
import Challenge from '@/js/models/challenge.js'
import Challenges from '@/js/models/challenges.js'
import Cost from '@/js/models/cost.js'
import Punishment from '@/js/models/punishment.js'
import Resources from '@/js/models/resources.js'
import Season from '@/js/models/season.js'
import Tutorial from '@/js/models/tutorial.js'
import Building from '@/js/models/buildings/building.js'
import Headquarters from '@/js/models/buildings/headquarters.js'
import Producer from '@/js/models/buildings/producer.js'

export function createCost(overrides = {}) {
  return new Cost(overrides)
}

export function createResources(overrides = {}) {
  return new Resources({
    territory: 0,
    territoryBonus: 0,
    workers: 0,
    food: 100,
    wood: 100,
    stone: 100,
    copper: 100,
    iron: 100,
    gold: 100,
    faith: 100,
    knowledge: 100,
    ...overrides,
  })
}

export function createSeason(overrides = {}) {
  return new Season({
    currentSeason: SEASON_WARM,
    seasonElapsed: 0,
    ...overrides,
  })
}

export function createBuilding(overrides = {}) {
  return new Building({
    level: 1,
    ...overrides,
  })
}

export function createProducer(overrides = {}) {
  return new Producer({
    level: 1,
    workers: 0,
    ...overrides,
  })
}

export function createHeadquarters(overrides = {}) {
  return new Headquarters({
    level: 1,
    type: HQ_TYPE_CAMP,
    ...overrides,
  })
}

export function createBlessing(overrides = {}) {
  return new Blessing({
    type: BLESSING_FERTILE_SOIL,
    ...overrides,
  })
}

export function createPunishment(overrides = {}) {
  return new Punishment({
    type: PUNISHMENT_CROP_FAILURE,
    ...overrides,
  })
}

export function createChallenge(overrides = {}) {
  return new Challenge({
    index: 1,
    status: CHALLENGE_STATUS_PENDING,
    delay: 60,
    timeout: 300,
    requirements: {
      faith: 100,
    },
    blessings: [createBlessing()],
    punishment: createPunishment(),
    ...overrides,
  })
}

export function createChallenges(overrides = {}) {
  return new Challenges({
    pending: [],
    active: null,
    completed: [],
    activeBlessings: [],
    activePunishments: [],
    ...overrides,
  })
}

export function createTutorial(overrides) {
  return new Tutorial(overrides)
}
