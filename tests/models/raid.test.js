import {describe, it, expect} from 'vitest'
import {TRIBUTE_CANCEL_MULTIPLIER, TRIBUTE_DELAY_GROWTH} from '@/js/engine/balancing.js'
import {RAID_PHASE_INCOMING, RAID_PHASE_WAITING, UNIT_ARCHER, UNIT_CAVALRY, UNIT_INFANTRY} from '@/js/engine/enums.js'
import Cost from '@/js/models/cost.js'
import Raid from '@/js/models/raid.js'
import {createRaid} from '../helpers/factories.js'

describe('Raid', () => {
  describe('constructor', () => {
    it('should default to a waiting raid with no enemy and no demand', () => {
      const raid = new Raid()
      expect(raid.phase).toBe(RAID_PHASE_WAITING)
      expect(raid.remainingSeconds).toBe(0)
      expect(raid.enemy).toEqual({
        [UNIT_INFANTRY]: 0,
        [UNIT_ARCHER]: 0,
        [UNIT_CAVALRY]: 0,
      })
      expect(raid.demand).toBeNull()
      expect(raid.delaysPaid).toBe(0)
    })

    it('should restore all fields', () => {
      const raid = createRaid({
        remainingSeconds: 42,
        enemy: {
          [UNIT_INFANTRY]: 3,
          [UNIT_CAVALRY]: 2,
        },
        delaysPaid: 2,
      })
      expect(raid.phase).toBe(RAID_PHASE_INCOMING)
      expect(raid.remainingSeconds).toBe(42)
      expect(raid.enemy).toEqual({
        [UNIT_INFANTRY]: 3,
        [UNIT_ARCHER]: 0,
        [UNIT_CAVALRY]: 2,
      })
      expect(raid.delaysPaid).toBe(2)
    })

    it('should fall back to waiting for an unknown phase', () => {
      expect(new Raid({
        phase: 'unknown',
      }).phase).toBe(RAID_PHASE_WAITING)
      expect(new Raid({
        phase: '',
      }).phase).toBe(RAID_PHASE_WAITING)
    })

    it('should build the demand as a Cost', () => {
      const raid = createRaid()
      expect(raid.demand).toBeInstanceOf(Cost)
      expect(raid.demand.food).toBe(100)
      expect(raid.demand.wood).toBe(50)
    })
  })

  describe('enemyCount', () => {
    it('should sum raiders across all unit types', () => {
      const raid = createRaid({
        enemy: {
          [UNIT_INFANTRY]: 3,
          [UNIT_ARCHER]: 4,
          [UNIT_CAVALRY]: 2,
        },
      })
      expect(raid.enemyCount).toBe(9)
    })

    it('should be 0 while waiting', () => {
      expect(new Raid().enemyCount).toBe(0)
    })
  })

  describe('delayCost', () => {
    it('should be null before the announcement', () => {
      expect(new Raid().delayCost).toBeNull()
    })

    it('should equal the base demand for the first delay', () => {
      const cost = createRaid().delayCost
      expect(cost).toBeInstanceOf(Cost)
      expect(cost.food).toBe(100)
      expect(cost.wood).toBe(50)
    })

    it('should grow by TRIBUTE_DELAY_GROWTH per delay paid, floored', () => {
      for (const delaysPaid of [
        1,
        2,
        3,
      ]) {
        const cost = createRaid({
          delaysPaid: delaysPaid,
        }).delayCost
        const factor = Math.pow(TRIBUTE_DELAY_GROWTH, delaysPaid)
        expect(cost.food, `delay ${delaysPaid}`).toBe(Math.floor(100 * factor))
        expect(cost.wood, `delay ${delaysPaid}`).toBe(Math.floor(50 * factor))
      }
    })

    it('should rise with each delay (100 → 150 → 225 food)', () => {
      expect(createRaid({
        delaysPaid: 1,
      }).delayCost.food).toBe(150)
      expect(createRaid({
        delaysPaid: 2,
      }).delayCost.food).toBe(225)
    })
  })

  describe('cancelCost', () => {
    it('should be null before the announcement', () => {
      expect(new Raid().cancelCost).toBeNull()
    })

    it('should be the base demand times TRIBUTE_CANCEL_MULTIPLIER', () => {
      const cost = createRaid().cancelCost
      expect(cost).toBeInstanceOf(Cost)
      expect(cost.food).toBe(100 * TRIBUTE_CANCEL_MULTIPLIER)
      expect(cost.wood).toBe(50 * TRIBUTE_CANCEL_MULTIPLIER)
    })

    it('should not depend on delays paid', () => {
      expect(createRaid({
        delaysPaid: 2,
      }).cancelCost.food).toBe(createRaid().cancelCost.food)
    })
  })

  describe('canDelay', () => {
    it('should allow the first three delays', () => {
      for (const delaysPaid of [
        0,
        1,
        2,
      ]) {
        expect(createRaid({
          delaysPaid: delaysPaid,
        }).canDelay, `after ${delaysPaid} delays`).toBe(true)
      }
    })

    it('should be false after 3 delays', () => {
      expect(createRaid({
        delaysPaid: 3,
      }).canDelay).toBe(false)
    })

    it('should never offer a delay that costs more than cancelling', () => {
      for (let delaysPaid = 0; delaysPaid < 10; delaysPaid++) {
        const raid = createRaid({
          delaysPaid: delaysPaid,
        })
        if (raid.canDelay) {
          expect(raid.delayCost.food, `after ${delaysPaid} delays`).toBeLessThanOrEqual(raid.cancelCost.food)
        }
      }
    })
  })

  describe('advance', () => {
    it('should count the timer down and return false while time remains', () => {
      const raid = createRaid({
        remainingSeconds: 10,
      })
      expect(raid.advance(4)).toBe(false)
      expect(raid.remainingSeconds).toBe(6)
    })

    it('should return true when the timer reaches exactly 0', () => {
      const raid = createRaid({
        remainingSeconds: 10,
      })
      expect(raid.advance(10)).toBe(true)
      expect(raid.remainingSeconds).toBe(0)
    })

    it('should clamp at 0 when overshooting', () => {
      const raid = createRaid({
        remainingSeconds: 10,
      })
      expect(raid.advance(25)).toBe(true)
      expect(raid.remainingSeconds).toBe(0)
    })

    it('should not change the timer for a zero delta', () => {
      const raid = createRaid({
        remainingSeconds: 10,
      })
      expect(raid.advance(0)).toBe(false)
      expect(raid.remainingSeconds).toBe(10)
    })
  })

  describe('toJSON', () => {
    it('should serialize the demand as a plain object of non-zero resources', () => {
      const json = createRaid().toJSON()
      expect(json.demand).toEqual({
        food: 100,
        wood: 50,
      })
      expect(json.demand).not.toBeInstanceOf(Cost)
    })

    it('should serialize a missing demand as null', () => {
      expect(new Raid().toJSON().demand).toBeNull()
    })

    it('should copy the enemy counts', () => {
      const raid = createRaid()
      const json = raid.toJSON()
      expect(json.enemy).toEqual(raid.enemy)
      expect(json.enemy).not.toBe(raid.enemy)
    })

    it('should include every field', () => {
      const json = createRaid({
        remainingSeconds: 30,
        delaysPaid: 1,
      }).toJSON()
      expect(json).toEqual({
        phase: RAID_PHASE_INCOMING,
        remainingSeconds: 30,
        enemy: {
          [UNIT_INFANTRY]: 5,
          [UNIT_ARCHER]: 0,
          [UNIT_CAVALRY]: 0,
        },
        demand: {
          food: 100,
          wood: 50,
        },
        delaysPaid: 1,
      })
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip an incoming raid', () => {
      const original = createRaid({
        remainingSeconds: 77,
        enemy: {
          [UNIT_INFANTRY]: 2,
          [UNIT_ARCHER]: 3,
          [UNIT_CAVALRY]: 1,
        },
        demand: {
          stone: 35,
          gold: 10,
        },
        delaysPaid: 2,
      })
      const restored = Raid.fromJSON(original.toJSON())
      expect(restored).toBeInstanceOf(Raid)
      expect(restored.toJSON()).toEqual(original.toJSON())
      expect(restored.demand).toBeInstanceOf(Cost)
      expect(restored.delayCost.stone).toBe(original.delayCost.stone)
    })

    it('should round-trip a waiting raid', () => {
      const original = new Raid({
        phase: RAID_PHASE_WAITING,
        remainingSeconds: 300,
      })
      const restored = Raid.fromJSON(original.toJSON())
      expect(restored.phase).toBe(RAID_PHASE_WAITING)
      expect(restored.remainingSeconds).toBe(300)
      expect(restored.demand).toBeNull()
    })
  })
})
