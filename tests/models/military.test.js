import {describe, it, expect} from 'vitest'
import {RAID_PHASE_INCOMING, UNIT_ARCHER, UNIT_CAVALRY, UNIT_INFANTRY} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Military from '@/js/models/military.js'
import Raid from '@/js/models/raid.js'
import {createMilitary, createRaid} from '../helpers/factories.js'

describe('Military', () => {
  describe('constructor', () => {
    it('should default to an empty army, no raid and no raids so far', () => {
      const military = new Military()
      expect(military.units).toEqual({
        [UNIT_INFANTRY]: 0,
        [UNIT_ARCHER]: 0,
        [UNIT_CAVALRY]: 0,
      })
      expect(military.raid).toBeNull()
      expect(military.raidCount).toBe(0)
    })

    it('should fill missing unit types with 0', () => {
      const military = new Military({
        units: {
          [UNIT_ARCHER]: 4,
        },
      })
      expect(military.units).toEqual({
        [UNIT_INFANTRY]: 0,
        [UNIT_ARCHER]: 4,
        [UNIT_CAVALRY]: 0,
      })
    })

    it('should keep the given raid and raid count', () => {
      const raid = createRaid()
      const military = createMilitary({
        raid: raid,
        raidCount: 3,
      })
      expect(military.raid).toBe(raid)
      expect(military.raidCount).toBe(3)
    })
  })

  describe('totalUnits', () => {
    it('should sum units across all types', () => {
      const military = createMilitary({
        units: {
          [UNIT_INFANTRY]: 5,
          [UNIT_ARCHER]: 3,
          [UNIT_CAVALRY]: 2,
        },
      })
      expect(military.totalUnits).toBe(10)
    })

    it('should be 0 for an empty army', () => {
      expect(new Military().totalUnits).toBe(0)
    })
  })

  describe('fromJSON', () => {
    it('should give defaults for undefined data', () => {
      const military = Military.fromJSON(undefined)
      expect(military).toBeInstanceOf(Military)
      expect(military.totalUnits).toBe(0)
      expect(military.raid).toBeNull()
      expect(military.raidCount).toBe(0)
    })

    it('should rebuild the raid as a Raid instance', () => {
      const military = Military.fromJSON({
        units: {
          [UNIT_INFANTRY]: 2,
        },
        raid: createRaid().toJSON(),
        raidCount: 1,
      })
      expect(military.raid).toBeInstanceOf(Raid)
      expect(military.raid.phase).toBe(RAID_PHASE_INCOMING)
      expect(military.raid.demand).toBeInstanceOf(Cost)
    })
  })

  describe('toJSON', () => {
    it('should copy the units', () => {
      const military = createMilitary()
      const json = military.toJSON()
      expect(json.units).toEqual(military.units)
      expect(json.units).not.toBe(military.units)
    })

    it('should serialize a missing raid as null', () => {
      expect(new Military().toJSON().raid).toBeNull()
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip units, raid and raid count', () => {
      const original = createMilitary({
        units: {
          [UNIT_INFANTRY]: 5,
          [UNIT_ARCHER]: 3,
          [UNIT_CAVALRY]: 1,
        },
        raid: createRaid({
          remainingSeconds: 45,
          delaysPaid: 1,
        }),
        raidCount: 4,
      })
      const restored = Military.fromJSON(original.toJSON())
      expect(restored.toJSON()).toEqual(original.toJSON())
      expect(restored.raid.remainingSeconds).toBe(45)
      expect(restored.raid.delaysPaid).toBe(1)
      expect(restored.raidCount).toBe(4)
    })
  })
})
