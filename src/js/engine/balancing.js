// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, state.js, and
// UI components.

import {BONUS_CONSTRUCTION_TIME, BONUS_DISEASE_IMPACT, BONUS_EARTHQUAKE_IMPACT, BONUS_EXPANSION_COST, BONUS_FAITH_PRODUCTION, BONUS_FLOOD_IMPACT, BONUS_FOOD_CONSUMPTION, BONUS_FOOD_PRODUCTION, BONUS_HABITATION, BONUS_KNOWLEDGE_PRODUCTION, BONUS_MINING_PRODUCTION, BONUS_STORAGE_CAPACITY, BONUS_UNIT_ATTACK, BONUS_UNIT_DEFENSE, BONUS_WARNING_TIME, BONUS_WOOD_CONSUMPTION, BONUS_WOOD_PRODUCTION, BONUS_WORKER_PRODUCTIVITY, BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_TEMPLE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP, HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESEARCH_ATTACK_1, RESEARCH_ATTACK_2, RESEARCH_ATTACK_3, RESEARCH_ATTACK_4, RESEARCH_ATTACK_5, RESEARCH_CONSTRUCTION_1, RESEARCH_CONSTRUCTION_2, RESEARCH_CONSTRUCTION_3, RESEARCH_CONSTRUCTION_4, RESEARCH_CONSTRUCTION_5, RESEARCH_DEFENSE_1, RESEARCH_DEFENSE_2, RESEARCH_DEFENSE_3, RESEARCH_DEFENSE_4, RESEARCH_DEFENSE_5, RESEARCH_EARTHQUAKES_1, RESEARCH_EARTHQUAKES_2, RESEARCH_EARTHQUAKES_3, RESEARCH_EARTHQUAKES_4, RESEARCH_EARTHQUAKES_5, RESEARCH_EXPANSION_1, RESEARCH_EXPANSION_2, RESEARCH_EXPANSION_3, RESEARCH_EXPANSION_4, RESEARCH_EXPANSION_5, RESEARCH_FAITH_1, RESEARCH_FAITH_2, RESEARCH_FAITH_3, RESEARCH_FAITH_4, RESEARCH_FAITH_5, RESEARCH_FLOODS_1, RESEARCH_FLOODS_2, RESEARCH_FLOODS_3, RESEARCH_FLOODS_4, RESEARCH_FLOODS_5, RESEARCH_FOOD_CONSUMPTION_1, RESEARCH_FOOD_CONSUMPTION_2, RESEARCH_FOOD_CONSUMPTION_3, RESEARCH_FOOD_CONSUMPTION_4, RESEARCH_FOOD_CONSUMPTION_5, RESEARCH_FOOD_PRODUCTION_1, RESEARCH_FOOD_PRODUCTION_2, RESEARCH_FOOD_PRODUCTION_3, RESEARCH_FOOD_PRODUCTION_4, RESEARCH_FOOD_PRODUCTION_5, RESEARCH_HABITATION_1, RESEARCH_HABITATION_2, RESEARCH_HABITATION_3, RESEARCH_HABITATION_4, RESEARCH_HABITATION_5, RESEARCH_HEALTH_1, RESEARCH_HEALTH_2, RESEARCH_HEALTH_3, RESEARCH_HEALTH_4, RESEARCH_HEALTH_5, RESEARCH_KNOWLEDGE_PRODUCTION_1, RESEARCH_KNOWLEDGE_PRODUCTION_2, RESEARCH_KNOWLEDGE_PRODUCTION_3, RESEARCH_KNOWLEDGE_PRODUCTION_4, RESEARCH_KNOWLEDGE_PRODUCTION_5, RESEARCH_MINING_1, RESEARCH_MINING_2, RESEARCH_MINING_3, RESEARCH_MINING_4, RESEARCH_MINING_5, RESEARCH_STORAGE_1, RESEARCH_STORAGE_2, RESEARCH_STORAGE_3, RESEARCH_STORAGE_4, RESEARCH_STORAGE_5, RESEARCH_SUBCATEGORY_ATTACK, RESEARCH_SUBCATEGORY_CONSTRUCTION, RESEARCH_SUBCATEGORY_DEFENSE, RESEARCH_SUBCATEGORY_EARTHQUAKES, RESEARCH_SUBCATEGORY_EXPANSION, RESEARCH_SUBCATEGORY_FAITH, RESEARCH_SUBCATEGORY_FLOODS, RESEARCH_SUBCATEGORY_FOOD_CONSUMPTION, RESEARCH_SUBCATEGORY_FOOD_PRODUCTION, RESEARCH_SUBCATEGORY_HABITATION, RESEARCH_SUBCATEGORY_HEALTH, RESEARCH_SUBCATEGORY_KNOWLEDGE_PRODUCTION, RESEARCH_SUBCATEGORY_MINING, RESEARCH_SUBCATEGORY_STORAGE, RESEARCH_SUBCATEGORY_TRANSPORTATION, RESEARCH_SUBCATEGORY_WARNING, RESEARCH_SUBCATEGORY_WOOD_CONSUMPTION, RESEARCH_SUBCATEGORY_WOOD_PRODUCTION, RESEARCH_TRANSPORTATION_1, RESEARCH_TRANSPORTATION_2, RESEARCH_TRANSPORTATION_3, RESEARCH_TRANSPORTATION_4, RESEARCH_TRANSPORTATION_5, RESEARCH_WARNING_1, RESEARCH_WARNING_2, RESEARCH_WARNING_3, RESEARCH_WARNING_4, RESEARCH_WARNING_5, RESEARCH_WOOD_CONSUMPTION_1, RESEARCH_WOOD_CONSUMPTION_2, RESEARCH_WOOD_CONSUMPTION_3, RESEARCH_WOOD_CONSUMPTION_4, RESEARCH_WOOD_CONSUMPTION_5, RESEARCH_WOOD_PRODUCTION_1, RESEARCH_WOOD_PRODUCTION_2, RESEARCH_WOOD_PRODUCTION_3, RESEARCH_WOOD_PRODUCTION_4, RESEARCH_WOOD_PRODUCTION_5, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'

// ── Build Time ──────────────────────────────────────────────────────
// Time weight per resource unit (seconds). Used by Cost.toSeconds to
// derive construction duration from resource costs.
// Formula: floor(weightedSum ^ RESOURCE_TIME_EXPONENT)
export const RESOURCE_TIME_WEIGHTS = {
  [RESOURCE_FOOD]: 0.1,
  [RESOURCE_WOOD]: 0.1,
  [RESOURCE_STONE]: 0.1,
  [RESOURCE_COPPER]: 0.1,
  [RESOURCE_IRON]: 0.1,
  [RESOURCE_GOLD]: 0.1,
  [RESOURCE_KNOWLEDGE]: 0.1,
  [RESOURCE_FAITH]: 0.1,
}
export const RESOURCE_TIME_EXPONENT = 0.7

// ── Building Upgrades ─────────────────────────────────────────────
// Per-building upgrade config: base cost and exponential cost multiplier.
// cost: base resource cost (used in levelUpCost formulas)
// multiplier: exponential scaling factor per level
export const BUILDING_UPGRADES = {
  [BUILDING_HEADQUARTERS]: {
    cost: new Cost({
      food: 50,
      wood: 50,
    }),
    multiplier: 1.6,
  },
  [BUILDING_HOUSE]: {
    cost: new Cost({
      wood: 20,
    }),
    multiplier: 1.4,
  },
  [BUILDING_ACADEMY]: {
    cost: new Cost({
      wood: 60,
      stone: 30,
    }),
    multiplier: 1.4,
  },
  [BUILDING_STOREHOUSE]: {
    cost: new Cost({
      wood: 100,
      stone: 80,
    }),
    multiplier: 1.22,
  },
  [BUILDING_MARKET]: {
    cost: new Cost({
      wood: 150,
      stone: 75,
    }),
    multiplier: 1.4,
  },
  [BUILDING_FARM]: {
    cost: new Cost({
      wood: 20,
    }),
    multiplier: 1.4,
  },
  [BUILDING_WOODCUTTER]: {
    cost: new Cost({
      wood: 20,
    }),
    multiplier: 1.4,
  },
  [BUILDING_QUARRY]: {
    cost: new Cost({
      wood: 45,
    }),
    multiplier: 1.4,
  },
  [BUILDING_COPPER_MINE]: {
    cost: new Cost({
      wood: 70,
      stone: 35,
    }),
    multiplier: 1.4,
  },
  [BUILDING_IRON_MINE]: {
    cost: new Cost({
      wood: 100,
      stone: 50,
    }),
    multiplier: 1.4,
  },
  [BUILDING_GOLD_MINE]: {
    cost: new Cost({
      wood: 140,
      stone: 70,
    }),
    multiplier: 1.4,
  },
  [BUILDING_ALTAR]: {
    cost: new Cost({
      wood: 50,
    }),
    multiplier: 1.2,
  },
  [BUILDING_TEMPLE]: {
    cost: new Cost({
      wood: 50,
      stone: 25,
    }),
    multiplier: 1.4,
  },
  [BUILDING_MONUMENT]: {
    cost: new Cost({
      wood: 120,
      stone: 60,
    }),
    multiplier: 1.4,
  },
  [BUILDING_BARRACKS]: {
    cost: new Cost({
      wood: 55,
      stone: 25,
    }),
    multiplier: 1.4,
  },
  [BUILDING_ARCHERY]: {
    cost: new Cost({
      wood: 75,
      stone: 40,
    }),
    multiplier: 1.4,
  },
  [BUILDING_STABLE]: {
    cost: new Cost({
      wood: 110,
      stone: 55,
    }),
    multiplier: 1.4,
  },
  [BUILDING_WORKSHOP]: {
    cost: new Cost({
      wood: 160,
      stone: 80,
    }),
    multiplier: 1.4,
  },
  [BUILDING_WALL]: {
    cost: new Cost({
      wood: 100,
      stone: 50,
    }),
    multiplier: 1.4,
  },
  [BUILDING_TOWER]: {
    cost: new Cost({
      wood: 150,
      stone: 75,
    }),
    multiplier: 1.4,
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

// Base production rates per second (building key → resource + rate). Worker-based unless passive: true (per-level).
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
  [BUILDING_TEMPLE]: {
    resource: RESOURCE_FAITH,
    rate: 0.15,
  },
  [BUILDING_ALTAR]: {
    resource: RESOURCE_FAITH,
    rate: 0.1,
    passive: true,
  },
}

// ── Monument ────────────────────────────────────────────────────────
// One-time faith granted when a monument finishes construction: value × newLevel
export const MONUMENT_FAITH_PER_LEVEL = 100

// ── Population & Workers ────────────────────────────────────────────

// House population cap: level × perLevel
export const HOUSE_POPULATION_PER_LEVEL = 10

// Number of worker slots gained per building level
export const WORKERS_PER_LEVEL = 5
export const BULK_WORKER_AMOUNT = 10 // Max workers assigned/dismissed per ctrl+click

// Worker recruitment cost (always food)
export const WORKER_RECRUIT_COST = new Cost({
  food: 50,
})

// ── Worker Upkeep ─────────────────────────────────────────────────────

// Resource consumed per worker per second
export const WORKER_FOOD_CONSUMPTION = 0.1
export const WORKER_WOOD_CONSUMPTION = 0.1

// ── Stockpile ───────────────────────────────────────────────────────

// Storehouse resource capacity: base × capacityMultiplier ^ level
export const STOREHOUSE_BASE_CAPACITY = 500
export const STOREHOUSE_CAPACITY_MULTIPLIER = 1.2

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

// Maximum fractional penalty applied to ALL production when food or wood has
// negative net production. Scales with deficit ratio (uncovered / total consumption).
// Worst-of: only the largest penalty applies when both are negative
export const SHORTAGE_MAX_PENALTY = 1

// ── Research ──────────────────────────────────────────────────────────
// Bonus per subcategory: { type: BONUS_* enum, value: modifier (additive per tier) }
// Each tier in a chain grants the same bonus; defined once per subcategory.
// Most bonuses are fractional (e.g. 0.05 = 5%); flat bonuses add { flat: true }.
export const RESEARCH_SUBCATEGORY_BONUSES = {

  // General
  [RESEARCH_SUBCATEGORY_TRANSPORTATION]: {
    type: BONUS_WORKER_PRODUCTIVITY,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_CONSTRUCTION]: {
    type: BONUS_CONSTRUCTION_TIME,
    value: 0.10,
  },
  [RESEARCH_SUBCATEGORY_EXPANSION]: {
    type: BONUS_EXPANSION_COST,
    value: 0.10,
  },
  [RESEARCH_SUBCATEGORY_STORAGE]: {
    type: BONUS_STORAGE_CAPACITY,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_HABITATION]: {
    type: BONUS_HABITATION,
    value: 1,
    flat: true,
  },
  // Resources
  [RESEARCH_SUBCATEGORY_FOOD_PRODUCTION]: {
    type: BONUS_FOOD_PRODUCTION,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_FOOD_CONSUMPTION]: {
    type: BONUS_FOOD_CONSUMPTION,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_WOOD_PRODUCTION]: {
    type: BONUS_WOOD_PRODUCTION,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_WOOD_CONSUMPTION]: {
    type: BONUS_WOOD_CONSUMPTION,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_MINING]: {
    type: BONUS_MINING_PRODUCTION,
    value: 0.05,
  },
  [RESEARCH_SUBCATEGORY_KNOWLEDGE_PRODUCTION]: {
    type: BONUS_KNOWLEDGE_PRODUCTION,
    value: 0.05,
  },

  // Disasters
  [RESEARCH_SUBCATEGORY_FLOODS]: {
    type: BONUS_FLOOD_IMPACT,
    value: 0.10,
  },
  [RESEARCH_SUBCATEGORY_HEALTH]: {
    type: BONUS_DISEASE_IMPACT,
    value: 0.10,
  },
  [RESEARCH_SUBCATEGORY_EARTHQUAKES]: {
    type: BONUS_EARTHQUAKE_IMPACT,
    value: 0.10,
  },

  // Religion
  [RESEARCH_SUBCATEGORY_FAITH]: {
    type: BONUS_FAITH_PRODUCTION,
    value: 0.05,
  },

  // Military
  [RESEARCH_SUBCATEGORY_DEFENSE]: {
    type: BONUS_UNIT_DEFENSE,
    value: 0.10,
  },
  [RESEARCH_SUBCATEGORY_ATTACK]: {
    type: BONUS_UNIT_ATTACK,
    value: 0.10,
  },
  [RESEARCH_SUBCATEGORY_WARNING]: {
    type: BONUS_WARNING_TIME,
    value: 0.10,
  },
}

// Research costs keyed by RESEARCH_* enum.
// Resources paid upfront (duration derived via cost.toSeconds)
export const RESEARCH_COSTS = {
  // General: Transportation
  [RESEARCH_TRANSPORTATION_1]: new Cost({
    knowledge: 50,
    food: 30,
    wood: 20,
  }),
  [RESEARCH_TRANSPORTATION_2]: new Cost({
    knowledge: 150,
    wood: 80,
    stone: 50,
  }),
  [RESEARCH_TRANSPORTATION_3]: new Cost({
    knowledge: 400,
    stone: 200,
    copper: 80,
  }),
  [RESEARCH_TRANSPORTATION_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_TRANSPORTATION_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),

  // General: Construction
  [RESEARCH_CONSTRUCTION_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_CONSTRUCTION_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_CONSTRUCTION_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_CONSTRUCTION_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_CONSTRUCTION_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // General: Expansion
  [RESEARCH_EXPANSION_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_EXPANSION_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_EXPANSION_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_EXPANSION_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_EXPANSION_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // General: Storage
  [RESEARCH_STORAGE_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_STORAGE_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_STORAGE_3]: new Cost({
    knowledge: 450,
    stone: 230,
    copper: 90,
  }),
  [RESEARCH_STORAGE_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_STORAGE_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // General: Habitation
  [RESEARCH_HABITATION_1]: new Cost({
    knowledge: 70,
    food: 40,
    wood: 30,
  }),
  [RESEARCH_HABITATION_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_HABITATION_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_HABITATION_4]: new Cost({
    knowledge: 1000,
    copper: 300,
    iron: 100,
  }),
  [RESEARCH_HABITATION_5]: new Cost({
    knowledge: 1800,
    iron: 450,
    gold: 150,
  }),

  // Resources: Food Production
  [RESEARCH_FOOD_PRODUCTION_1]: new Cost({
    knowledge: 50,
    food: 30,
    wood: 20,
  }),
  [RESEARCH_FOOD_PRODUCTION_2]: new Cost({
    knowledge: 150,
    wood: 80,
    stone: 50,
  }),
  [RESEARCH_FOOD_PRODUCTION_3]: new Cost({
    knowledge: 400,
    stone: 200,
    copper: 80,
  }),
  [RESEARCH_FOOD_PRODUCTION_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_FOOD_PRODUCTION_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),

  // Resources: Food Consumption
  [RESEARCH_FOOD_CONSUMPTION_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_FOOD_CONSUMPTION_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_FOOD_CONSUMPTION_3]: new Cost({
    knowledge: 450,
    stone: 230,
    copper: 90,
  }),
  [RESEARCH_FOOD_CONSUMPTION_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_FOOD_CONSUMPTION_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),

  // Resources: Wood Production
  [RESEARCH_WOOD_PRODUCTION_1]: new Cost({
    knowledge: 50,
    food: 30,
    wood: 20,
  }),
  [RESEARCH_WOOD_PRODUCTION_2]: new Cost({
    knowledge: 150,
    wood: 80,
    stone: 50,
  }),
  [RESEARCH_WOOD_PRODUCTION_3]: new Cost({
    knowledge: 400,
    stone: 200,
    copper: 80,
  }),
  [RESEARCH_WOOD_PRODUCTION_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_WOOD_PRODUCTION_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),

  // Resources: Wood Consumption
  [RESEARCH_WOOD_CONSUMPTION_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_WOOD_CONSUMPTION_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_WOOD_CONSUMPTION_3]: new Cost({
    knowledge: 450,
    stone: 230,
    copper: 90,
  }),
  [RESEARCH_WOOD_CONSUMPTION_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_WOOD_CONSUMPTION_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),

  // Resources: Mining
  [RESEARCH_MINING_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_MINING_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_MINING_3]: new Cost({
    knowledge: 450,
    stone: 230,
    copper: 90,
  }),
  [RESEARCH_MINING_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_MINING_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Resources: Knowledge Production
  [RESEARCH_KNOWLEDGE_PRODUCTION_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_KNOWLEDGE_PRODUCTION_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_KNOWLEDGE_PRODUCTION_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_KNOWLEDGE_PRODUCTION_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_KNOWLEDGE_PRODUCTION_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Disasters: Floods
  [RESEARCH_FLOODS_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_FLOODS_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_FLOODS_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_FLOODS_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_FLOODS_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Disasters: Health
  [RESEARCH_HEALTH_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_HEALTH_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_HEALTH_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_HEALTH_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_HEALTH_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Disasters: Earthquakes
  [RESEARCH_EARTHQUAKES_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_EARTHQUAKES_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_EARTHQUAKES_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_EARTHQUAKES_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_EARTHQUAKES_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Religion: Faith
  [RESEARCH_FAITH_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_FAITH_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_FAITH_3]: new Cost({
    knowledge: 450,
    stone: 230,
    copper: 90,
  }),
  [RESEARCH_FAITH_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_FAITH_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),

  // Military: Defense
  [RESEARCH_DEFENSE_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_DEFENSE_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_DEFENSE_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_DEFENSE_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_DEFENSE_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Military: Attack
  [RESEARCH_ATTACK_1]: new Cost({
    knowledge: 80,
    food: 50,
    wood: 30,
  }),
  [RESEARCH_ATTACK_2]: new Cost({
    knowledge: 200,
    wood: 100,
    stone: 60,
  }),
  [RESEARCH_ATTACK_3]: new Cost({
    knowledge: 500,
    stone: 250,
    copper: 100,
  }),
  [RESEARCH_ATTACK_4]: new Cost({
    knowledge: 900,
    copper: 280,
    iron: 90,
  }),
  [RESEARCH_ATTACK_5]: new Cost({
    knowledge: 1600,
    iron: 400,
    gold: 130,
  }),

  // Military: Warning
  [RESEARCH_WARNING_1]: new Cost({
    knowledge: 60,
    food: 40,
    wood: 25,
  }),
  [RESEARCH_WARNING_2]: new Cost({
    knowledge: 180,
    wood: 90,
    stone: 60,
  }),
  [RESEARCH_WARNING_3]: new Cost({
    knowledge: 450,
    stone: 230,
    copper: 90,
  }),
  [RESEARCH_WARNING_4]: new Cost({
    knowledge: 800,
    copper: 250,
    iron: 80,
  }),
  [RESEARCH_WARNING_5]: new Cost({
    knowledge: 1500,
    iron: 400,
    gold: 120,
  }),
}

// ── Market Trading ─────────────────────────────────────────────────

// Number of resource units exchanged per trade
export const MARKET_TRADE_AMOUNT = 100

// Base gold value per MARKET_TRADE_AMOUNT of each resource
export const MARKET_BASE_PRICES = {
  [RESOURCE_FOOD]: 100,
  [RESOURCE_WOOD]: 110,
  [RESOURCE_STONE]: 120,
  [RESOURCE_COPPER]: 130,
  [RESOURCE_IRON]: 140,
}

// Default trade fee (fraction, 0.30 = 30%)
export const MARKET_BASE_FEE = 0.30

// Minimum possible fee after all reductions
export const MARKET_MIN_FEE = 0.05

// Fee reduction per market building level (percentage points)
export const MARKET_FEE_REDUCTION_PER_LEVEL = 0.01

// Gold shift in current price per trade (both buy and sell)
export const MARKET_PRICE_SHIFT = 3

// Minimum current price (ensures sell floor of ~14 Gold at max fee)
export const MARKET_MIN_CURRENT_PRICE = 20

// Maximum current price (caps how expensive buying can get)
export const MARKET_MAX_CURRENT_PRICE = 9999
