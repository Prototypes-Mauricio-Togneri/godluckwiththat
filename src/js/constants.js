import Buildings from './models/buildings.js'
import Colony from './models/colony.js'
import Production from './models/production.js'
import Resources from './models/resources.js'
import Storage from './models/storage.js'

// Centralized magic constants

// Tooltips — header items
export const TOOLTIP_FOOD = 'Food'
export const TOOLTIP_WOOD = 'Wood'
export const TOOLTIP_STONE = 'Stone'
export const TOOLTIP_POPULATION = 'Population'
export const TOOLTIP_IDLE_WORKERS = 'Idle Workers'
export const TOOLTIP_TERRITORY = 'Territory'

// Initial colony state — full data structure for a new game session
export const INITIAL_COLONY = new Colony({
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

  storage: new Storage({
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
    headquarters: {
      type: 'camp',
      level: 1,
    },
    house: {
      level: 0,
    },
    academy: {
      level: 0,
    },
    storehouse: {
      level: 0,
    },
    market: {
      level: 0,
    },
    altar: {
      level: 0,
    },
    shrine: {
      level: 0,
    },
    temple: {
      level: 0,
    },
    monument: {
      level: 0,
    },
    farm: {
      level: 0,
    },
    woodcutter: {
      level: 0,
    },
    quarry: {
      level: 0,
    },
    copperMine: {
      level: 0,
    },
    ironMine: {
      level: 0,
    },
    goldMine: {
      level: 0,
    },
    barracks: {
      level: 0,
    },
    archery: {
      level: 0,
    },
    cavalry: {
      level: 0,
    },
    workshop: {
      level: 0,
    },
    wall: {
      level: 0,
    },
    tower: {
      level: 0,
    },
  }),
})
