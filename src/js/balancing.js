// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, game_state.js, and
// UI components.

import {HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/constants.js'
import Cost from '@/js/models/cost.js'

// ── Building Base Costs ─────────────────────────────────────────────

// Base resource cost per building (used in levelUpCost formulas)
export const BUILDING_BASE_COSTS = {
  headquarters: {
    wood: 20,
  },
  house: {
    wood: 30,
  },
  academy: {
    wood: 60,
    stone: 30,
  },
  storehouse: {
    wood: 80,
    stone: 40,
  },
  market: {
    wood: 150,
    stone: 75,
  },
  farm: {
    wood: 10,
  },
  woodcutter: {
    wood: 10,
  },
  quarry: {
    wood: 45,
    stone: 20,
  },
  copperMine: {
    wood: 70,
    stone: 35,
  },
  ironMine: {
    wood: 100,
    stone: 50,
  },
  goldMine: {
    wood: 140,
    stone: 70,
  },
  altar: {
    wood: 40,
  },
  shrine: {
    wood: 50,
    stone: 25,
  },
  temple: {
    wood: 90,
    stone: 50,
  },
  monument: {
    wood: 120,
    stone: 60,
  },
  barracks: {
    wood: 55,
    stone: 25,
  },
  archery: {
    wood: 75,
    stone: 40,
  },
  stable: {
    wood: 110,
    stone: 55,
  },
  workshop: {
    wood: 160,
    stone: 80,
  },
  wall: {
    wood: 100,
    stone: 50,
  },
  tower: {
    wood: 150,
    stone: 75,
  },
}

// ── Level-Up Multipliers ────────────────────────────────────────────

// Exponential multiplier per building for level-up cost:
//   HQ (starts at level 1): floor(base × multiplier^(level-1))
//   Others (start at level 0): floor(base × multiplier^level)
export const BUILDING_LEVEL_UP_MULTIPLIERS = {
  headquarters: 2.5,
  house: 1.5,
  academy: 1.5,
  storehouse: 1.5,
  market: 1.5,
  farm: 1.5,
  woodcutter: 1.5,
  quarry: 1.5,
  copperMine: 1.5,
  ironMine: 1.5,
  goldMine: 1.5,
  altar: 1.5,
  shrine: 1.5,
  temple: 1.5,
  monument: 1.5,
  barracks: 1.5,
  archery: 1.5,
  stable: 1.5,
  workshop: 1.5,
  wall: 1.5,
  tower: 1.5,
}

// Resource cost to upgrade HQ type (keyed by type)
export const HQ_UPGRADE_COSTS = {
  [HQ_TYPE_CAMP]: new Cost({
    wood: 200,
    stone: 100,
  }),
  [HQ_TYPE_SETTLEMENT]: new Cost({
    wood: 500,
    stone: 250,
    copper: 100,
  }),
  [HQ_TYPE_VILLAGE]: new Cost({
    wood: 1000,
    stone: 500,
    copper: 250,
    iron: 100,
  }),
  [HQ_TYPE_TOWN]: new Cost({
    wood: 2000,
    stone: 1000,
    copper: 500,
    iron: 250,
    gold: 100,
  }),
}

// ── Production ──────────────────────────────────────────────────────

// Base production rates per worker per second (building key → resource + rate)
export const PRODUCTION_RATES = {
  farm: {
    resource: RESOURCE_FOOD,
    rate: 0.5,
  },
  woodcutter: {
    resource: RESOURCE_WOOD,
    rate: 0.3,
  },
  quarry: {
    resource: RESOURCE_STONE,
    rate: 0.2,
  },
  copperMine: {
    resource: RESOURCE_COPPER,
    rate: 0.15,
  },
  ironMine: {
    resource: RESOURCE_IRON,
    rate: 0.1,
  },
  goldMine: {
    resource: RESOURCE_GOLD,
    rate: 0.05,
  },
  academy: {
    resource: RESOURCE_KNOWLEDGE,
    rate: 0.1,
  },
  shrine: {
    resource: RESOURCE_FAITH,
    rate: 0.15,
  },
  altar: {
    resource: RESOURCE_FAITH,
    rate: 0.1,
    passive: true,
  },
}

// ── Population & Workers ────────────────────────────────────────────

// House population cap: base + level × perLevel
export const HOUSE_BASE_POPULATION = 5
export const HOUSE_POPULATION_PER_LEVEL = 5

// Number of worker slots gained per building level
export const WORKERS_PER_LEVEL = 5

// Worker recruitment cost (always food)
export const WORKER_RECRUIT_COST = new Cost({
  food: 50,
})

// ── Stockpile ───────────────────────────────────────────────────────

// Storehouse resource capacity: base + level × perLevel
export const STOREHOUSE_BASE_CAPACITY = 100
export const STOREHOUSE_CAPACITY_PER_LEVEL = 100

// ── Territory ───────────────────────────────────────────────────────

// HQ territory capacity: level × perLevel
export const HQ_TERRITORY_PER_LEVEL = 10
