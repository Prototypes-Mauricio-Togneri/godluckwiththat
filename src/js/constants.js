import Academy from './models/buildings/academy.js'
import Altar from './models/buildings/altar.js'
import Archery from './models/buildings/archery.js'
import Barracks from './models/buildings/barracks.js'
import Buildings from './models/buildings/buildings.js'
import Cavalry from './models/buildings/cavalry.js'
import CopperMine from './models/buildings/copper_mine.js'
import Farm from './models/buildings/farm.js'
import GoldMine from './models/buildings/gold_mine.js'
import Headquarters from './models/buildings/headquarters.js'
import House from './models/buildings/house.js'
import IronMine from './models/buildings/iron_mine.js'
import Market from './models/buildings/market.js'
import Monument from './models/buildings/monument.js'
import Quarry from './models/buildings/quarry.js'
import Shrine from './models/buildings/shrine.js'
import Storehouse from './models/buildings/storehouse.js'
import Temple from './models/buildings/temple.js'
import Tower from './models/buildings/tower.js'
import Wall from './models/buildings/wall.js'
import Woodcutter from './models/buildings/woodcutter.js'
import Workshop from './models/buildings/workshop.js'
import Colony from './models/colony.js'
import Production from './models/production.js'
import Resources from './models/resources.js'
import Stockpile from './models/stockpile.js'

// Centralized magic constants

// Tooltips — header items
export const TOOLTIP_FOOD = 'Food'
export const TOOLTIP_WOOD = 'Wood'
export const TOOLTIP_STONE = 'Stone'
export const TOOLTIP_POPULATION = 'Population'
export const TOOLTIP_IDLE_WORKERS = 'Idle Workers'
export const TOOLTIP_TERRITORY = 'Territory'

// Initial colony state — factory that returns a fresh Colony for each new game session
export function createInitialColony() {
  return new Colony({
    season: 'warm',
    idleWorkers: 2,

    resources: new Resources({
      territory: 1,
      workers: 3,
      food: 10,
      wood: 5,
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
        type: 'camp',
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
      cavalry: new Cavalry({
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
