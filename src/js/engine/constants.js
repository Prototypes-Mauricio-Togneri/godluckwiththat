import {IMG_BUILDING_ACADEMY, IMG_BUILDING_ALTAR, IMG_BUILDING_ARCHERY, IMG_BUILDING_BARRACKS, IMG_BUILDING_COPPER_MINE, IMG_BUILDING_FARM, IMG_BUILDING_GOLD_MINE, IMG_BUILDING_HEADQUARTERS_CAMP, IMG_BUILDING_HEADQUARTERS_CITY, IMG_BUILDING_HEADQUARTERS_SETTLEMENT, IMG_BUILDING_HEADQUARTERS_TOWN, IMG_BUILDING_HEADQUARTERS_VILLAGE, IMG_BUILDING_HOUSE, IMG_BUILDING_IRON_MINE, IMG_BUILDING_MARKET, IMG_BUILDING_MONUMENT, IMG_BUILDING_QUARRY, IMG_BUILDING_TEMPLE, IMG_BUILDING_STABLE, IMG_BUILDING_STOREHOUSE, IMG_BUILDING_TOWER, IMG_BUILDING_WALL, IMG_BUILDING_WOODCUTTER, IMG_BUILDING_WORKSHOP, IMG_RESOURCE_COPPER, IMG_RESOURCE_FOOD, IMG_RESOURCE_GOLD, IMG_RESOURCE_IRON, IMG_RESOURCE_STONE, IMG_RESOURCE_WOOD, MUS_MUSIC_1, MUS_MUSIC_2, MUS_MUSIC_3, MUS_MUSIC_4, SND_BUILDING_CREATED, SND_BUTTON_TAP, SND_HEADQUARTERS_UPGRADED, SND_MARKET_EXCHANGE, SND_NOTIFICATION_ALERT, SND_NOTIFICATION_SEASON, SND_OPEN_ACADEMY, SND_OPEN_MARKET, SND_RESEARCH_COMPLETED, SND_TERRITORY_EXPANDED, SND_UNDER_ATTACK, SND_WORKER_ACADEMY, SND_WORKER_CREATED, SND_WORKER_FOOD, SND_WORKER_MINE, SND_WORKER_TEMPLE, SND_WORKER_WOOD} from '@/js/engine/assets.js'
import {BUILDING_ACADEMY, BUILDING_ALTAR, BUILDING_ARCHERY, BUILDING_BARRACKS, BUILDING_COPPER_MINE, BUILDING_FARM, BUILDING_GOLD_MINE, BUILDING_HEADQUARTERS, BUILDING_HOUSE, BUILDING_IRON_MINE, BUILDING_MARKET, BUILDING_MONUMENT, BUILDING_QUARRY, BUILDING_TEMPLE, BUILDING_STABLE, BUILDING_STOREHOUSE, BUILDING_TOWER, BUILDING_WALL, BUILDING_WOODCUTTER, BUILDING_WORKSHOP, HQ_TYPE_CAMP, HQ_TYPE_CITY, HQ_TYPE_SETTLEMENT, HQ_TYPE_TOWN, HQ_TYPE_VILLAGE, RESEARCH_ATTACK_1, RESEARCH_ATTACK_2, RESEARCH_ATTACK_3, RESEARCH_ATTACK_4, RESEARCH_ATTACK_5, RESEARCH_CATEGORY_MILITARY, RESEARCH_CATEGORY_GENERAL, RESEARCH_CATEGORY_DISASTERS, RESEARCH_CATEGORY_RELIGION, RESEARCH_CATEGORY_RESOURCES, RESEARCH_CONSTRUCTION_1, RESEARCH_CONSTRUCTION_2, RESEARCH_CONSTRUCTION_3, RESEARCH_CONSTRUCTION_4, RESEARCH_CONSTRUCTION_5, RESEARCH_DEFENSE_1, RESEARCH_DEFENSE_2, RESEARCH_DEFENSE_3, RESEARCH_DEFENSE_4, RESEARCH_DEFENSE_5, RESEARCH_EARTHQUAKES_1, RESEARCH_EARTHQUAKES_2, RESEARCH_EARTHQUAKES_3, RESEARCH_EARTHQUAKES_4, RESEARCH_EARTHQUAKES_5, RESEARCH_EXPANSION_1, RESEARCH_EXPANSION_2, RESEARCH_EXPANSION_3, RESEARCH_EXPANSION_4, RESEARCH_EXPANSION_5, RESEARCH_HABITATION_1, RESEARCH_HABITATION_2, RESEARCH_HABITATION_3, RESEARCH_HABITATION_4, RESEARCH_HABITATION_5, RESEARCH_FAITH_1, RESEARCH_FAITH_2, RESEARCH_FAITH_3, RESEARCH_FAITH_4, RESEARCH_FAITH_5, RESEARCH_FLOODS_1, RESEARCH_FLOODS_2, RESEARCH_FLOODS_3, RESEARCH_FLOODS_4, RESEARCH_FLOODS_5, RESEARCH_FOOD_CONSUMPTION_1, RESEARCH_FOOD_CONSUMPTION_2, RESEARCH_FOOD_CONSUMPTION_3, RESEARCH_FOOD_CONSUMPTION_4, RESEARCH_FOOD_CONSUMPTION_5, RESEARCH_FOOD_PRODUCTION_1, RESEARCH_FOOD_PRODUCTION_2, RESEARCH_FOOD_PRODUCTION_3, RESEARCH_FOOD_PRODUCTION_4, RESEARCH_FOOD_PRODUCTION_5, RESEARCH_HEALTH_1, RESEARCH_HEALTH_2, RESEARCH_HEALTH_3, RESEARCH_HEALTH_4, RESEARCH_HEALTH_5, RESEARCH_KNOWLEDGE_PRODUCTION_1, RESEARCH_KNOWLEDGE_PRODUCTION_2, RESEARCH_KNOWLEDGE_PRODUCTION_3, RESEARCH_KNOWLEDGE_PRODUCTION_4, RESEARCH_KNOWLEDGE_PRODUCTION_5, RESEARCH_MINING_1, RESEARCH_MINING_2, RESEARCH_MINING_3, RESEARCH_MINING_4, RESEARCH_MINING_5, RESEARCH_STORAGE_1, RESEARCH_STORAGE_2, RESEARCH_STORAGE_3, RESEARCH_STORAGE_4, RESEARCH_STORAGE_5, RESEARCH_SUBCATEGORY_ATTACK, RESEARCH_SUBCATEGORY_CONSTRUCTION, RESEARCH_SUBCATEGORY_DEFENSE, RESEARCH_SUBCATEGORY_EARTHQUAKES, RESEARCH_SUBCATEGORY_EXPANSION, RESEARCH_SUBCATEGORY_FAITH, RESEARCH_SUBCATEGORY_FLOODS, RESEARCH_SUBCATEGORY_FOOD_CONSUMPTION, RESEARCH_SUBCATEGORY_FOOD_PRODUCTION, RESEARCH_SUBCATEGORY_HABITATION, RESEARCH_SUBCATEGORY_HEALTH, RESEARCH_SUBCATEGORY_KNOWLEDGE_PRODUCTION, RESEARCH_SUBCATEGORY_MINING, RESEARCH_SUBCATEGORY_STORAGE, RESEARCH_SUBCATEGORY_TRANSPORTATION, RESEARCH_SUBCATEGORY_WARNING, RESEARCH_SUBCATEGORY_WOOD_CONSUMPTION, RESEARCH_SUBCATEGORY_WOOD_PRODUCTION, RESEARCH_TRANSPORTATION_1, RESEARCH_TRANSPORTATION_2, RESEARCH_TRANSPORTATION_3, RESEARCH_TRANSPORTATION_4, RESEARCH_TRANSPORTATION_5, RESEARCH_WARNING_1, RESEARCH_WARNING_2, RESEARCH_WARNING_3, RESEARCH_WARNING_4, RESEARCH_WARNING_5, RESEARCH_WOOD_CONSUMPTION_1, RESEARCH_WOOD_CONSUMPTION_2, RESEARCH_WOOD_CONSUMPTION_3, RESEARCH_WOOD_CONSUMPTION_4, RESEARCH_WOOD_CONSUMPTION_5, RESEARCH_WOOD_PRODUCTION_1, RESEARCH_WOOD_PRODUCTION_2, RESEARCH_WOOD_PRODUCTION_3, RESEARCH_WOOD_PRODUCTION_4, RESEARCH_WOOD_PRODUCTION_5, RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD, SEASON_WARM} from '@/js/engine/enums.js'
import {MARKET_BASE_PRICES, RESEARCH_SUBCATEGORY_BONUSES} from '@/js/engine/balancing.js'
import Academy from '@/js/models/buildings/academy.js'
import Altar from '@/js/models/buildings/altar.js'
import Archery from '@/js/models/buildings/archery.js'
import Barracks from '@/js/models/buildings/barracks.js'
import Buildings from '@/js/models/buildings.js'
import Stable from '@/js/models/buildings/stable.js'
import CopperMine from '@/js/models/buildings/copper_mine.js'
import Farm from '@/js/models/buildings/farm.js'
import GoldMine from '@/js/models/buildings/gold_mine.js'
import Headquarters from '@/js/models/buildings/headquarters.js'
import House from '@/js/models/buildings/house.js'
import IronMine from '@/js/models/buildings/iron_mine.js'
import Market from '@/js/models/buildings/market.js'
import Trades from '@/js/models/trades.js'
import Monument from '@/js/models/buildings/monument.js'
import Quarry from '@/js/models/buildings/quarry.js'
import Storehouse from '@/js/models/buildings/storehouse.js'
import Temple from '@/js/models/buildings/temple.js'
import Tower from '@/js/models/buildings/tower.js'
import Wall from '@/js/models/buildings/wall.js'
import Woodcutter from '@/js/models/buildings/woodcutter.js'
import Workshop from '@/js/models/buildings/workshop.js'
import Colony from '@/js/models/colony.js'
import Consumption from '@/js/models/consumption.js'
import Events from '@/js/models/events/events.js'
import Meta from '@/js/models/meta.js'
import Researches from '@/js/models/researches.js'
import Production from '@/js/models/production.js'
import Resources from '@/js/models/resources.js'
import Stockpile from '@/js/models/stockpile.js'

