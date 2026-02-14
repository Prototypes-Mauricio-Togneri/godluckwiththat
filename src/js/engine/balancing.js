// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, game_state.js, and
// UI components.

import {HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/constants.js'
import Cost from '@/js/models/cost.js'

// ── Build Time ──────────────────────────────────────────────────────
// Time weight per resource unit (seconds). Used by Cost.toSeconds() to
// derive construction duration from resource costs.
export const RESOURCE_TIME_WEIGHTS = {
  [RESOURCE_FOOD]: 1,
  [RESOURCE_WOOD]: 2,
  [RESOURCE_STONE]: 3,
  [RESOURCE_COPPER]: 4,
  [RESOURCE_IRON]: 5,
  [RESOURCE_GOLD]: 6,
  [RESOURCE_KNOWLEDGE]: 7,
}

// ── Building Upgrades ─────────────────────────────────────────────
// Per-building upgrade config: base cost and exponential cost multiplier.
// cost: base resource cost (used in levelUpCost formulas)
// costMultiplier: exponential scaling factor per level
//   HQ (starts at level 1): floor(cost × costMultiplier^(level-1))
//   Others (start at level 0): floor(cost × costMultiplier^level)
export const BUILDING_UPGRADES = {
  headquarters: {
    cost: {
      food: 15,
      wood: 20,
    },
    costMultiplier: 2.5,
  },
  house: {
    cost: {
      wood: 10,
    },
    costMultiplier: 1.5,
  },
  academy: {
    cost: {
      wood: 60,
      stone: 30,
    },
    costMultiplier: 1.5,
  },
  storehouse: {
    cost: {
      wood: 80,
      stone: 40,
    },
    costMultiplier: 1.5,
  },
  market: {
    cost: {
      wood: 150,
      stone: 75,
    },
    costMultiplier: 1.5,
  },
  farm: {
    cost: {
      wood: 5,
    },
    costMultiplier: 1.5,
  },
  woodcutter: {
    cost: {
      wood: 5,
    },
    costMultiplier: 1.5,
  },
  quarry: {
    cost: {
      wood: 45,
    },
    costMultiplier: 1.5,
  },
  copperMine: {
    cost: {
      wood: 70,
      stone: 35,
    },
    costMultiplier: 1.5,
  },
  ironMine: {
    cost: {
      wood: 100,
      stone: 50,
    },
    costMultiplier: 1.5,
  },
  goldMine: {
    cost: {
      wood: 140,
      stone: 70,
    },
    costMultiplier: 1.5,
  },
  altar: {
    cost: {
      wood: 40,
    },
    costMultiplier: 1.5,
  },
  shrine: {
    cost: {
      wood: 50,
      stone: 25,
    },
    costMultiplier: 1.5,
  },
  temple: {
    cost: {
      wood: 90,
      stone: 50,
    },
    costMultiplier: 1.5,
  },
  monument: {
    cost: {
      wood: 120,
      stone: 60,
    },
    costMultiplier: 1.5,
  },
  barracks: {
    cost: {
      wood: 55,
      stone: 25,
    },
    costMultiplier: 1.5,
  },
  archery: {
    cost: {
      wood: 75,
      stone: 40,
    },
    costMultiplier: 1.5,
  },
  stable: {
    cost: {
      wood: 110,
      stone: 55,
    },
    costMultiplier: 1.5,
  },
  workshop: {
    cost: {
      wood: 160,
      stone: 80,
    },
    costMultiplier: 1.5,
  },
  wall: {
    cost: {
      wood: 100,
      stone: 50,
    },
    costMultiplier: 1.5,
  },
  tower: {
    cost: {
      wood: 150,
      stone: 75,
    },
    costMultiplier: 1.5,
  },
}

// Resource cost to upgrade HQ type (keyed by type)
export const HQ_UPGRADE_COSTS = {
  [HQ_TYPE_CAMP]: new Cost({
    wood: 500,
  }),
  [HQ_TYPE_SETTLEMENT]: new Cost({
    wood: 1000,
    stone: 500,
    copper: 100,
  }),
  [HQ_TYPE_VILLAGE]: new Cost({
    wood: 5000,
    stone: 2000,
    copper: 1000,
    iron: 500,
  }),
  [HQ_TYPE_TOWN]: new Cost({
    wood: 10000,
    stone: 5000,
    copper: 2000,
    iron: 1000,
    gold: 500,
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

// ── Worker Upkeep ─────────────────────────────────────────────────────

// Resource consumed per worker per second
export const WORKER_FOOD_CONSUMPTION = 0.1
export const WORKER_WOOD_CONSUMPTION = 0.1
export const MAX_WORKER_DEATHS_PER_TICK = 1

// ── Stockpile ───────────────────────────────────────────────────────

// Storehouse resource capacity: base + level × perLevel
export const STOREHOUSE_BASE_CAPACITY = 500
export const STOREHOUSE_CAPACITY_PER_LEVEL = 500

// ── Territory ───────────────────────────────────────────────────────

// HQ territory capacity: level × perLevel
export const HQ_TERRITORY_PER_LEVEL = 10

// ── Seasons ─────────────────────────────────────────────────────────

// Duration of each season in seconds (warm / cold)
export const SEASON_DURATION = 120

// Fractional modifier applied to food production per season
export const SEASON_WARM_FOOD_MODIFIER = 0.2
export const SEASON_COLD_FOOD_MODIFIER = -0.2

// Fractional modifier applied to wood consumption per season
export const SEASON_WARM_WOOD_MODIFIER = -0.2
export const SEASON_COLD_WOOD_MODIFIER = 0.2
