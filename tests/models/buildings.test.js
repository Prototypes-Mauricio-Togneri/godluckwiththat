import {describe, it, expect} from 'vitest'
import {BUILDING_CLASS_MAP} from '@/js/engine/constants.js'
import Buildings from '@/js/models/buildings.js'
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

function createAllBuildings(overrides = {}) {
  return new Buildings({
    headquarters: new Headquarters({
      level: overrides.headquartersLevel ?? 1,
      type: 'camp',
    }),
    house: new House({
      level: overrides.houseLevel ?? 0,
    }),
    academy: new Academy({
      level: overrides.academyLevel ?? 0,
    }),
    storehouse: new Storehouse({
      level: overrides.storehouseLevel ?? 0,
    }),
    market: new Market({
      level: overrides.marketLevel ?? 0,
    }),
    altar: new Altar({
      level: overrides.altarLevel ?? 0,
    }),
    temple: new Temple({
      level: overrides.templeLevel ?? 0,
    }),
    monument: new Monument({
      level: overrides.monumentLevel ?? 0,
    }),
    farm: new Farm({
      level: overrides.farmLevel ?? 0,
    }),
    woodcutter: new Woodcutter({
      level: overrides.woodcutterLevel ?? 0,
    }),
    quarry: new Quarry({
      level: overrides.quarryLevel ?? 0,
    }),
    copperMine: new CopperMine({
      level: overrides.copperMineLevel ?? 0,
    }),
    ironMine: new IronMine({
      level: overrides.ironMineLevel ?? 0,
    }),
    goldMine: new GoldMine({
      level: overrides.goldMineLevel ?? 0,
    }),
    barracks: new Barracks({
      level: overrides.barracksLevel ?? 0,
    }),
    archery: new Archery({
      level: overrides.archeryLevel ?? 0,
    }),
    stable: new Stable({
      level: overrides.stableLevel ?? 0,
    }),
    workshop: new Workshop({
      level: overrides.workshopLevel ?? 0,
    }),
    wall: new Wall({
      level: overrides.wallLevel ?? 0,
    }),
    tower: new Tower({
      level: overrides.towerLevel ?? 0,
    }),
  })
}

describe('Buildings', () => {
  describe('totalLevels', () => {
    it('should return 0 when all non-HQ buildings are at level 0', () => {
      const buildings = createAllBuildings()
      expect(buildings.totalLevels).toBe(0)
    })

    it('should sum all non-HQ building levels', () => {
      const buildings = createAllBuildings({
        farmLevel: 3,
        houseLevel: 2,
        wallLevel: 1,
      })
      expect(buildings.totalLevels).toBe(6)
    })

    it('should exclude headquarters from total', () => {
      const buildings = createAllBuildings({
        headquartersLevel: 10,
      })
      expect(buildings.totalLevels).toBe(0)
    })
  })

  describe('totalAssignedWorkers', () => {
    it('should return 0 when no workers assigned', () => {
      const buildings = createAllBuildings()
      expect(buildings.totalAssignedWorkers).toBe(0)
    })

    it('should sum workers from all 8 producer buildings', () => {
      const buildings = createAllBuildings({
        farmLevel: 5,
      })
      buildings.farm.workers = 3
      buildings.woodcutter.workers = 2
      buildings.academy.workers = 1
      expect(buildings.totalAssignedWorkers).toBe(6)
    })
  })

  describe('pendingTerritory', () => {
    it('should return 0 when nothing is constructing', () => {
      const buildings = createAllBuildings()
      expect(buildings.pendingTerritory).toBe(0)
    })

    it('should count buildings under construction', () => {
      const buildings = createAllBuildings()
      buildings.farm.constructionRemaining = 10
      buildings.house.constructionRemaining = 5
      expect(buildings.pendingTerritory).toBe(2)
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip through serialization', () => {
      const original = createAllBuildings({
        farmLevel: 5,
        houseLevel: 3,
      })
      original.farm.workers = 4
      const json = original.toJSON()
      const restored = Buildings.fromJSON(json, BUILDING_CLASS_MAP)
      expect(restored.farm.level).toBe(5)
      expect(restored.farm.workers).toBe(4)
      expect(restored.house.level).toBe(3)
      expect(restored.headquarters.level).toBe(1)
    })
  })
})