// Structural constants — class maps, sets, and factory functions.

// Tick interval in milliseconds
export const TICK_INTERVAL = 1000

// Seconds-per-minute conversion for production rate display
export const SECONDS_PER_MINUTE = 60

// Ordered resource keys shown in the game header
export const HEADER_RESOURCES = [
  RESOURCE_FOOD,
  RESOURCE_WOOD,
  RESOURCE_STONE,
  RESOURCE_COPPER,
  RESOURCE_IRON,
  RESOURCE_GOLD,
  RESOURCE_KNOWLEDGE,
  RESOURCE_FAITH,
]

// Bounded resources (subject to stockpile caps)
export const BOUNDED_RESOURCES = [
  RESOURCE_FOOD,
  RESOURCE_WOOD,
  RESOURCE_STONE,
  RESOURCE_COPPER,
  RESOURCE_IRON,
  RESOURCE_GOLD,
]

// Resources without a stockpile capacity (no progress bar, no "full in" estimate)
export const UNBOUNDED_RESOURCES = [
  RESOURCE_KNOWLEDGE,
  RESOURCE_FAITH,
]

// Resources that can be traded at the market (exchanged for gold)
export const TRADEABLE_RESOURCES = [
  RESOURCE_FOOD,
  RESOURCE_WOOD,
  RESOURCE_STONE,
  RESOURCE_COPPER,
  RESOURCE_IRON,
]

