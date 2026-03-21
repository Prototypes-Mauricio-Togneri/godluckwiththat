import {describe, it, expect} from 'vitest'
import {PUNISHMENT_CROP_FAILURE, PUNISHMENT_PLAGUE} from '@/js/engine/enums.js'
import Punishment from '@/js/models/punishment.js'
import {createPunishment} from '../helpers/factories.js'

describe('Punishment', () => {
  describe('constructor', () => {
    it('should set type and default optional fields to null', () => {
      const punishment = createPunishment()
      expect(punishment.type).toBe(PUNISHMENT_CROP_FAILURE)
      expect(punishment.timeout).toBeNull()
      expect(punishment.faith).toBeNull()
      expect(punishment.productivityFarm).toBeNull()
      expect(punishment.productivityWoodcutter).toBeNull()
      expect(punishment.productivityMines).toBeNull()
      expect(punishment.productivityGeneral).toBeNull()
      expect(punishment.resources).toBeNull()
      expect(punishment.workers).toBeNull()
      expect(punishment.levels).toBeNull()
    })

    it('should set provided values', () => {
      const punishment = createPunishment({
        type: PUNISHMENT_PLAGUE,
        timeout: 180,
        workers: 5,
        productivityGeneral: 0.3,
      })
      expect(punishment.type).toBe(PUNISHMENT_PLAGUE)
      expect(punishment.timeout).toBe(180)
      expect(punishment.workers).toBe(5)
      expect(punishment.productivityGeneral).toBe(0.3)
    })
  })

  describe('fromJSON', () => {
    it('should reconstruct a Punishment from serialized data', () => {
      const data = {
        type: PUNISHMENT_PLAGUE,
        timeout: 60,
        faith: 0.5,
      }
      const punishment = Punishment.fromJSON(data)
      expect(punishment).toBeInstanceOf(Punishment)
      expect(punishment.type).toBe(PUNISHMENT_PLAGUE)
      expect(punishment.faith).toBe(0.5)
    })
  })

  describe('toJSON', () => {
    it('should produce a round-trippable snapshot', () => {
      const original = createPunishment({
        type: PUNISHMENT_PLAGUE,
        timeout: 120,
        workers: 3,
        resources: 0.2,
      })
      const json = original.toJSON()
      const restored = Punishment.fromJSON(json)
      expect(restored.type).toBe(original.type)
      expect(restored.timeout).toBe(original.timeout)
      expect(restored.workers).toBe(original.workers)
      expect(restored.resources).toBe(original.resources)
    })
  })
})
