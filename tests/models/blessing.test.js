import {describe, it, expect} from 'vitest'
import {BLESSING_FERTILE_SOIL, BLESSING_GIFT_FROM_THE_HEAVENS} from '@/js/engine/enums.js'
import Blessing from '@/js/models/blessing.js'
import {createBlessing} from '../helpers/factories.js'

describe('Blessing', () => {
  describe('constructor', () => {
    it('should set type and default optional fields to null', () => {
      const blessing = createBlessing()
      expect(blessing.type).toBe(BLESSING_FERTILE_SOIL)
      expect(blessing.timeout).toBeNull()
      expect(blessing.productivity).toBeNull()
      expect(blessing.resources).toBeNull()
      expect(blessing.territory).toBeNull()
      expect(blessing.construction).toBeNull()
      expect(blessing.warm).toBeNull()
      expect(blessing.cold).toBeNull()
    })

    it('should set provided values', () => {
      const blessing = createBlessing({
        type: BLESSING_GIFT_FROM_THE_HEAVENS,
        timeout: 120,
        productivity: 0.3,
        resources: {
          food: 500,
        },
      })
      expect(blessing.type).toBe(BLESSING_GIFT_FROM_THE_HEAVENS)
      expect(blessing.timeout).toBe(120)
      expect(blessing.productivity).toBe(0.3)
      expect(blessing.resources).toEqual({
        food: 500,
      })
    })
  })

  describe('fromJSON', () => {
    it('should reconstruct a Blessing from serialized data', () => {
      const data = {
        type: BLESSING_FERTILE_SOIL,
        timeout: 60,
        productivity: 0.2,
      }
      const blessing = Blessing.fromJSON(data)
      expect(blessing).toBeInstanceOf(Blessing)
      expect(blessing.type).toBe(BLESSING_FERTILE_SOIL)
      expect(blessing.timeout).toBe(60)
    })
  })

  describe('toJSON', () => {
    it('should produce a round-trippable snapshot', () => {
      const original = createBlessing({
        type: BLESSING_GIFT_FROM_THE_HEAVENS,
        timeout: 90,
        territory: 5,
      })
      const json = original.toJSON()
      const restored = Blessing.fromJSON(json)
      expect(restored.type).toBe(original.type)
      expect(restored.timeout).toBe(original.timeout)
      expect(restored.territory).toBe(original.territory)
    })
  })
})