// Config for resource-limit-reached events (textKey + icon per bounded resource)
export const RESOURCE_LIMIT_EVENT_CONFIG = {
  [RESOURCE_FOOD]: {
    textKey: 'event.foodLimitReached',
    icon: IMG_RESOURCE_FOOD,
  },
  [RESOURCE_WOOD]: {
    textKey: 'event.woodLimitReached',
    icon: IMG_RESOURCE_WOOD,
  },
  [RESOURCE_STONE]: {
    textKey: 'event.stoneLimitReached',
    icon: IMG_RESOURCE_STONE,
  },
  [RESOURCE_COPPER]: {
    textKey: 'event.copperLimitReached',
    icon: IMG_RESOURCE_COPPER,
  },
  [RESOURCE_IRON]: {
    textKey: 'event.ironLimitReached',
    icon: IMG_RESOURCE_IRON,
  },
  [RESOURCE_GOLD]: {
    textKey: 'event.goldLimitReached',
    icon: IMG_RESOURCE_GOLD,
  },
}

// Config for negative-production events (textKey + icon per bounded resource)
export const RESOURCE_NEGATIVE_PRODUCTION_EVENT_CONFIG = {
  [RESOURCE_FOOD]: {
    textKey: 'event.foodNegativeProduction',
    icon: IMG_RESOURCE_FOOD,
  },
  [RESOURCE_WOOD]: {
    textKey: 'event.woodNegativeProduction',
    icon: IMG_RESOURCE_WOOD,
  },
  [RESOURCE_STONE]: {
    textKey: 'event.stoneNegativeProduction',
    icon: IMG_RESOURCE_STONE,
  },
  [RESOURCE_COPPER]: {
    textKey: 'event.copperNegativeProduction',
    icon: IMG_RESOURCE_COPPER,
  },
  [RESOURCE_IRON]: {
    textKey: 'event.ironNegativeProduction',
    icon: IMG_RESOURCE_IRON,
  },
  [RESOURCE_GOLD]: {
    textKey: 'event.goldNegativeProduction',
    icon: IMG_RESOURCE_GOLD,
  },
}

