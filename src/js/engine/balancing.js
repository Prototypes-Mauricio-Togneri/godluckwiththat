// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, game_state.js, and
// UI components.

import {HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/constants.js'
import Cost from '@/js/models/cost.js'

// ── Building Upgrades ─────────────────────────────────────────────
// Per-building upgrade config: base cost, exponential multiplier, and build time.
// cost: base resource cost (used in levelUpCost formulas)
// multiplier: exponential scaling factor per level
//   HQ (starts at level 1): floor(cost × multiplier^(level-1))
//   Others (start at level 0): floor(cost × multiplier^level)
// buildTime: construction duration in seconds (base + perLevel × currentLevel)
export const BUILDING_UPGRADES = {
  headquarters: {
    cost: {
      food: 15,
      wood: 20,
    },
    multiplier: 2.5,
    buildTime: {
      base: 5,
      perLevel: 3,
    },
  },
  house: {
    cost: {
      wood: 30,
    },
    multiplier: 1.5,
    buildTime: {
      base: 3,
      perLevel: 2,
    },
  },
  academy: {
    cost: {
      wood: 60,
      stone: 30,
    },
    multiplier: 1.5,
    buildTime: {
      base: 5,
      perLevel: 3,
    },
  },
  storehouse: {
    cost: {
      wood: 80,
      stone: 40,
    },
    multiplier: 1.5,
    buildTime: {
      base: 5,
      perLevel: 3,
    },
  },
  market: {
    cost: {
      wood: 150,
      stone: 75,
    },
    multiplier: 1.5,
    buildTime: {
      base: 8,
      perLevel: 4,
    },
  },
  farm: {
    cost: {
      wood: 10,
    },
    multiplier: 1.5,
    buildTime: {
      base: 3,
      perLevel: 2,
    },
  },
  woodcutter: {
    cost: {
      wood: 10,
    },
    multiplier: 1.5,
    buildTime: {
      base: 3,
      perLevel: 2,
    },
  },
  quarry: {
    cost: {
      wood: 45,
    },
    multiplier: 1.5,
    buildTime: {
      base: 4,
      perLevel: 2,
    },
  },
  copperMine: {
    cost: {
      wood: 70,
      stone: 35,
    },
    multiplier: 1.5,
    buildTime: {
      base: 5,
      perLevel: 3,
    },
  },
  ironMine: {
    cost: {
      wood: 100,
      stone: 50,
    },
    multiplier: 1.5,
    buildTime: {
      base: 6,
      perLevel: 3,
    },
  },
  goldMine: {
    cost: {
      wood: 140,
      stone: 70,
    },
    multiplier: 1.5,
    buildTime: {
      base: 8,
      perLevel: 4,
    },
  },
  altar: {
    cost: {
      wood: 40,
    },
    multiplier: 1.5,
    buildTime: {
      base: 4,
      perLevel: 2,
    },
  },
  shrine: {
    cost: {
      wood: 50,
      stone: 25,
    },
    multiplier: 1.5,
    buildTime: {
      base: 5,
      perLevel: 3,
    },
  },
  temple: {
    cost: {
      wood: 90,
      stone: 50,
    },
    multiplier: 1.5,
    buildTime: {
      base: 6,
      perLevel: 3,
    },
  },
  monument: {
    cost: {
      wood: 120,
      stone: 60,
    },
    multiplier: 1.5,
    buildTime: {
      base: 7,
      perLevel: 4,
    },
  },
  barracks: {
    cost: {
      wood: 55,
      stone: 25,
    },
    multiplier: 1.5,
    buildTime: {
      base: 5,
      perLevel: 3,
    },
  },
  archery: {
    cost: {
      wood: 75,
      stone: 40,
    },
    multiplier: 1.5,
    buildTime: {
      base: 6,
      perLevel: 3,
    },
  },
  stable: {
    cost: {
      wood: 110,
      stone: 55,
    },
    multiplier: 1.5,
    buildTime: {
      base: 7,
      perLevel: 4,
    },
  },
  workshop: {
    cost: {
      wood: 160,
      stone: 80,
    },
    multiplier: 1.5,
    buildTime: {
      base: 8,
      perLevel: 4,
    },
  },
  wall: {
    cost: {
      wood: 100,
      stone: 50,
    },
    multiplier: 1.5,
    buildTime: {
      base: 6,
      perLevel: 3,
    },
  },
  tower: {
    cost: {
      wood: 150,
      stone: 75,
    },
    multiplier: 1.5,
    buildTime: {
      base: 8,
      perLevel: 4,
    },
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

// Build time for HQ type upgrade (seconds, keyed by current type being upgraded FROM)
export const HQ_UPGRADE_BUILD_TIMES = {
  [HQ_TYPE_CAMP]: 10,
  [HQ_TYPE_SETTLEMENT]: 15,
  [HQ_TYPE_VILLAGE]: 20,
  [HQ_TYPE_TOWN]: 30,
}
