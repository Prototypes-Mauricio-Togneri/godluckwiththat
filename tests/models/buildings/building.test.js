import {describe, it, expect} from 'vitest'
import Cost from '@/js/models/cost.js'
import {createBuilding, createCost} from '../../helpers/factories.js'

describe('Building', () => {
  describe('constructor', () => {
    it('should set level and default construction fields to 0', () => {
      const building = createBuilding({
        level: 3,
      })
      expect(building.level).toBe(3)
      expect(building.constructionRemaining).toBe(0)
      expect(building.constructionDuration).toBe(0)
    })
  })

  describe('isUnbuilt', () => {
    it('should return true when level is 0', () => {
      const building = createBuilding({
        level: 0,
      })
      expect(building.isUnbuilt).toBe(true)
    })

    it('should return false when level is above 0', () => {
      const building = createBuilding({
        level: 1,
      })
      expect(building.isUnbuilt).toBe(false)
    })
  })

  describe('isConstructing', () => {
    it('should return false when constructionRemaining is 0', () => {
      const building = createBuilding()
      expect(building.isConstructing).toBe(false)
    })

    it('should return true when constructionRemaining is above 0', () => {
      const building = createBuilding({
        level: 1,
        constructionRemaining: 10,
      })
      expect(building.isConstructing).toBe(true)
    })
  })

  describe('levelUp', () => {
    it('should set construction duration and remaining from cost.toSeconds', () => {
      const building = createBuilding({
        level: 1,
      })
      const cost = createCost({
        food: 100,
        wood: 50,
      })
      const duration = building.levelUp(cost)
      expect(duration).toBe(cost.toSeconds)
      expect(building.constructionRemaining).toBe(duration)
      expect(building.constructionDuration).toBe(duration)
    })

    it('should apply duration multiplier', () => {
      const building = createBuilding({
        level: 1,
      })
      const cost = createCost({
        food: 100,
        wood: 50,
      })
      const baseDuration = cost.toSeconds
      const duration = building.levelUp(cost, 0.5)
      expect(duration).toBe(Math.max(1, Math.floor(baseDuration * 0.5)))
    })

    it('should enforce a minimum duration of 1', () => {
      const building = createBuilding({
        level: 1,
      })
      const cost = new Cost()
      const duration = building.levelUp(cost)
      expect(duration).toBe(1)
    })
  })

  describe('advance', () => {
    it('should return false when not constructing', () => {
      const building = createBuilding()
      expect(building.advance(1)).toBe(false)
    })

    it('should decrement constructionRemaining by delta', () => {
      const building = createBuilding({
        level: 0,
        constructionRemaining: 10,
        constructionDuration: 10,
      })
      building.advance(3)
      expect(building.constructionRemaining).toBe(7)
    })

    it('should complete construction when remaining reaches 0', () => {
      const building = createBuilding({
        level: 0,
        constructionRemaining: 5,
        constructionDuration: 5,
      })
      const completed = building.advance(5)
      expect(completed).toBe(true)
      expect(building.level).toBe(1)
      expect(building.constructionRemaining).toBe(0)
      expect(building.constructionDuration).toBe(0)
    })

    it('should not go below 0 remaining', () => {
      const building = createBuilding({
        level: 0,
        constructionRemaining: 3,
        constructionDuration: 3,
      })
      building.advance(10)
      expect(building.constructionRemaining).toBe(0)
      expect(building.level).toBe(1)
    })

    it('should return false when construction is not yet complete', () => {
      const building = createBuilding({
        level: 0,
        constructionRemaining: 10,
        constructionDuration: 10,
      })
      expect(building.advance(5)).toBe(false)
      expect(building.level).toBe(0)
    })
  })

  describe('toJSON', () => {
    it('should return a serializable snapshot', () => {
      const building = createBuilding({
        level: 5,
        constructionRemaining: 3,
        constructionDuration: 10,
      })
      const json = building.toJSON()
      expect(json).toEqual({
        level: 5,
        constructionRemaining: 3,
        constructionDuration: 10,
      })
    })
  })
})
