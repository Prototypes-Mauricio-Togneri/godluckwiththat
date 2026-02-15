// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, game_state.js, and
// UI components.

import {BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_SHRINE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TEMPLE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP, HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'

// ── Build Time ──────────────────────────────────────────────────────
// Time weight per resource unit (seconds). Used by Cost.toSeconds() to
// derive construction duration from resource costs.
export const RESOURCE_TIME_WEIGHTS = {
  [RESOURCE_FOOD]: 0.2,
  [RESOURCE_WOOD]: 0.4,
  [RESOURCE_STONE]: 0.6,
  [RESOURCE_COPPER]: 0.8,
  [RESOURCE_IRON]: 1,
  [RESOURCE_GOLD]: 1.2,
  [RESOURCE_KNOWLEDGE]: 1.4,
}

// ── Building Upgrades ─────────────────────────────────────────────
// Per-building upgrade config: base cost and exponential cost multiplier.
// cost: base resource cost (used in levelUpCost formulas)
// multiplier: exponential scaling factor per level
export const BUILDING_UPGRADES = {
  [BUILDING_HEADQUARTERS]: {
    cost: new Cost({
      food: 15,
      wood: 20,
    }),
    multiplier: 2.5,
  },
  [BUILDING_HOUSE]: {
    cost: new Cost({
      wood: 10,
    }),
    multiplier: 1.5,
  },
  [BUILDING_ACADEMY]: {
    cost: new Cost({
      wood: 60,
      stone: 30,
    }),
    multiplier: 1.5,
  },
  [BUILDING_STOREHOUSE]: {
    cost: new Cost({
      wood: 80,
      stone: 40,
    }),
    multiplier: 1.5,
  },
  [BUILDING_MARKET]: {
    cost: new Cost({
      wood: 150,
      stone: 75,
    }),
    multiplier: 1.5,
  },
  [BUILDING_FARM]: {
    cost: new Cost({
      wood: 5,
    }),
    multiplier: 1.5,
  },
  [BUILDING_WOODCUTTER]: {
    cost: new Cost({
      wood: 5,
    }),
    multiplier: 1.5,
  },
  [BUILDING_QUARRY]: {
    cost: new Cost({
      wood: 45,
    }),
    multiplier: 1.5,
  },
  [BUILDING_COPPER_MINE]: {
    cost: new Cost({
      wood: 70,
      stone: 35,
    }),
    multiplier: 1.5,
  },
  [BUILDING_IRON_MINE]: {
    cost: new Cost({
      wood: 100,
      stone: 50,
    }),
    multiplier: 1.5,
  },
  [BUILDING_GOLD_MINE]: {
    cost: new Cost({
      wood: 140,
      stone: 70,
    }),
    multiplier: 1.5,
  },
  [BUILDING_ALTAR]: {
    cost: new Cost({
      wood: 40,
    }),
    multiplier: 1.5,
  },
  [BUILDING_SHRINE]: {
    cost: new Cost({
      wood: 50,
      stone: 25,
    }),
    multiplier: 1.5,
  },
  [BUILDING_TEMPLE]: {
    cost: new Cost({
      wood: 90,
      stone: 50,
    }),
    multiplier: 1.5,
  },
  [BUILDING_MONUMENT]: {
    cost: new Cost({
      wood: 120,
      stone: 60,
    }),
    multiplier: 1.5,
  },
  [BUILDING_BARRACKS]: {
    cost: new Cost({
      wood: 55,
      stone: 25,
    }),
    multiplier: 1.5,
  },
  [BUILDING_ARCHERY]: {
    cost: new Cost({
      wood: 75,
      stone: 40,
    }),
    multiplier: 1.5,
  },
  [BUILDING_STABLE]: {
    cost: new Cost({
      wood: 110,
      stone: 55,
    }),
    multiplier: 1.5,
  },
  [BUILDING_WORKSHOP]: {
    cost: new Cost({
      wood: 160,
      stone: 80,
    }),
    multiplier: 1.5,
  },
  [BUILDING_WALL]: {
    cost: new Cost({
      wood: 100,
      stone: 50,
    }),
    multiplier: 1.5,
  },
  [BUILDING_TOWER]: {
    cost: new Cost({
      wood: 150,
      stone: 75,
    }),
    multiplier: 1.5,
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
  [BUILDING_FARM]: {
    resource: RESOURCE_FOOD,
    rate: 1,
  },
  [BUILDING_WOODCUTTER]: {
    resource: RESOURCE_WOOD,
    rate: 0.5,
  },
  [BUILDING_QUARRY]: {
    resource: RESOURCE_STONE,
    rate: 0.3,
  },
  [BUILDING_COPPER_MINE]: {
    resource: RESOURCE_COPPER,
    rate: 0.2,
  },
  [BUILDING_IRON_MINE]: {
    resource: RESOURCE_IRON,
    rate: 0.1,
  },
  [BUILDING_GOLD_MINE]: {
    resource: RESOURCE_GOLD,
    rate: 0.05,
  },
  [BUILDING_ACADEMY]: {
    resource: RESOURCE_KNOWLEDGE,
    rate: 0.1,
  },
  [BUILDING_SHRINE]: {
    resource: RESOURCE_FAITH,
    rate: 0.15,
  },
  [BUILDING_ALTAR]: {
    resource: RESOURCE_FAITH,
    rate: 0.1,
    passive: true,
  },
}

// ── Population & Workers ────────────────────────────────────────────

// House population cap: level × perLevel
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

// ── Stockpile ───────────────────────────────────────────────────────

// Storehouse resource capacity: base + level × perLevel
export const STOREHOUSE_BASE_CAPACITY = 500
export const STOREHOUSE_CAPACITY_PER_LEVEL = 500

// ── Territory ───────────────────────────────────────────────────────

// HQ territory capacity: level × perLevel
export const HQ_TERRITORY_PER_LEVEL = 10

// ── Seasons ─────────────────────────────────────────────────────────

// Duration of each season in seconds (warm / cold)
export const SEASON_DURATION = 300 // 5 minutes

// Fractional modifier applied to food production per season
export const SEASON_WARM_FOOD_MODIFIER = 0.2
export const SEASON_COLD_FOOD_MODIFIER = -0.2

// Fractional modifier applied to wood consumption per season
export const SEASON_WARM_WOOD_MODIFIER = -0.2
export const SEASON_COLD_WOOD_MODIFIER = 0.2
