import {describe, it, expect} from 'vitest'
import {BUILDING_CLASS_MAP} from '@/js/engine/constants.js'
import {SEASON_WARM} from '@/js/engine/enums.js'
import Colony from '@/js/models/colony.js'
import Buildings from '@/js/models/buildings.js'
import Events from '@/js/models/events/events.js'
import Resources from '@/js/models/resources.js'
import Season from '@/js/models/season.js'
import Academy from '@/js/models/buildings/academy.js'
import Altar from '@/js/models/buildings/altar.js'
import Archery from '@/js/models/buildings/archery.js'
import Barracks from '@/js/models/buildings/barracks.js'
import CopperMine from '@/js/models/buildings/copper_mine.js'
import Farm from '@/js/models/buildings/farm.js'
import GoldMine from '@/js/models/buildings/gold_mine.js'
import Headquarters from '@/js/models/buildings/headquarters.js'
import House from '@/js/models/buildings/house.js'
import IronMine from '@/js/models/buildings/iron_mine.js'
import Market from '@/js/models/buildings/market.js'
import Monument from '@/js/models/buildings/monument.js'
import Quarry from '@/js/models/buildings/quarry.js'
import Stable from '@/js/models/buildings/stable.js'
import Storehouse from '@/js/models/buildings/storehouse.js'
import Temple from '@/js/models/buildings/temple.js'
import Tower from '@/js/models/buildings/tower.js'
import Wall from '@/js/models/buildings/wall.js'
import Woodcutter from '@/js/models/buildings/woodcutter.js'
import Workshop from '@/js/models/buildings/workshop.js'

function createColony(overrides = {}) {
  return new Colony({
    year: 1,
    season: new Season({
      currentSeason: SEASON_WARM,
      seasonElapsed: 0,
    }),
    resources: new Resources({
      workers: overrides.workers ?? 10,
    }),
    buildings: new Buildings({
      headquarters: new Headquarters({
        level: 1,
        type: 'camp',
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
      temple: new Temple({
        level: 0,
      }),
      monument: new Monument({
        level: 0,
      }),
      farm: new Farm({
        level: 1,
        workers: overrides.farmWorkers ?? 3,
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
    events: new Events(),
    ...overrides,
  })
}

describe('Colony', () => {
  describe('constructor', () => {
    it('should set all sub-models', () => {
      const colony = createColony()
      expect(colony.year).toBe(1)
      expect(colony.season).toBeInstanceOf(Season)
      expect(colony.resources).toBeInstanceOf(Resources)
      expect(colony.buildings).toBeInstanceOf(Buildings)
      expect(colony.events).toBeInstanceOf(Events)
    })
  })

  describe('idleWorkers', () => {
    it('should return workers minus assigned workers', () => {
      const colony = createColony({
        workers: 10,
        farmWorkers: 3,
      })
      expect(colony.idleWorkers).toBe(7)
    })

    it('should return 0 when all workers assigned', () => {
      const colony = createColony({
        workers: 3,
        farmWorkers: 3,
      })
      expect(colony.idleWorkers).toBe(0)
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip through serialization', () => {
      const original = createColony({
        workers: 15,
        farmWorkers: 5,
      })
      original.resources.food = 999
      const json = original.toJSON()
      const restored = Colony.fromJSON(json, BUILDING_CLASS_MAP)
      expect(restored.year).toBe(1)
      expect(restored.resources.food).toBe(999)
      expect(restored.resources.workers).toBe(15)
      expect(restored.buildings.farm.workers).toBe(5)
    })
  })
})
