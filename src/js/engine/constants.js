import {IMG_BUILDING_ACADEMY, IMG_BUILDING_ALTAR, IMG_BUILDING_ARCHERY, IMG_BUILDING_BARRACKS, IMG_BUILDING_COPPER_MINE, IMG_BUILDING_FARM, IMG_BUILDING_GOLD_MINE, IMG_BUILDING_HEADQUARTERS, IMG_BUILDING_HOUSE, IMG_BUILDING_IRON_MINE, IMG_BUILDING_MARKET, IMG_BUILDING_MONUMENT, IMG_BUILDING_QUARRY, IMG_BUILDING_SHRINE, IMG_BUILDING_STABLE, IMG_BUILDING_STOREHOUSE, IMG_BUILDING_TEMPLE, IMG_BUILDING_TOWER, IMG_BUILDING_WALL, IMG_BUILDING_WOODCUTTER, IMG_BUILDING_WORKSHOP, IMG_RESOURCE_COPPER, IMG_RESOURCE_FOOD, IMG_RESOURCE_GOLD, IMG_RESOURCE_IRON, IMG_RESOURCE_STONE, IMG_RESOURCE_WOOD} from '@/js/engine/assets.js'
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
import Monument from '@/js/models/buildings/monument.js'
import Quarry from '@/js/models/buildings/quarry.js'
import Shrine from '@/js/models/buildings/shrine.js'
import Storehouse from '@/js/models/buildings/storehouse.js'
import Temple from '@/js/models/buildings/temple.js'
import Tower from '@/js/models/buildings/tower.js'
import Wall from '@/js/models/buildings/wall.js'
import Woodcutter from '@/js/models/buildings/woodcutter.js'
import Workshop from '@/js/models/buildings/workshop.js'
import Colony from '@/js/models/colony.js'
import Events from '@/js/models/events/events.js'
import Meta from '@/js/models/meta.js'
import Production from '@/js/models/production.js'
import Resources from '@/js/models/resources.js'
import Stockpile from '@/js/models/stockpile.js'

// Structural constants — class maps, enums, sets, and factory functions.

// Tick interval in milliseconds
export const TICK_INTERVAL = 1000

// Seconds-per-minute conversion for production rate display
export const SECONDS_PER_MINUTE = 60

// Resource names
export const RESOURCE_FOOD = 'food'
export const RESOURCE_WOOD = 'wood'
export const RESOURCE_STONE = 'stone'
export const RESOURCE_COPPER = 'copper'
export const RESOURCE_IRON = 'iron'
export const RESOURCE_GOLD = 'gold'
export const RESOURCE_KNOWLEDGE = 'knowledge'
export const RESOURCE_FAITH = 'faith'

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

// Headquarters progression types (colony upgrades)
export const HQ_TYPE_CAMP = 'camp'
export const HQ_TYPE_SETTLEMENT = 'settlement'
export const HQ_TYPE_VILLAGE = 'village'
export const HQ_TYPE_TOWN = 'town'
export const HQ_TYPE_CITY = 'city'

// Season identifiers
export const SEASON_WARM = 'warm'
export const SEASON_COLD = 'cold'

// Event types
export const EVENT_TYPE_SEASON_CHANGED = 'season_changed'
export const EVENT_TYPE_POPULATION_LIMIT_REACHED = 'population_limit_reached'
export const EVENT_TYPE_TERRITORY_LIMIT_REACHED = 'territory_limit_reached'
export const EVENT_TYPE_RESOURCE_LIMIT_REACHED = 'resource_limit_reached'
export const EVENT_TYPE_WORKER_DIED_FOOD = 'worker_died_food'
export const EVENT_TYPE_WORKER_DIED_WOOD = 'worker_died_wood'
export const EVENT_TYPE_RESOURCE_NEGATIVE_PRODUCTION = 'resource_negative_production'
export const EVENT_TYPE_BUILDING_UPGRADE = 'building_upgrade'

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