// Ordered headquarters progression (used for upgrade lookups)
export const HQ_TYPES = [
  HQ_TYPE_CAMP,
  HQ_TYPE_SETTLEMENT,
  HQ_TYPE_VILLAGE,
  HQ_TYPE_TOWN,
  HQ_TYPE_CITY,
]

// Headquarters image lookup by type
export const IMG_BUILDING_HEADQUARTERS_MAP = {
  [HQ_TYPE_CAMP]: IMG_BUILDING_HEADQUARTERS_CAMP,
  [HQ_TYPE_SETTLEMENT]: IMG_BUILDING_HEADQUARTERS_SETTLEMENT,
  [HQ_TYPE_VILLAGE]: IMG_BUILDING_HEADQUARTERS_VILLAGE,
  [HQ_TYPE_TOWN]: IMG_BUILDING_HEADQUARTERS_TOWN,
  [HQ_TYPE_CITY]: IMG_BUILDING_HEADQUARTERS_CITY,
}

// Buildings unlocked at each headquarters type (non-cumulative per tier)
export const HQ_BUILDING_UNLOCKS = {
  [HQ_TYPE_CAMP]: [
    BUILDING_HOUSE,
    BUILDING_ALTAR,
    BUILDING_FARM,
    BUILDING_WOODCUTTER,
  ],
  [HQ_TYPE_SETTLEMENT]: [
    BUILDING_STOREHOUSE,
    BUILDING_TEMPLE,
    BUILDING_QUARRY,
    BUILDING_BARRACKS,
  ],
  [HQ_TYPE_VILLAGE]: [
    BUILDING_ACADEMY,
    BUILDING_COPPER_MINE,
    BUILDING_ARCHERY,
  ],
  [HQ_TYPE_TOWN]: [
    BUILDING_MONUMENT,
    BUILDING_IRON_MINE,
    BUILDING_STABLE,
    BUILDING_WALL,
  ],
  [HQ_TYPE_CITY]: [
    BUILDING_MARKET,
    BUILDING_GOLD_MINE,
    BUILDING_WORKSHOP,
    BUILDING_TOWER,
  ],
}

// Resources unlocked at each headquarters type (non-cumulative per tier)
export const HQ_RESOURCE_UNLOCKS = {
  [HQ_TYPE_CAMP]: [
    RESOURCE_FOOD,
    RESOURCE_WOOD,
    RESOURCE_FAITH,
  ],
  [HQ_TYPE_SETTLEMENT]: [
    RESOURCE_STONE,
    RESOURCE_KNOWLEDGE,
  ],
  [HQ_TYPE_VILLAGE]: [RESOURCE_COPPER],
  [HQ_TYPE_TOWN]: [RESOURCE_IRON],
  [HQ_TYPE_CITY]: [RESOURCE_GOLD],
}

// Building class map — resolves building keys to their class constructors
export const BUILDING_CLASS_MAP = {
  [BUILDING_HEADQUARTERS]: Headquarters,
  [BUILDING_HOUSE]: House,
  [BUILDING_ACADEMY]: Academy,
  [BUILDING_STOREHOUSE]: Storehouse,
  [BUILDING_MARKET]: Market,
  [BUILDING_FARM]: Farm,
  [BUILDING_WOODCUTTER]: Woodcutter,
  [BUILDING_QUARRY]: Quarry,
  [BUILDING_COPPER_MINE]: CopperMine,
  [BUILDING_IRON_MINE]: IronMine,
  [BUILDING_GOLD_MINE]: GoldMine,
  [BUILDING_ALTAR]: Altar,
  [BUILDING_TEMPLE]: Temple,
  [BUILDING_MONUMENT]: Monument,
  [BUILDING_BARRACKS]: Barracks,
  [BUILDING_ARCHERY]: Archery,
  [BUILDING_STABLE]: Stable,
  [BUILDING_WORKSHOP]: Workshop,
  [BUILDING_WALL]: Wall,
  [BUILDING_TOWER]: Tower,
}

