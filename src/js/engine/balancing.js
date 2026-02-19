// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, game_state.js, and
// UI components.

import {BONUS_CONSTRUCTION_TIME, BONUS_DISEASE_IMPACT, BONUS_EARTHQUAKE_IMPACT, BONUS_EXPANSION_COST, BONUS_FAITH_PRODUCTION, BONUS_FLOOD_IMPACT, BONUS_FOOD_CONSUMPTION, BONUS_FOOD_PRODUCTION, BONUS_KNOWLEDGE_PRODUCTION, BONUS_MINING_PRODUCTION, BONUS_STORAGE_CAPACITY, BONUS_TRADE_FEES, BONUS_WOOD_CONSUMPTION, BONUS_WOOD_PRODUCTION, BONUS_WORKER_PRODUCTIVITY, BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_SHRINE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TEMPLE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP, HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESEARCH_CONSTRUCTION_1, RESEARCH_CONSTRUCTION_2, RESEARCH_CONSTRUCTION_3, RESEARCH_EARTHQUAKES_1, RESEARCH_EARTHQUAKES_2, RESEARCH_EARTHQUAKES_3, RESEARCH_EXPANSION_1, RESEARCH_EXPANSION_2, RESEARCH_EXPANSION_3, RESEARCH_FAITH_1, RESEARCH_FAITH_2, RESEARCH_FAITH_3, RESEARCH_FLOODS_1, RESEARCH_FLOODS_2, RESEARCH_FLOODS_3, RESEARCH_FOOD_CONSUMPTION_1, RESEARCH_FOOD_CONSUMPTION_2, RESEARCH_FOOD_CONSUMPTION_3, RESEARCH_FOOD_PRODUCTION_1, RESEARCH_FOOD_PRODUCTION_2, RESEARCH_FOOD_PRODUCTION_3, RESEARCH_FOOD_PRODUCTION_4, RESEARCH_HEALTH_1, RESEARCH_HEALTH_2, RESEARCH_HEALTH_3, RESEARCH_KNOWLEDGE_PRODUCTION_1, RESEARCH_KNOWLEDGE_PRODUCTION_2, RESEARCH_KNOWLEDGE_PRODUCTION_3, RESEARCH_MINING_1, RESEARCH_MINING_2, RESEARCH_MINING_3, RESEARCH_MINING_4, RESEARCH_STORAGE_1, RESEARCH_STORAGE_2, RESEARCH_STORAGE_3, RESEARCH_STORAGE_4, RESEARCH_TRADING_1, RESEARCH_TRADING_2, RESEARCH_TRADING_3, RESEARCH_TRANSPORTATION_1, RESEARCH_TRANSPORTATION_2, RESEARCH_TRANSPORTATION_3, RESEARCH_WOOD_CONSUMPTION_1, RESEARCH_WOOD_CONSUMPTION_2, RESEARCH_WOOD_CONSUMPTION_3, RESEARCH_WOOD_PRODUCTION_1, RESEARCH_WOOD_PRODUCTION_2, RESEARCH_WOOD_PRODUCTION_3, RESEARCH_WOOD_PRODUCTION_4, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'

// ── Build Time ──────────────────────────────────────────────────────
// Time weight per resource unit (seconds). Used by Cost.toSeconds() to
// derive construction duration from resource costs.
export const RESOURCE_TIME_WEIGHTS = {
  [RESOURCE_FOOD]: 0.1,
  [RESOURCE_WOOD]: 0.1,
  [RESOURCE_STONE]: 0.1,
  [RESOURCE_COPPER]: 0.1,
  [RESOURCE_IRON]: 0.1,
  [RESOURCE_GOLD]: 0.1,
  [RESOURCE_KNOWLEDGE]: 0.1,
}

// ── Building Upgrades ─────────────────────────────────────────────
// Per-building upgrade config: base cost and exponential cost multiplier.
// cost: base resource cost (used in levelUpCost formulas)
// multiplier: exponential scaling factor per level
export const BUILDING_UPGRADES = {
  [BUILDING_HEADQUARTERS]: {
    cost: new Cost({
      food: 20,
      wood: 50,
    }),
    multiplier: 1.5,
  },
  [BUILDING_HOUSE]: {
    cost: new Cost({
      wood: 20,
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
      wood: 20,
    }),
    multiplier: 1.5,
  },
  [BUILDING_WOODCUTTER]: {
    cost: new Cost({
      wood: 20,
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
    wood: 300,
  }),
  [HQ_TYPE_SETTLEMENT]: new Cost({
    wood: 500,
    stone: 300,
  }),
  [HQ_TYPE_VILLAGE]: new Cost({
    stone: 1000,
    copper: 500,
  }),
  [HQ_TYPE_TOWN]: new Cost({
    copper: 2000,
    iron: 1000,
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

// ── Research ──────────────────────────────────────────────────────────
// Research definitions keyed by RESEARCH_* enum.
// cost: resources paid upfront | duration: seconds | academyLevel: min Academy level
// bonus: { type: BONUS_* enum, value: fractional modifier (additive) }

export const RESEARCH_DEFINITIONS = {
  // ── Misc — Transportation (+% worker productivity) ──
  [RESEARCH_TRANSPORTATION_1]: {
    cost: new Cost({
      knowledge: 50,
      wood: 30,
    }),
    duration: 60,
    academyLevel: 1,
    bonus: {
      type: BONUS_WORKER_PRODUCTIVITY,
      value: 0.05,
    },
  },
  [RESEARCH_TRANSPORTATION_2]: {
    cost: new Cost({
      knowledge: 150,
      wood: 80,
    }),
    duration: 120,
    academyLevel: 2,
    bonus: {
      type: BONUS_WORKER_PRODUCTIVITY,
      value: 0.05,
    },
  },
  [RESEARCH_TRANSPORTATION_3]: {
    cost: new Cost({
      knowledge: 400,
      wood: 200,
      stone: 100,
    }),
    duration: 240,
    academyLevel: 3,
    bonus: {
      type: BONUS_WORKER_PRODUCTIVITY,
      value: 0.05,
    },
  },

  // ── Misc — Construction (-% construction time) ──
  [RESEARCH_CONSTRUCTION_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 40,
    }),
    duration: 60,
    academyLevel: 1,
    bonus: {
      type: BONUS_CONSTRUCTION_TIME,
      value: 0.10,
    },
  },
  [RESEARCH_CONSTRUCTION_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 100,
      stone: 50,
    }),
    duration: 120,
    academyLevel: 2,
    bonus: {
      type: BONUS_CONSTRUCTION_TIME,
      value: 0.10,
    },
  },
  [RESEARCH_CONSTRUCTION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 250,
      stone: 120,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_CONSTRUCTION_TIME,
      value: 0.10,
    },
  },

  // ── Misc — Expansion (-% expansion cost) ──
  [RESEARCH_EXPANSION_1]: {
    cost: new Cost({
      knowledge: 80,
      wood: 60,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_EXPANSION_COST,
      value: 0.10,
    },
  },
  [RESEARCH_EXPANSION_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      stone: 60,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_EXPANSION_COST,
      value: 0.10,
    },
  },
  [RESEARCH_EXPANSION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 300,
      stone: 150,
    }),
    duration: 360,
    academyLevel: 3,
    bonus: {
      type: BONUS_EXPANSION_COST,
      value: 0.10,
    },
  },

  // ── Misc — Trading (-% trade fees) ──
  [RESEARCH_TRADING_1]: {
    cost: new Cost({
      knowledge: 100,
      gold: 20,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_TRADE_FEES,
      value: 0.10,
    },
  },
  [RESEARCH_TRADING_2]: {
    cost: new Cost({
      knowledge: 250,
      gold: 50,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_TRADE_FEES,
      value: 0.10,
    },
  },
  [RESEARCH_TRADING_3]: {
    cost: new Cost({
      knowledge: 600,
      gold: 100,
    }),
    duration: 360,
    academyLevel: 3,
    bonus: {
      type: BONUS_TRADE_FEES,
      value: 0.10,
    },
  },

  // ── Prevention — Floods (-% flood impact) ──
  [RESEARCH_FLOODS_1]: {
    cost: new Cost({
      knowledge: 80,
      stone: 50,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_FLOOD_IMPACT,
      value: 0.15,
    },
  },
  [RESEARCH_FLOODS_2]: {
    cost: new Cost({
      knowledge: 200,
      stone: 120,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_FLOOD_IMPACT,
      value: 0.15,
    },
  },
  [RESEARCH_FLOODS_3]: {
    cost: new Cost({
      knowledge: 500,
      stone: 250,
      iron: 50,
    }),
    duration: 360,
    academyLevel: 3,
    bonus: {
      type: BONUS_FLOOD_IMPACT,
      value: 0.20,
    },
  },

  // ── Prevention — Health (-% disease impact) ──
  [RESEARCH_HEALTH_1]: {
    cost: new Cost({
      knowledge: 80,
      food: 60,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_DISEASE_IMPACT,
      value: 0.15,
    },
  },
  [RESEARCH_HEALTH_2]: {
    cost: new Cost({
      knowledge: 200,
      food: 150,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_DISEASE_IMPACT,
      value: 0.15,
    },
  },
  [RESEARCH_HEALTH_3]: {
    cost: new Cost({
      knowledge: 500,
      food: 300,
      copper: 50,
    }),
    duration: 360,
    academyLevel: 3,
    bonus: {
      type: BONUS_DISEASE_IMPACT,
      value: 0.20,
    },
  },

  // ── Prevention — Earthquakes (-% earthquake/tornado impact) ──
  [RESEARCH_EARTHQUAKES_1]: {
    cost: new Cost({
      knowledge: 80,
      stone: 60,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_EARTHQUAKE_IMPACT,
      value: 0.15,
    },
  },
  [RESEARCH_EARTHQUAKES_2]: {
    cost: new Cost({
      knowledge: 200,
      stone: 150,
      wood: 80,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_EARTHQUAKE_IMPACT,
      value: 0.15,
    },
  },
  [RESEARCH_EARTHQUAKES_3]: {
    cost: new Cost({
      knowledge: 500,
      stone: 300,
      iron: 50,
    }),
    duration: 360,
    academyLevel: 3,
    bonus: {
      type: BONUS_EARTHQUAKE_IMPACT,
      value: 0.20,
    },
  },

  // ── Resources — Food Production (+% food production) ──
  [RESEARCH_FOOD_PRODUCTION_1]: {
    cost: new Cost({
      knowledge: 50,
      food: 40,
    }),
    duration: 60,
    academyLevel: 1,
    bonus: {
      type: BONUS_FOOD_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_FOOD_PRODUCTION_2]: {
    cost: new Cost({
      knowledge: 150,
      food: 100,
    }),
    duration: 120,
    academyLevel: 2,
    bonus: {
      type: BONUS_FOOD_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_FOOD_PRODUCTION_3]: {
    cost: new Cost({
      knowledge: 400,
      food: 250,
      wood: 80,
    }),
    duration: 240,
    academyLevel: 3,
    bonus: {
      type: BONUS_FOOD_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_FOOD_PRODUCTION_4]: {
    cost: new Cost({
      knowledge: 800,
      food: 500,
      copper: 100,
    }),
    duration: 480,
    academyLevel: 4,
    bonus: {
      type: BONUS_FOOD_PRODUCTION,
      value: 0.10,
    },
  },

  // ── Resources — Food Consumption (-% food consumption) ──
  [RESEARCH_FOOD_CONSUMPTION_1]: {
    cost: new Cost({
      knowledge: 60,
      food: 50,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_FOOD_CONSUMPTION,
      value: 0.05,
    },
  },
  [RESEARCH_FOOD_CONSUMPTION_2]: {
    cost: new Cost({
      knowledge: 180,
      food: 120,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_FOOD_CONSUMPTION,
      value: 0.05,
    },
  },
  [RESEARCH_FOOD_CONSUMPTION_3]: {
    cost: new Cost({
      knowledge: 450,
      food: 300,
      wood: 100,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_FOOD_CONSUMPTION,
      value: 0.05,
    },
  },

  // ── Resources — Wood Production (+% wood production) ──
  [RESEARCH_WOOD_PRODUCTION_1]: {
    cost: new Cost({
      knowledge: 50,
      wood: 40,
    }),
    duration: 60,
    academyLevel: 1,
    bonus: {
      type: BONUS_WOOD_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_WOOD_PRODUCTION_2]: {
    cost: new Cost({
      knowledge: 150,
      wood: 100,
    }),
    duration: 120,
    academyLevel: 2,
    bonus: {
      type: BONUS_WOOD_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_WOOD_PRODUCTION_3]: {
    cost: new Cost({
      knowledge: 400,
      wood: 250,
      stone: 80,
    }),
    duration: 240,
    academyLevel: 3,
    bonus: {
      type: BONUS_WOOD_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_WOOD_PRODUCTION_4]: {
    cost: new Cost({
      knowledge: 800,
      wood: 500,
      iron: 100,
    }),
    duration: 480,
    academyLevel: 4,
    bonus: {
      type: BONUS_WOOD_PRODUCTION,
      value: 0.10,
    },
  },

  // ── Resources — Wood Consumption (-% wood consumption) ──
  [RESEARCH_WOOD_CONSUMPTION_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 50,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_WOOD_CONSUMPTION,
      value: 0.05,
    },
  },
  [RESEARCH_WOOD_CONSUMPTION_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 120,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_WOOD_CONSUMPTION,
      value: 0.05,
    },
  },
  [RESEARCH_WOOD_CONSUMPTION_3]: {
    cost: new Cost({
      knowledge: 450,
      wood: 300,
      stone: 100,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_WOOD_CONSUMPTION,
      value: 0.05,
    },
  },

  // ── Resources — Mining (+% stone/copper/iron/gold production) ──
  [RESEARCH_MINING_1]: {
    cost: new Cost({
      knowledge: 60,
      stone: 40,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_MINING_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_MINING_2]: {
    cost: new Cost({
      knowledge: 180,
      stone: 100,
      copper: 30,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_MINING_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_MINING_3]: {
    cost: new Cost({
      knowledge: 450,
      stone: 250,
      iron: 50,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_MINING_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_MINING_4]: {
    cost: new Cost({
      knowledge: 900,
      stone: 500,
      gold: 50,
    }),
    duration: 480,
    academyLevel: 4,
    bonus: {
      type: BONUS_MINING_PRODUCTION,
      value: 0.10,
    },
  },

  // ── Resources — Knowledge Production (+% knowledge production) ──
  [RESEARCH_KNOWLEDGE_PRODUCTION_1]: {
    cost: new Cost({
      knowledge: 80,
      wood: 50,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_KNOWLEDGE_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_KNOWLEDGE_PRODUCTION_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      stone: 60,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_KNOWLEDGE_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_KNOWLEDGE_PRODUCTION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 250,
      copper: 80,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_KNOWLEDGE_PRODUCTION,
      value: 0.10,
    },
  },

  // ── Resources — Storage (+% warehouse capacity) ──
  [RESEARCH_STORAGE_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 50,
      stone: 30,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_STORAGE_CAPACITY,
      value: 0.15,
    },
  },
  [RESEARCH_STORAGE_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 120,
      stone: 80,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_STORAGE_CAPACITY,
      value: 0.15,
    },
  },
  [RESEARCH_STORAGE_3]: {
    cost: new Cost({
      knowledge: 450,
      wood: 300,
      stone: 150,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_STORAGE_CAPACITY,
      value: 0.15,
    },
  },
  [RESEARCH_STORAGE_4]: {
    cost: new Cost({
      knowledge: 900,
      wood: 500,
      stone: 300,
      iron: 80,
    }),
    duration: 480,
    academyLevel: 4,
    bonus: {
      type: BONUS_STORAGE_CAPACITY,
      value: 0.15,
    },
  },

  // ── Religion — Faith (+% faith production) ──
  [RESEARCH_FAITH_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 40,
    }),
    duration: 90,
    academyLevel: 1,
    bonus: {
      type: BONUS_FAITH_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_FAITH_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 100,
      stone: 50,
    }),
    duration: 180,
    academyLevel: 2,
    bonus: {
      type: BONUS_FAITH_PRODUCTION,
      value: 0.10,
    },
  },
  [RESEARCH_FAITH_3]: {
    cost: new Cost({
      knowledge: 450,
      wood: 250,
      stone: 120,
    }),
    duration: 300,
    academyLevel: 3,
    bonus: {
      type: BONUS_FAITH_PRODUCTION,
      value: 0.10,
    },
  },
}
