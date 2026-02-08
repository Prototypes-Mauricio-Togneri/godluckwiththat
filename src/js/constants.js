import Cost from '@/js/models/cost.js'
import Academy from '@/js/models/buildings/academy.js'
import Altar from '@/js/models/buildings/altar.js'
import Archery from '@/js/models/buildings/archery.js'
import Barracks from '@/js/models/buildings/barracks.js'
import Buildings from '@/js/models/buildings/buildings.js'
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
import Production from '@/js/models/production.js'
import Resources from '@/js/models/resources.js'
import Stockpile from '@/js/models/stockpile.js'

// Centralized magic constants

// Headquarters progression types (colony upgrades)
export const HQ_TYPE_CAMP = 'camp'
export const HQ_TYPE_SETTLEMENT = 'settlement'
export const HQ_TYPE_VILLAGE = 'village'
export const HQ_TYPE_TOWN = 'town'
export const HQ_TYPE_CITY = 'city'

// Ordered headquarters progression (used for upgrade lookups)
export const HQ_TYPES = [HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_VILLAGE, HQ_TYPE_TOWN, HQ_TYPE_CITY]

// Worker recruitment cost (always 50 food)
export const WORKER_RECRUIT_COST = new Cost({
  food: 50,
})

// Headquarters level-up formula: wood = floor(BASE * MULTIPLIER ^ (level - 1))
export const HQ_LEVEL_UP_BASE_WOOD = 20
export const HQ_LEVEL_UP_MULTIPLIER = 2.5

// Base path for building thumbnail images
export const BUILDING_IMG_PATH = '/img/buildings/'

// Building grid layout — column definitions for the game screen
export const BUILDING_GRID = [
  {
    headerKey: 'buildingGroup.colony',
    buildings: [
      {
        key: 'headquarters',
        img: 'misc/headquarters.png',
      },
      {
        key: 'house',
        img: 'misc/house.png',
      },
      {
        key: 'academy',
        img: 'misc/academy.png',
      },
      {
        key: 'storehouse',
        img: 'misc/storehouse.png',
      },
      {
        key: 'market',
        img: 'misc/market.png',
      },
    ],
  },
  {
    headerKey: 'buildingGroup.economy',
    buildings: [
      {
        key: 'farm',
        img: 'resources/farm.png',
      },
      {
        key: 'woodcutter',
        img: 'resources/woodcutter.png',
      },
      {
        key: 'quarry',
        img: 'resources/quarry.png',
      },
      {
        key: 'copperMine',
        img: 'resources/copper_mine.png',
      },
      {
        key: 'ironMine',
        img: 'resources/iron_mine.png',
      },
      {
        key: 'goldMine',
        img: 'resources/gold_mine.png',
      },
    ],
  },
  {
    headerKey: 'buildingGroup.religion',
    buildings: [
      {
        key: 'altar',
        img: 'religious/altar.png',
      },
      {
        key: 'shrine',
        img: 'religious/shrine.png',
      },
      {
        key: 'temple',
        img: 'religious/temple.png',
      },
      {
        key: 'monument',
        img: 'religious/monument.png',
      },
    ],
  },
  {
    headerKey: 'buildingGroup.military',
    buildings: [
      {
        key: 'barracks',
        img: 'military/barracks.png',
      },
      {
        key: 'archery',
        img: 'military/archery.png',
      },
      {
        key: 'stable',
        img: 'military/stable.png',
      },
      {
        key: 'workshop',
        img: 'military/workshop.png',
      },
      {
        key: 'wall',
        img: 'military/wall.png',
      },
      {
        key: 'tower',
        img: 'military/tower.png',
      },
    ],
  },
]

/**
 * Creates a fresh Colony instance for a new game session.
 * @returns {Colony} Fully initialized colony with default values
 */
export function createInitialColony() {
  return new Colony({
    season: 'warm',
    idleWorkers: 2,

    resources: new Resources({
      territory: 1,
      workers: 3,
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
      workers: 10,
      food: 100,
      wood: 100,
      stone: 50,
      copper: 100,
      iron: 100,
      gold: 100,
      faith: 100,
      knowledge: 100,
    }),

    buildings: new Buildings({
      headquarters: new Headquarters({
        type: HQ_TYPE_CAMP,
        level: 1,
      }),
      house: new House({
        level: 0,
      }),
      academy: new Academy({
        level: 0,
      }),
      storehouse: new Storehouse({
        level: 0,
      }),
      market: new Market({
        level: 0,
      }),
      altar: new Altar({
        level: 0,
      }),
      shrine: new Shrine({
        level: 0,
      }),
      temple: new Temple({
        level: 0,
      }),
      monument: new Monument({
        level: 0,
      }),
      farm: new Farm({
        level: 0,
      }),
      woodcutter: new Woodcutter({
        level: 0,
      }),
      quarry: new Quarry({
        level: 0,
      }),
      copperMine: new CopperMine({
        level: 0,
      }),
      ironMine: new IronMine({
        level: 0,
      }),
      goldMine: new GoldMine({
        level: 0,
      }),
      barracks: new Barracks({
        level: 0,
      }),
      archery: new Archery({
        level: 0,
      }),
      stable: new Stable({
        level: 0,
      }),
      workshop: new Workshop({
        level: 0,
      }),
      wall: new Wall({
        level: 0,
      }),
      tower: new Tower({
        level: 0,
      }),
    }),
  })
}