// Building grid layout — column definitions for the game screen
export const BUILDING_GRID = [
  {
    headerKey: 'buildingGroup.colony',
    buildings: [
      {
        key: BUILDING_HEADQUARTERS,
        img: IMG_BUILDING_HEADQUARTERS_CAMP,
      },
      {
        key: BUILDING_HOUSE,
        img: IMG_BUILDING_HOUSE,
      },
      {
        key: BUILDING_STOREHOUSE,
        img: IMG_BUILDING_STOREHOUSE,
      },
      {
        key: BUILDING_ACADEMY,
        img: IMG_BUILDING_ACADEMY,
      },
      {
        key: BUILDING_MARKET,
        img: IMG_BUILDING_MARKET,
      },
    ],
  },
  {
    headerKey: 'buildingGroup.economy',
    buildings: [
      {
        key: BUILDING_FARM,
        img: IMG_BUILDING_FARM,
      },
      {
        key: BUILDING_WOODCUTTER,
        img: IMG_BUILDING_WOODCUTTER,
      },
      {
        key: BUILDING_QUARRY,
        img: IMG_BUILDING_QUARRY,
      },
      {
        key: BUILDING_COPPER_MINE,
        img: IMG_BUILDING_COPPER_MINE,
      },
      {
        key: BUILDING_IRON_MINE,
        img: IMG_BUILDING_IRON_MINE,
      },
      {
        key: BUILDING_GOLD_MINE,
        img: IMG_BUILDING_GOLD_MINE,
      },
    ],
  },
  {
    headerKey: 'buildingGroup.religion',
    buildings: [
      {
        key: BUILDING_ALTAR,
        img: IMG_BUILDING_ALTAR,
      },
      {
        key: BUILDING_TEMPLE,
        img: IMG_BUILDING_TEMPLE,
      },
      {
        key: BUILDING_MONUMENT,
        img: IMG_BUILDING_MONUMENT,
      },
    ],
  },
  {
    headerKey: 'buildingGroup.military',
    buildings: [
      {
        key: BUILDING_BARRACKS,
        img: IMG_BUILDING_BARRACKS,
      },
      {
        key: BUILDING_ARCHERY,
        img: IMG_BUILDING_ARCHERY,
      },
      {
        key: BUILDING_STABLE,
        img: IMG_BUILDING_STABLE,
      },
      {
        key: BUILDING_WORKSHOP,
        img: IMG_BUILDING_WORKSHOP,
      },
      {
        key: BUILDING_WALL,
        img: IMG_BUILDING_WALL,
      },
      {
        key: BUILDING_TOWER,
        img: IMG_BUILDING_TOWER,
      },
    ],
  },
]

// Building image lookup by key (for event icons)
export const BUILDING_IMAGE_MAP = Object.fromEntries(
  BUILDING_GRID.flatMap(column => column.buildings.map(b => [
    b.key,
    b.img,
  ])),
)

// Per-file audio configuration (volume 0.0–1.0)
export const AUDIO_CONFIG = {
  [SND_BUILDING_CREATED]: {
    volume: 1,
  },
  [SND_BUTTON_TAP]: {
    volume: 0.5,
  },
  [SND_HEADQUARTERS_UPGRADED]: {
    volume: 1,
  },
  [SND_TERRITORY_EXPANDED]: {
    volume: 0.8,
  },
  [SND_NOTIFICATION_ALERT]: {
    volume: 0.8,
  },
  [SND_NOTIFICATION_SEASON]: {
    volume: 0.8,
  },
  [SND_RESEARCH_COMPLETED]: {
    volume: 0.8,
  },
  [SND_UNDER_ATTACK]: {
    volume: 0.7,
  },
  [SND_WORKER_ACADEMY]: {
    volume: 0.3,
  },
  [SND_WORKER_CREATED]: {
    volume: 0.5,
  },
  [SND_WORKER_FOOD]: {
    volume: 0.1,
  },
  [SND_WORKER_MINE]: {
    volume: 0.3,
  },
  [SND_WORKER_TEMPLE]: {
    volume: 0.3,
  },
  [SND_WORKER_WOOD]: {
    volume: 0.3,
  },
  [SND_MARKET_EXCHANGE]: {
    volume: 0.6,
  },
  [SND_OPEN_ACADEMY]: {
    volume: 0.6,
  },
  [SND_OPEN_MARKET]: {
    volume: 0.6,
  },
  [MUS_MUSIC_1]: {
    volume: 0.3,
  },
  [MUS_MUSIC_2]: {
    volume: 0.3,
  },
  [MUS_MUSIC_3]: {
    volume: 0.3,
  },
  [MUS_MUSIC_4]: {
    volume: 0.3,
  },
}