// Buildings unlocked at each headquarters type (non-cumulative per tier)
export const HQ_BUILDING_UNLOCKS = {
  [HQ_TYPE_CAMP]: [
    House.ID,
    Altar.ID,
    Farm.ID,
    Woodcutter.ID,
  ],
  [HQ_TYPE_SETTLEMENT]: [
    Academy.ID,
    Shrine.ID,
    Quarry.ID,
    Barracks.ID,
  ],
  [HQ_TYPE_VILLAGE]: [
    Storehouse.ID,
    Temple.ID,
    CopperMine.ID,
    Archery.ID,
  ],
  [HQ_TYPE_TOWN]: [
    Monument.ID,
    IronMine.ID,
    Stable.ID,
    Wall.ID,
  ],
  [HQ_TYPE_CITY]: [
    Market.ID,
    GoldMine.ID,
    Workshop.ID,
    Tower.ID,
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
  [Headquarters.ID]: Headquarters,
  [House.ID]: House,
  [Academy.ID]: Academy,
  [Storehouse.ID]: Storehouse,
  [Market.ID]: Market,
  [Farm.ID]: Farm,
  [Woodcutter.ID]: Woodcutter,
  [Quarry.ID]: Quarry,
  [CopperMine.ID]: CopperMine,
  [IronMine.ID]: IronMine,
  [GoldMine.ID]: GoldMine,
  [Altar.ID]: Altar,
  [Shrine.ID]: Shrine,
  [Temple.ID]: Temple,
  [Monument.ID]: Monument,
  [Barracks.ID]: Barracks,
  [Archery.ID]: Archery,
  [Stable.ID]: Stable,
  [Workshop.ID]: Workshop,
  [Wall.ID]: Wall,
  [Tower.ID]: Tower,
}

// Building grid layout — column definitions for the game screen
export const BUILDING_GRID = [
  {
    headerKey: 'buildingGroup.colony',
    buildings: [
      {
        key: Headquarters.ID,
        img: IMG_BUILDING_HEADQUARTERS,
      },
      {
        key: House.ID,
        img: IMG_BUILDING_HOUSE,
      },
      {
        key: Academy.ID,
        img: IMG_BUILDING_ACADEMY,
      },
      {
        key: Storehouse.ID,
        img: IMG_BUILDING_STOREHOUSE,
      },
      {
        key: Market.ID,
        img: IMG_BUILDING_MARKET,
      },
    ],
  },
  {
    headerKey: 'buildingGroup.economy',
    buildings: [
      {
        key: Farm.ID,
        img: IMG_BUILDING_FARM,
      },
      {
        key: Woodcutter.ID,
        img: IMG_BUILDING_WOODCUTTER,
      },
      {
        key: Quarry.ID,
        img: IMG_BUILDING_QUARRY,
      },
      {
        key: CopperMine.ID,
        img: IMG_BUILDING_COPPER_MINE,
      },
      {
        key: IronMine.ID,
        img: IMG_BUILDING_IRON_MINE,
      },
      {
        key: GoldMine.ID,
        img: IMG_BUILDING_GOLD_MINE,
      },
    ],
  },
  {
    headerKey: 'buildingGroup.religion',
    buildings: [
      {
        key: Altar.ID,
        img: IMG_BUILDING_ALTAR,
      },
      {
        key: Shrine.ID,
        img: IMG_BUILDING_SHRINE,
      },
      {
        key: Temple.ID,
        img: IMG_BUILDING_TEMPLE,
      },
      {
        key: Monument.ID,
        img: IMG_BUILDING_MONUMENT,
      },
    ],
  },
  {
    headerKey: 'buildingGroup.military',
    buildings: [
      {
        key: Barracks.ID,
        img: IMG_BUILDING_BARRACKS,
      },
      {
        key: Archery.ID,
        img: IMG_BUILDING_ARCHERY,
      },
      {
        key: Stable.ID,
        img: IMG_BUILDING_STABLE,
      },
      {
        key: Workshop.ID,
        img: IMG_BUILDING_WORKSHOP,
      },
      {
        key: Wall.ID,
        img: IMG_BUILDING_WALL,
      },
      {
        key: Tower.ID,
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
 * Creates a fresh Colony instance for a new game session.
 * @returns {Colony} Fully initialized colony with default values
 */
export function createInitialColony() {
  return new Colony({
    year: 1,
    season: SEASON_WARM,
    seasonElapsed: 0,
    idleWorkers: 5,

    resources: new Resources({
      territory: 0,
      workers: 5,
      food: 50,
      wood: 500,
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

    stockpile: new Stockpile({
      territory: 20,
      workers: 5,
      food: 100,
      wood: 100,
      stone: 100,
      copper: 100,
      iron: 100,
      gold: 100,
    }),

    buildings: new Buildings({
      [Headquarters.ID]: new Headquarters({
        type: HQ_TYPE_CAMP,
        level: 1,
      }),
      [House.ID]: new House({
        level: 0,
      }),
      [Academy.ID]: new Academy({
        level: 0,
      }),
      [Storehouse.ID]: new Storehouse({
        level: 0,
      }),
      [Market.ID]: new Market({
        level: 0,
      }),
      [Altar.ID]: new Altar({
        level: 0,
      }),
      [Shrine.ID]: new Shrine({
        level: 0,
      }),
      [Temple.ID]: new Temple({
        level: 0,
      }),
      [Monument.ID]: new Monument({
        level: 0,
      }),
      [Farm.ID]: new Farm({
        level: 0,
      }),
      [Woodcutter.ID]: new Woodcutter({
        level: 0,
      }),
      [Quarry.ID]: new Quarry({
        level: 0,
      }),
      [CopperMine.ID]: new CopperMine({
        level: 0,
      }),
      [IronMine.ID]: new IronMine({
        level: 0,
      }),
      [GoldMine.ID]: new GoldMine({
        level: 0,
      }),
      [Barracks.ID]: new Barracks({
        level: 0,
      }),
      [Archery.ID]: new Archery({
        level: 0,
      }),
      [Stable.ID]: new Stable({
        level: 0,
      }),
      [Workshop.ID]: new Workshop({
        level: 0,
      }),
      [Wall.ID]: new Wall({
        level: 0,
      }),
      [Tower.ID]: new Tower({
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
