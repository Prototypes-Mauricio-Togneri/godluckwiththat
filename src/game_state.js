/**
 * Central game state container.
 * Holds all colony data: resources, production rates,
 * storage limits, and building levels.
 */
class GameState {
  constructor() {
    this.colony = {
      season: 'warm',
      idleWorkers: 2,

      resources: {
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
      },

      production: {
        food: 0,
        wood: 0,
        stone: 0,
        copper: 0,
        iron: 0,
        gold: 0,
        faith: 0,
        knowledge: 0,
      },

      storage: {
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
      },

      buildings: {
        headquarters: { type: 'camp', level: 1 },
        house: { level: 0 },
        academy: { level: 0 },
        storehouse: { level: 0 },
        market: { level: 0 },
        altar: { level: 0 },
        shrine: { level: 0 },
        temple: { level: 0 },
        monument: { level: 0 },
        farm: { level: 0 },
        woodcutter: { level: 0 },
        quarry: { level: 0 },
        copperMine: { level: 0 },
        ironMine: { level: 0 },
        goldMine: { level: 0 },
        barracks: { level: 0 },
        archery: { level: 0 },
        cavalry: { level: 0 },
        workshop: { level: 0 },
        wall: { level: 0 },
        tower: { level: 0 },
      },
    }
  }
}

export default GameState