// Research tree — ordered categories → subcategories → linear research chains.
// Position in the researches array implies linear prerequisite (index N requires N-1).
export const RESEARCH_TREE = [
  {
    category: RESEARCH_CATEGORY_GENERAL,
    subcategories: [
      {
        key: RESEARCH_SUBCATEGORY_TRANSPORTATION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_TRANSPORTATION],
        researches: [
          RESEARCH_TRANSPORTATION_1,
          RESEARCH_TRANSPORTATION_2,
          RESEARCH_TRANSPORTATION_3,
          RESEARCH_TRANSPORTATION_4,
          RESEARCH_TRANSPORTATION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_CONSTRUCTION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_CONSTRUCTION],
        researches: [
          RESEARCH_CONSTRUCTION_1,
          RESEARCH_CONSTRUCTION_2,
          RESEARCH_CONSTRUCTION_3,
          RESEARCH_CONSTRUCTION_4,
          RESEARCH_CONSTRUCTION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_EXPANSION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_EXPANSION],
        researches: [
          RESEARCH_EXPANSION_1,
          RESEARCH_EXPANSION_2,
          RESEARCH_EXPANSION_3,
          RESEARCH_EXPANSION_4,
          RESEARCH_EXPANSION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_STORAGE,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_STORAGE],
        researches: [
          RESEARCH_STORAGE_1,
          RESEARCH_STORAGE_2,
          RESEARCH_STORAGE_3,
          RESEARCH_STORAGE_4,
          RESEARCH_STORAGE_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_HABITATION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_HABITATION],
        researches: [
          RESEARCH_HABITATION_1,
          RESEARCH_HABITATION_2,
          RESEARCH_HABITATION_3,
          RESEARCH_HABITATION_4,
          RESEARCH_HABITATION_5,
        ],
      },
    ],
  },
  {
    category: RESEARCH_CATEGORY_RESOURCES,
    subcategories: [
      {
        key: RESEARCH_SUBCATEGORY_FOOD_PRODUCTION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_FOOD_PRODUCTION],
        researches: [
          RESEARCH_FOOD_PRODUCTION_1,
          RESEARCH_FOOD_PRODUCTION_2,
          RESEARCH_FOOD_PRODUCTION_3,
          RESEARCH_FOOD_PRODUCTION_4,
          RESEARCH_FOOD_PRODUCTION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_FOOD_CONSUMPTION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_FOOD_CONSUMPTION],
        researches: [
          RESEARCH_FOOD_CONSUMPTION_1,
          RESEARCH_FOOD_CONSUMPTION_2,
          RESEARCH_FOOD_CONSUMPTION_3,
          RESEARCH_FOOD_CONSUMPTION_4,
          RESEARCH_FOOD_CONSUMPTION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_WOOD_PRODUCTION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_WOOD_PRODUCTION],
        researches: [
          RESEARCH_WOOD_PRODUCTION_1,
          RESEARCH_WOOD_PRODUCTION_2,
          RESEARCH_WOOD_PRODUCTION_3,
          RESEARCH_WOOD_PRODUCTION_4,
          RESEARCH_WOOD_PRODUCTION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_WOOD_CONSUMPTION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_WOOD_CONSUMPTION],
        researches: [
          RESEARCH_WOOD_CONSUMPTION_1,
          RESEARCH_WOOD_CONSUMPTION_2,
          RESEARCH_WOOD_CONSUMPTION_3,
          RESEARCH_WOOD_CONSUMPTION_4,
          RESEARCH_WOOD_CONSUMPTION_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_MINING,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_MINING],
        researches: [
          RESEARCH_MINING_1,
          RESEARCH_MINING_2,
          RESEARCH_MINING_3,
          RESEARCH_MINING_4,
          RESEARCH_MINING_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_KNOWLEDGE_PRODUCTION,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_KNOWLEDGE_PRODUCTION],
        researches: [
          RESEARCH_KNOWLEDGE_PRODUCTION_1,
          RESEARCH_KNOWLEDGE_PRODUCTION_2,
          RESEARCH_KNOWLEDGE_PRODUCTION_3,
          RESEARCH_KNOWLEDGE_PRODUCTION_4,
          RESEARCH_KNOWLEDGE_PRODUCTION_5,
        ],
      },
    ],
  },
  {
    category: RESEARCH_CATEGORY_DISASTERS,
    subcategories: [
      {
        key: RESEARCH_SUBCATEGORY_FLOODS,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_FLOODS],
        researches: [
          RESEARCH_FLOODS_1,
          RESEARCH_FLOODS_2,
          RESEARCH_FLOODS_3,
          RESEARCH_FLOODS_4,
          RESEARCH_FLOODS_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_HEALTH,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_HEALTH],
        researches: [
          RESEARCH_HEALTH_1,
          RESEARCH_HEALTH_2,
          RESEARCH_HEALTH_3,
          RESEARCH_HEALTH_4,
          RESEARCH_HEALTH_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_EARTHQUAKES,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_EARTHQUAKES],
        researches: [
          RESEARCH_EARTHQUAKES_1,
          RESEARCH_EARTHQUAKES_2,
          RESEARCH_EARTHQUAKES_3,
          RESEARCH_EARTHQUAKES_4,
          RESEARCH_EARTHQUAKES_5,
        ],
      },
    ],
  },
  {
    category: RESEARCH_CATEGORY_RELIGION,
    subcategories: [
      {
        key: RESEARCH_SUBCATEGORY_FAITH,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_FAITH],
        researches: [
          RESEARCH_FAITH_1,
          RESEARCH_FAITH_2,
          RESEARCH_FAITH_3,
          RESEARCH_FAITH_4,
          RESEARCH_FAITH_5,
        ],
      },
    ],
  },
  {
    category: RESEARCH_CATEGORY_MILITARY,
    subcategories: [
      {
        key: RESEARCH_SUBCATEGORY_DEFENSE,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_DEFENSE],
        researches: [
          RESEARCH_DEFENSE_1,
          RESEARCH_DEFENSE_2,
          RESEARCH_DEFENSE_3,
          RESEARCH_DEFENSE_4,
          RESEARCH_DEFENSE_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_ATTACK,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_ATTACK],
        researches: [
          RESEARCH_ATTACK_1,
          RESEARCH_ATTACK_2,
          RESEARCH_ATTACK_3,
          RESEARCH_ATTACK_4,
          RESEARCH_ATTACK_5,
        ],
      },
      {
        key: RESEARCH_SUBCATEGORY_WARNING,
        bonus: RESEARCH_SUBCATEGORY_BONUSES[RESEARCH_SUBCATEGORY_WARNING],
        researches: [
          RESEARCH_WARNING_1,
          RESEARCH_WARNING_2,
          RESEARCH_WARNING_3,
          RESEARCH_WARNING_4,
          RESEARCH_WARNING_5,
        ],
      },
    ],
  },
]

