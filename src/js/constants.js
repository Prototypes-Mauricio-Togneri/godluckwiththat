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

// Headquarters progression types (colony upgrades)
export const HQ_TYPE_CAMP = 'camp'
export const HQ_TYPE_SETTLEMENT = 'settlement'
export const HQ_TYPE_VILLAGE = 'village'
export const HQ_TYPE_TOWN = 'town'
export const HQ_TYPE_CITY = 'city'

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

// Buildings that accept worker assignments
export const WORKER_ASSIGNABLE_BUILDINGS = new Set([
  Academy.ID,
  Shrine.ID,
  Temple.ID,
  Farm.ID,
  Woodcutter.ID,
  Quarry.ID,
  CopperMine.ID,
  IronMine.ID,
  GoldMine.ID,
])

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

// Base path for building thumbnail images
export const BUILDING_IMG_PATH = '/img/buildings/'

// Building grid layout — column definitions for the game screen
export const BUILDING_GRID = [
  {
    headerKey: 'buildingGroup.colony',
    buildings: [
      {
        key: Headquarters.ID,
        img: 'misc/headquarters.png',
      },
      {
        key: House.ID,
        img: 'misc/house.png',
      },
      {
        key: Academy.ID,
        img: 'misc/academy.png',
      },
      {
        key: Storehouse.ID,
        img: 'misc/storehouse.png',
      },
      {
        key: Market.ID,
        img: 'misc/market.png',
      },
    ],
  },
  {
    headerKey: 'buildingGroup.economy',
    buildings: [
      {
        key: Farm.ID,
        img: 'resources/farm.png',
      },
      {
        key: Woodcutter.ID,
        img: 'resources/woodcutter.png',
      },
      {
        key: Quarry.ID,
        img: 'resources/quarry.png',
      },
      {
        key: CopperMine.ID,
        img: 'resources/copper_mine.png',
      },
      {
        key: IronMine.ID,
        img: 'resources/iron_mine.png',
      },
      {
        key: GoldMine.ID,
        img: 'resources/gold_mine.png',
      },
    ],
  },
  {
    headerKey: 'buildingGroup.religion',
    buildings: [
      {
        key: Altar.ID,
        img: 'religious/altar.png',
      },
      {
        key: Shrine.ID,
        img: 'religious/shrine.png',
      },
      {
        key: Temple.ID,
        img: 'religious/temple.png',
      },
      {
        key: Monument.ID,
        img: 'religious/monument.png',
      },
    ],
  },
  {
    headerKey: 'buildingGroup.military',
    buildings: [
      {
        key: Barracks.ID,
        img: 'military/barracks.png',
      },
      {
        key: Archery.ID,
        img: 'military/archery.png',
      },
      {
        key: Stable.ID,
        img: 'military/stable.png',
      },
      {
        key: Workshop.ID,
        img: 'military/workshop.png',
      },
      {
        key: Wall.ID,
        img: 'military/wall.png',
      },
      {
        key: Tower.ID,
        img: 'military/tower.png',
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
 * Creates a fresh Colony instance for a new game session.
 * @returns {Colony} Fully initialized colony with default values
 */
export function createInitialColony() {
  return new Colony({
    season: 'warm',
    idleWorkers: 5,

    resources: new Resources({
      territory: 1,
      workers: 5,
      food: 120,
      wood: 80,
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
      territory: 5,
      workers: 5,
      food: 200,
      wood: 100,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      faith: 0,
      knowledge: 0,
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
