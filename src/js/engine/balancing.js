// Game balancing values — all tunable constants in one place.
// Consumed by constants.js, building classes, game_state.js, and
// UI components.

import {BONUS_CONSTRUCTION_TIME, BONUS_DISEASE_IMPACT, BONUS_EARTHQUAKE_IMPACT, BONUS_EXPANSION_COST, BONUS_FAITH_PRODUCTION, BONUS_FLOOD_IMPACT, BONUS_FOOD_CONSUMPTION, BONUS_FOOD_PRODUCTION, BONUS_HABITATION, BONUS_KNOWLEDGE_PRODUCTION, BONUS_MINING_PRODUCTION, BONUS_STORAGE_CAPACITY, BONUS_UNIT_ATTACK, BONUS_UNIT_DEFENSE, BONUS_WARNING_TIME, BONUS_WOOD_CONSUMPTION, BONUS_WOOD_PRODUCTION, BONUS_WORKER_PRODUCTIVITY, BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_TEMPLE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP, HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESEARCH_ATTACK_1, RESEARCH_ATTACK_2, RESEARCH_ATTACK_3, RESEARCH_ATTACK_4, RESEARCH_ATTACK_5, RESEARCH_CONSTRUCTION_1, RESEARCH_CONSTRUCTION_2, RESEARCH_CONSTRUCTION_3, RESEARCH_CONSTRUCTION_4, RESEARCH_CONSTRUCTION_5, RESEARCH_DEFENSE_1, RESEARCH_DEFENSE_2, RESEARCH_DEFENSE_3, RESEARCH_DEFENSE_4, RESEARCH_DEFENSE_5, RESEARCH_EARTHQUAKES_1, RESEARCH_EARTHQUAKES_2, RESEARCH_EARTHQUAKES_3, RESEARCH_EARTHQUAKES_4, RESEARCH_EARTHQUAKES_5, RESEARCH_EXPANSION_1, RESEARCH_EXPANSION_2, RESEARCH_EXPANSION_3, RESEARCH_EXPANSION_4, RESEARCH_EXPANSION_5, RESEARCH_FAITH_1, RESEARCH_FAITH_2, RESEARCH_FAITH_3, RESEARCH_FAITH_4, RESEARCH_FAITH_5, RESEARCH_FLOODS_1, RESEARCH_FLOODS_2, RESEARCH_FLOODS_3, RESEARCH_FLOODS_4, RESEARCH_FLOODS_5, RESEARCH_FOOD_CONSUMPTION_1, RESEARCH_FOOD_CONSUMPTION_2, RESEARCH_FOOD_CONSUMPTION_3, RESEARCH_FOOD_CONSUMPTION_4, RESEARCH_FOOD_CONSUMPTION_5, RESEARCH_FOOD_PRODUCTION_1, RESEARCH_FOOD_PRODUCTION_2, RESEARCH_FOOD_PRODUCTION_3, RESEARCH_FOOD_PRODUCTION_4, RESEARCH_FOOD_PRODUCTION_5, RESEARCH_HABITATION_1, RESEARCH_HABITATION_2, RESEARCH_HABITATION_3, RESEARCH_HABITATION_4, RESEARCH_HABITATION_5, RESEARCH_HEALTH_1, RESEARCH_HEALTH_2, RESEARCH_HEALTH_3, RESEARCH_HEALTH_4, RESEARCH_HEALTH_5, RESEARCH_KNOWLEDGE_PRODUCTION_1, RESEARCH_KNOWLEDGE_PRODUCTION_2, RESEARCH_KNOWLEDGE_PRODUCTION_3, RESEARCH_KNOWLEDGE_PRODUCTION_4, RESEARCH_KNOWLEDGE_PRODUCTION_5, RESEARCH_MINING_1, RESEARCH_MINING_2, RESEARCH_MINING_3, RESEARCH_MINING_4, RESEARCH_MINING_5, RESEARCH_STORAGE_1, RESEARCH_STORAGE_2, RESEARCH_STORAGE_3, RESEARCH_STORAGE_4, RESEARCH_STORAGE_5, RESEARCH_SUBCATEGORY_ATTACK, RESEARCH_SUBCATEGORY_CONSTRUCTION, RESEARCH_SUBCATEGORY_DEFENSE, RESEARCH_SUBCATEGORY_EARTHQUAKES, RESEARCH_SUBCATEGORY_EXPANSION, RESEARCH_SUBCATEGORY_FAITH, RESEARCH_SUBCATEGORY_FLOODS, RESEARCH_SUBCATEGORY_FOOD_CONSUMPTION, RESEARCH_SUBCATEGORY_FOOD_PRODUCTION, RESEARCH_SUBCATEGORY_HABITATION, RESEARCH_SUBCATEGORY_HEALTH, RESEARCH_SUBCATEGORY_KNOWLEDGE_PRODUCTION, RESEARCH_SUBCATEGORY_MINING, RESEARCH_SUBCATEGORY_STORAGE, RESEARCH_SUBCATEGORY_TRANSPORTATION, RESEARCH_SUBCATEGORY_WARNING, RESEARCH_SUBCATEGORY_WOOD_CONSUMPTION, RESEARCH_SUBCATEGORY_WOOD_PRODUCTION, RESEARCH_TRANSPORTATION_1, RESEARCH_TRANSPORTATION_2, RESEARCH_TRANSPORTATION_3, RESEARCH_TRANSPORTATION_4, RESEARCH_TRANSPORTATION_5, RESEARCH_WARNING_1, RESEARCH_WARNING_2, RESEARCH_WARNING_3, RESEARCH_WARNING_4, RESEARCH_WARNING_5, RESEARCH_WOOD_CONSUMPTION_1, RESEARCH_WOOD_CONSUMPTION_2, RESEARCH_WOOD_CONSUMPTION_3, RESEARCH_WOOD_CONSUMPTION_4, RESEARCH_WOOD_CONSUMPTION_5, RESEARCH_WOOD_PRODUCTION_1, RESEARCH_WOOD_PRODUCTION_2, RESEARCH_WOOD_PRODUCTION_3, RESEARCH_WOOD_PRODUCTION_4, RESEARCH_WOOD_PRODUCTION_5, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
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
  [BUILDING_TEMPLE]: {
    cost: new Cost({
      wood: 50,
      stone: 25,
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

// Maps each production building to its research bonus type.
// Used by GameState.update() to apply per-resource production multipliers.
export const PRODUCTION_BONUS_MAP = {
  [BUILDING_FARM]: BONUS_FOOD_PRODUCTION,
  [BUILDING_WOODCUTTER]: BONUS_WOOD_PRODUCTION,
  [BUILDING_QUARRY]: BONUS_MINING_PRODUCTION,
  [BUILDING_COPPER_MINE]: BONUS_MINING_PRODUCTION,
  [BUILDING_IRON_MINE]: BONUS_MINING_PRODUCTION,
  [BUILDING_GOLD_MINE]: BONUS_MINING_PRODUCTION,
  [BUILDING_ACADEMY]: BONUS_KNOWLEDGE_PRODUCTION,
  [BUILDING_TEMPLE]: BONUS_FAITH_PRODUCTION,
  [BUILDING_ALTAR]: BONUS_FAITH_PRODUCTION,
}

// ── Monument ────────────────────────────────────────────────────────
// One-time faith granted when a monument finishes construction: value × newLevel
export const MONUMENT_FAITH_PER_LEVEL = 100

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
    value: 0.10,
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

// Research definitions keyed by RESEARCH_* enum.
// cost: resources paid upfront (duration derived via cost.toSeconds())
export const RESEARCH_DEFINITIONS = {
  // ── General — Transportation ──
  [RESEARCH_TRANSPORTATION_1]: {
    cost: new Cost({
      knowledge: 50,
      wood: 30,
    }),
  },
  [RESEARCH_TRANSPORTATION_2]: {
    cost: new Cost({
      knowledge: 150,
      wood: 80,
    }),
  },
  [RESEARCH_TRANSPORTATION_3]: {
    cost: new Cost({
      knowledge: 400,
      wood: 200,
      stone: 100,
    }),
  },
  [RESEARCH_TRANSPORTATION_4]: {
    cost: new Cost({
      knowledge: 800,
      wood: 400,
      iron: 50,
    }),
  },
  [RESEARCH_TRANSPORTATION_5]: {
    cost: new Cost({
      knowledge: 1500,
      stone: 400,
      iron: 150,
    }),
  },

  // ── General — Construction ──
  [RESEARCH_CONSTRUCTION_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 40,
    }),
  },
  [RESEARCH_CONSTRUCTION_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 100,
      stone: 50,
    }),
  },
  [RESEARCH_CONSTRUCTION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 250,
      stone: 120,
    }),
  },
  [RESEARCH_CONSTRUCTION_4]: {
    cost: new Cost({
      knowledge: 900,
      stone: 300,
      iron: 80,
    }),
  },
  [RESEARCH_CONSTRUCTION_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 500,
      iron: 200,
    }),
  },

  // ── General — Expansion ──
  [RESEARCH_EXPANSION_1]: {
    cost: new Cost({
      knowledge: 80,
      wood: 60,
    }),
  },
  [RESEARCH_EXPANSION_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      stone: 60,
    }),
  },
  [RESEARCH_EXPANSION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 300,
      stone: 150,
    }),
  },
  [RESEARCH_EXPANSION_4]: {
    cost: new Cost({
      knowledge: 900,
      wood: 500,
      copper: 100,
    }),
  },
  [RESEARCH_EXPANSION_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 400,
      gold: 80,
    }),
  },

  // ── General — Storage ──
  [RESEARCH_STORAGE_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 50,
      stone: 30,
    }),
  },
  [RESEARCH_STORAGE_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 120,
      stone: 80,
    }),
  },
  [RESEARCH_STORAGE_3]: {
    cost: new Cost({
      knowledge: 450,
      wood: 300,
      stone: 150,
    }),
  },
  [RESEARCH_STORAGE_4]: {
    cost: new Cost({
      knowledge: 900,
      wood: 500,
      stone: 300,
    }),
  },
  [RESEARCH_STORAGE_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 600,
      iron: 150,
    }),
  },

  // ── General — Habitation ──
  [RESEARCH_HABITATION_1]: {
    cost: new Cost({
      knowledge: 70,
      wood: 50,
      stone: 30,
    }),
  },
  [RESEARCH_HABITATION_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      stone: 80,
    }),
  },
  [RESEARCH_HABITATION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 300,
      stone: 150,
    }),
  },
  [RESEARCH_HABITATION_4]: {
    cost: new Cost({
      knowledge: 1000,
      wood: 500,
      stone: 300,
      iron: 80,
    }),
  },
  [RESEARCH_HABITATION_5]: {
    cost: new Cost({
      knowledge: 1800,
      stone: 600,
      iron: 200,
      gold: 100,
    }),
  },

  // ── Disasters — Floods ──
  [RESEARCH_FLOODS_1]: {
    cost: new Cost({
      knowledge: 80,
      stone: 50,
    }),
  },
  [RESEARCH_FLOODS_2]: {
    cost: new Cost({
      knowledge: 200,
      stone: 120,
    }),
  },
  [RESEARCH_FLOODS_3]: {
    cost: new Cost({
      knowledge: 500,
      stone: 250,
      iron: 50,
    }),
  },
  [RESEARCH_FLOODS_4]: {
    cost: new Cost({
      knowledge: 900,
      stone: 400,
      iron: 120,
    }),
  },
  [RESEARCH_FLOODS_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 600,
      iron: 250,
    }),
  },

  // ── Disasters — Health ──
  [RESEARCH_HEALTH_1]: {
    cost: new Cost({
      knowledge: 80,
      food: 60,
    }),
  },
  [RESEARCH_HEALTH_2]: {
    cost: new Cost({
      knowledge: 200,
      food: 150,
    }),
  },
  [RESEARCH_HEALTH_3]: {
    cost: new Cost({
      knowledge: 500,
      food: 300,
      copper: 50,
    }),
  },
  [RESEARCH_HEALTH_4]: {
    cost: new Cost({
      knowledge: 900,
      food: 500,
      stone: 150,
    }),
  },
  [RESEARCH_HEALTH_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 400,
      iron: 100,
    }),
  },

  // ── Disasters — Earthquakes ──
  [RESEARCH_EARTHQUAKES_1]: {
    cost: new Cost({
      knowledge: 80,
      stone: 60,
    }),
  },
  [RESEARCH_EARTHQUAKES_2]: {
    cost: new Cost({
      knowledge: 200,
      stone: 150,
      wood: 80,
    }),
  },
  [RESEARCH_EARTHQUAKES_3]: {
    cost: new Cost({
      knowledge: 500,
      stone: 300,
      iron: 50,
    }),
  },
  [RESEARCH_EARTHQUAKES_4]: {
    cost: new Cost({
      knowledge: 900,
      stone: 500,
      iron: 120,
    }),
  },
  [RESEARCH_EARTHQUAKES_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 700,
      iron: 250,
    }),
  },

  // ── Resources — Food Production ──
  [RESEARCH_FOOD_PRODUCTION_1]: {
    cost: new Cost({
      knowledge: 50,
      food: 40,
    }),
  },
  [RESEARCH_FOOD_PRODUCTION_2]: {
    cost: new Cost({
      knowledge: 150,
      food: 100,
    }),
  },
  [RESEARCH_FOOD_PRODUCTION_3]: {
    cost: new Cost({
      knowledge: 400,
      food: 250,
      wood: 80,
    }),
  },
  [RESEARCH_FOOD_PRODUCTION_4]: {
    cost: new Cost({
      knowledge: 800,
      food: 500,
      copper: 100,
    }),
  },
  [RESEARCH_FOOD_PRODUCTION_5]: {
    cost: new Cost({
      knowledge: 1500,
      food: 800,
      iron: 100,
    }),
  },

  // ── Resources — Food Consumption ──
  [RESEARCH_FOOD_CONSUMPTION_1]: {
    cost: new Cost({
      knowledge: 60,
      food: 50,
    }),
  },
  [RESEARCH_FOOD_CONSUMPTION_2]: {
    cost: new Cost({
      knowledge: 180,
      food: 120,
    }),
  },
  [RESEARCH_FOOD_CONSUMPTION_3]: {
    cost: new Cost({
      knowledge: 450,
      food: 300,
      wood: 100,
    }),
  },
  [RESEARCH_FOOD_CONSUMPTION_4]: {
    cost: new Cost({
      knowledge: 800,
      food: 500,
      wood: 200,
    }),
  },
  [RESEARCH_FOOD_CONSUMPTION_5]: {
    cost: new Cost({
      knowledge: 1500,
      food: 800,
      stone: 150,
    }),
  },

  // ── Resources — Wood Production ──
  [RESEARCH_WOOD_PRODUCTION_1]: {
    cost: new Cost({
      knowledge: 50,
      wood: 40,
    }),
  },
  [RESEARCH_WOOD_PRODUCTION_2]: {
    cost: new Cost({
      knowledge: 150,
      wood: 100,
    }),
  },
  [RESEARCH_WOOD_PRODUCTION_3]: {
    cost: new Cost({
      knowledge: 400,
      wood: 250,
      stone: 80,
    }),
  },
  [RESEARCH_WOOD_PRODUCTION_4]: {
    cost: new Cost({
      knowledge: 800,
      wood: 500,
      iron: 100,
    }),
  },
  [RESEARCH_WOOD_PRODUCTION_5]: {
    cost: new Cost({
      knowledge: 1500,
      wood: 800,
      iron: 200,
    }),
  },

  // ── Resources — Wood Consumption ──
  [RESEARCH_WOOD_CONSUMPTION_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 50,
    }),
  },
  [RESEARCH_WOOD_CONSUMPTION_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 120,
    }),
  },
  [RESEARCH_WOOD_CONSUMPTION_3]: {
    cost: new Cost({
      knowledge: 450,
      wood: 300,
      stone: 100,
    }),
  },
  [RESEARCH_WOOD_CONSUMPTION_4]: {
    cost: new Cost({
      knowledge: 800,
      wood: 500,
      copper: 100,
    }),
  },
  [RESEARCH_WOOD_CONSUMPTION_5]: {
    cost: new Cost({
      knowledge: 1500,
      wood: 800,
      iron: 150,
    }),
  },

  // ── Resources — Mining ──
  [RESEARCH_MINING_1]: {
    cost: new Cost({
      knowledge: 60,
      stone: 40,
    }),
  },
  [RESEARCH_MINING_2]: {
    cost: new Cost({
      knowledge: 180,
      stone: 100,
      copper: 30,
    }),
  },
  [RESEARCH_MINING_3]: {
    cost: new Cost({
      knowledge: 450,
      stone: 250,
      iron: 50,
    }),
  },
  [RESEARCH_MINING_4]: {
    cost: new Cost({
      knowledge: 900,
      stone: 500,
      gold: 50,
    }),
  },
  [RESEARCH_MINING_5]: {
    cost: new Cost({
      knowledge: 1600,
      stone: 700,
      gold: 120,
    }),
  },

  // ── Resources — Knowledge Production ──
  [RESEARCH_KNOWLEDGE_PRODUCTION_1]: {
    cost: new Cost({
      knowledge: 80,
      wood: 50,
    }),
  },
  [RESEARCH_KNOWLEDGE_PRODUCTION_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      stone: 60,
    }),
  },
  [RESEARCH_KNOWLEDGE_PRODUCTION_3]: {
    cost: new Cost({
      knowledge: 500,
      wood: 250,
      copper: 80,
    }),
  },
  [RESEARCH_KNOWLEDGE_PRODUCTION_4]: {
    cost: new Cost({
      knowledge: 900,
      wood: 400,
      iron: 80,
    }),
  },
  [RESEARCH_KNOWLEDGE_PRODUCTION_5]: {
    cost: new Cost({
      knowledge: 1600,
      wood: 600,
      gold: 100,
    }),
  },

  // ── Religion — Faith ──
  [RESEARCH_FAITH_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 40,
    }),
  },
  [RESEARCH_FAITH_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 100,
      stone: 50,
    }),
  },
  [RESEARCH_FAITH_3]: {
    cost: new Cost({
      knowledge: 450,
      wood: 250,
      stone: 120,
    }),
  },
  [RESEARCH_FAITH_4]: {
    cost: new Cost({
      knowledge: 800,
      stone: 300,
      gold: 60,
    }),
  },
  [RESEARCH_FAITH_5]: {
    cost: new Cost({
      knowledge: 1500,
      stone: 500,
      gold: 150,
    }),
  },

  // ── Military — Defense ──
  [RESEARCH_DEFENSE_1]: {
    cost: new Cost({
      knowledge: 80,
      wood: 60,
    }),
  },
  [RESEARCH_DEFENSE_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      copper: 50,
    }),
  },
  [RESEARCH_DEFENSE_3]: {
    cost: new Cost({
      knowledge: 500,
      copper: 200,
      iron: 80,
    }),
  },
  [RESEARCH_DEFENSE_4]: {
    cost: new Cost({
      knowledge: 900,
      iron: 250,
      gold: 60,
    }),
  },
  [RESEARCH_DEFENSE_5]: {
    cost: new Cost({
      knowledge: 1600,
      iron: 500,
      gold: 150,
    }),
  },

  // ── Military — Attack ──
  [RESEARCH_ATTACK_1]: {
    cost: new Cost({
      knowledge: 80,
      wood: 50,
      food: 40,
    }),
  },
  [RESEARCH_ATTACK_2]: {
    cost: new Cost({
      knowledge: 200,
      wood: 120,
      copper: 60,
    }),
  },
  [RESEARCH_ATTACK_3]: {
    cost: new Cost({
      knowledge: 500,
      copper: 200,
      iron: 100,
    }),
  },
  [RESEARCH_ATTACK_4]: {
    cost: new Cost({
      knowledge: 900,
      iron: 300,
      gold: 80,
    }),
  },
  [RESEARCH_ATTACK_5]: {
    cost: new Cost({
      knowledge: 1600,
      iron: 500,
      gold: 200,
    }),
  },

  // ── Military — Warning ──
  [RESEARCH_WARNING_1]: {
    cost: new Cost({
      knowledge: 60,
      wood: 50,
      stone: 30,
    }),
  },
  [RESEARCH_WARNING_2]: {
    cost: new Cost({
      knowledge: 180,
      wood: 100,
      stone: 80,
    }),
  },
  [RESEARCH_WARNING_3]: {
    cost: new Cost({
      knowledge: 450,
      stone: 200,
      copper: 80,
    }),
  },
  [RESEARCH_WARNING_4]: {
    cost: new Cost({
      knowledge: 800,
      stone: 300,
      iron: 100,
    }),
  },
  [RESEARCH_WARNING_5]: {
    cost: new Cost({
      knowledge: 1500,
      iron: 300,
      gold: 100,
    }),
  },
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