/**
 * Creates a fresh Meta instance for a new game session.
 * @returns {Meta} Initialized meta with current timestamps
 */
export function createInitialMeta() {
  return new Meta({
    version: 1,
    createdDateTime: new Date(),
    updatedDateTime: new Date(),
    numberOfChallenges: 10,
  })
}

/**
 * Creates the colony used for a new game session.
 * @returns {Colony} Fully initialized colony
 */
export function createInitialColony() {
  return createInitialColonyAdvanced()
}

/**
 * Creates a fresh Colony instance for a new game session.
 * @returns {Colony} Fully initialized colony with default values
 */
export function createInitialColonyBasic() {
  return new Colony({
    year: 1,
    season: SEASON_WARM,
    seasonElapsed: 0,
    idleWorkers: 0,

    resources: new Resources({
      territory: 0,
      workers: 0,
      food: 200,
      wood: 200,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      faith: 0,
      knowledge: 0,
    }),

    production: new Production({
      food: 0,
      wood: 0,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      faith: 0,
      knowledge: 0,
    }),

    consumption: new Consumption({}),

    stockpile: new Stockpile({
      territory: 0,
      workers: 0,
      food: 0,
      wood: 0,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
    }),

    researches: new Researches(),

    trades: new Trades(MARKET_BASE_PRICES),

    buildings: new Buildings({
      [BUILDING_HEADQUARTERS]: new Headquarters({
        type: HQ_TYPE_CAMP,
        level: 1,
      }),
      [BUILDING_HOUSE]: new House({
        level: 0,
      }),
      [BUILDING_ACADEMY]: new Academy({
        level: 0,
      }),
      [BUILDING_STOREHOUSE]: new Storehouse({
        level: 0,
      }),
      [BUILDING_MARKET]: new Market({
        level: 0,
      }),
      [BUILDING_ALTAR]: new Altar({
        level: 0,
      }),
      [BUILDING_TEMPLE]: new Temple({
        level: 0,
      }),
      [BUILDING_MONUMENT]: new Monument({
        level: 0,
      }),
      [BUILDING_FARM]: new Farm({
        level: 0,
      }),
      [BUILDING_WOODCUTTER]: new Woodcutter({
        level: 0,
      }),
      [BUILDING_QUARRY]: new Quarry({
        level: 0,
      }),
      [BUILDING_COPPER_MINE]: new CopperMine({
        level: 0,
      }),
      [BUILDING_IRON_MINE]: new IronMine({
        level: 0,
      }),
      [BUILDING_GOLD_MINE]: new GoldMine({
        level: 0,
      }),
      [BUILDING_BARRACKS]: new Barracks({
        level: 0,
      }),
      [BUILDING_ARCHERY]: new Archery({
        level: 0,
      }),
      [BUILDING_STABLE]: new Stable({
        level: 0,
      }),
      [BUILDING_WORKSHOP]: new Workshop({
        level: 0,
      }),
      [BUILDING_WALL]: new Wall({
        level: 0,
      }),
      [BUILDING_TOWER]: new Tower({
        level: 0,
      }),
    }),
  })
}

