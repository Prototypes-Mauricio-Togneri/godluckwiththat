import {describe, it, expect} from 'vitest'
import {BUILDING_FARM, BUILDING_QUARRY, UNIT_ARCHER, UNIT_CAVALRY, UNIT_INFANTRY} from '@/js/engine/enums.js'
import RaidReport from '@/js/models/raid_report.js'

function createReportData(overrides = {}) {
  return {
    victory: false,
    army: {
      [UNIT_INFANTRY]: 4,
      [UNIT_ARCHER]: 2,
    },
    enemy: {
      [UNIT_INFANTRY]: 6,
      [UNIT_CAVALRY]: 3,
    },
    unitsLost: {
      [UNIT_INFANTRY]: 4,
      [UNIT_ARCHER]: 2,
    },
    resourcesLost: {
      food: 60,
      wood: 30,
    },
    workersLost: 2,
    buildingsLost: [
      BUILDING_FARM,
      BUILDING_FARM,
      BUILDING_QUARRY,
    ],
    ...overrides,
  }
}

describe('RaidReport', () => {
  describe('constructor', () => {
    it('should default missing fields', () => {
      const report = new RaidReport({})
      expect(report.victory).toBe(false)
      expect(report.army).toEqual({
        [UNIT_INFANTRY]: 0,
        [UNIT_ARCHER]: 0,
        [UNIT_CAVALRY]: 0,
      })
      expect(report.enemy).toEqual(report.army)
      expect(report.unitsLost).toEqual(report.army)
      expect(report.resourcesLost).toEqual({})
      expect(report.workersLost).toBe(0)
      expect(report.buildingsLost).toEqual([])
    })

    it('should fill missing unit types with 0', () => {
      const report = new RaidReport(createReportData())
      expect(report.army).toEqual({
        [UNIT_INFANTRY]: 4,
        [UNIT_ARCHER]: 2,
        [UNIT_CAVALRY]: 0,
      })
      expect(report.enemy[UNIT_ARCHER]).toBe(0)
    })

    it('should copy the given maps and list', () => {
      const data = createReportData()
      const report = new RaidReport(data)
      expect(report.resourcesLost).not.toBe(data.resourcesLost)
      expect(report.buildingsLost).not.toBe(data.buildingsLost)
      data.buildingsLost.push(BUILDING_FARM)
      expect(report.buildingsLost).toHaveLength(3)
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip a lost raid', () => {
      const original = new RaidReport(createReportData())
      const restored = RaidReport.fromJSON(original.toJSON())
      expect(restored).toBeInstanceOf(RaidReport)
      expect(restored.toJSON()).toEqual(original.toJSON())
      expect(restored.buildingsLost).toEqual([
        BUILDING_FARM,
        BUILDING_FARM,
        BUILDING_QUARRY,
      ])
      expect(restored.resourcesLost).toEqual({
        food: 60,
        wood: 30,
      })
      expect(restored.workersLost).toBe(2)
    })

    it('should round-trip a repelled raid', () => {
      const original = new RaidReport(createReportData({
        victory: true,
        unitsLost: {
          [UNIT_INFANTRY]: 1,
        },
        resourcesLost: {},
        workersLost: 0,
        buildingsLost: [],
      }))
      const restored = RaidReport.fromJSON(original.toJSON())
      expect(restored.victory).toBe(true)
      expect(restored.unitsLost[UNIT_INFANTRY]).toBe(1)
      expect(restored.buildingsLost).toEqual([])
    })

    it('should not share references with the serialized snapshot', () => {
      const report = new RaidReport(createReportData())
      const json = report.toJSON()
      expect(json.army).not.toBe(report.army)
      expect(json.enemy).not.toBe(report.enemy)
      expect(json.unitsLost).not.toBe(report.unitsLost)
      expect(json.resourcesLost).not.toBe(report.resourcesLost)
      expect(json.buildingsLost).not.toBe(report.buildingsLost)
    })
  })
})
