import {describe, it, expect} from 'vitest'
import Consumption from '@/js/models/consumption.js'

describe('Consumption', () => {
  describe('constructor', () => {
    it('should set all fields to default values', () => {
      const consumption = new Consumption({})
      expect(consumption.food).toBe(0)
      expect(consumption.wood).toBe(0)
    })

    it('should accept override values', () => {
      const consumption = new Consumption({
        food: 2.5,
        wood: 1.8,
      })
      expect(consumption.food).toBe(2.5)
      expect(consumption.wood).toBe(1.8)
    })
  })
})