/**
 * Creates a fresh Colony instance for a new game session.
 * @returns {Colony} Fully initialized colony with default values
 */
export function createInitialColonyAdvanced() {
  return new Colony({
    year: 1,
    season: SEASON_WARM,
    seasonElapsed: 0,
    idleWorkers: 0,

    resources: new Resources({
      territory: 0,
      workers: 60,
      food: 1000,
      wood: 123456,
      stone: 1000,
      copper: 1000,
      iron: 1000,
      gold: 1000,
      faith: 0,
      knowledge: 1500,
    }),

    production: new Production({
      food: 0,
      wood: 0,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      faith: 0,
      knowledge: 0,
    }),

    consumption: new Consumption({}),

    stockpile: new Stockpile({
      territory: 0,
      workers: 0,
      food: 0,
      wood: 0,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
    }),

    researches: new Researches(),

    trades: new Trades(MARKET_BASE_PRICES),

    buildings: new Buildings({
      [BUILDING_HEADQUARTERS]: new Headquarters({
        type: HQ_TYPE_CITY,
        level: 5,
      }),
      [BUILDING_HOUSE]: new House({
        level: 15,
      }),
      [BUILDING_ACADEMY]: new Academy({
        level: 1,
      }),
      [BUILDING_STOREHOUSE]: new Storehouse({
        level: 5,
      }),
      [BUILDING_MARKET]: new Market({
        level: 1,
      }),
      [BUILDING_ALTAR]: new Altar({
        level: 0,
      }),
      [BUILDING_TEMPLE]: new Temple({
        level: 0,
      }),
      [BUILDING_MONUMENT]: new Monument({
        level: 0,
      }),
      [BUILDING_FARM]: new Farm({
        level: 2,
        workers: 10,
      }),
      [BUILDING_WOODCUTTER]: new Woodcutter({
        level: 2,
        workers: 10,
      }),
      [BUILDING_QUARRY]: new Quarry({
        level: 2,
        workers: 10,
      }),
      [BUILDING_COPPER_MINE]: new CopperMine({
        level: 2,
        workers: 10,
      }),
      [BUILDING_IRON_MINE]: new IronMine({
        level: 2,
        workers: 10,
      }),
      [BUILDING_GOLD_MINE]: new GoldMine({
        level: 2,
        workers: 10,
      }),
      [BUILDING_BARRACKS]: new Barracks({
        level: 0,
      }),
      [BUILDING_ARCHERY]: new Archery({
        level: 0,
      }),
      [BUILDING_STABLE]: new Stable({
        level: 0,
      }),
      [BUILDING_WORKSHOP]: new Workshop({
        level: 0,
      }),
      [BUILDING_WALL]: new Wall({
        level: 0,
      }),
      [BUILDING_TOWER]: new Tower({
        level: 0,
      }),
    }),
  })
}

/**
 * Creates a pre-populated Events instance for a new game session.
 * @returns {Events} Events with sample future and past events
 */
export function createInitialEvents() {
  return new Events()
}
