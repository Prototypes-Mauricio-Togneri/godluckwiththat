import {describe, it, expect} from 'vitest'
import {SEASON_DURATION} from '@/js/engine/balancing.js'
import {SEASON_WARM, SEASON_COLD} from '@/js/engine/enums.js'
import {createSeason} from '../helpers/factories.js'

describe('Season', () => {
  describe('constructor', () => {
    it('should set current season and elapsed time', () => {
      const season = createSeason({
        currentSeason: SEASON_COLD,
        seasonElapsed: 42,
      })
      expect(season.currentSeason).toBe(SEASON_COLD)
      expect(season.seasonElapsed).toBe(42)
    })
  })

  describe('isWarm', () => {
    it('should return true when season is warm', () => {
      const season = createSeason({
        currentSeason: SEASON_WARM,
      })
      expect(season.isWarm).toBe(true)
    })

    it('should return false when season is cold', () => {
      const season = createSeason({
        currentSeason: SEASON_COLD,
      })
      expect(season.isWarm).toBe(false)
    })
  })

  describe('isCold', () => {
    it('should return true when season is cold', () => {
      const season = createSeason({
        currentSeason: SEASON_COLD,
      })
      expect(season.isCold).toBe(true)
    })

    it('should return false when season is warm', () => {
      const season = createSeason({
        currentSeason: SEASON_WARM,
      })
      expect(season.isCold).toBe(false)
    })
  })

  describe('advance', () => {
    it('should increment elapsed time by delta', () => {
      const season = createSeason({
        seasonElapsed: 0,
      })
      season.advance(10)
      expect(season.seasonElapsed).toBe(10)
    })

    it('should return false when season does not change', () => {
      const season = createSeason({
        seasonElapsed: 0,
      })
      expect(season.advance(10)).toBe(false)
    })

    it('should flip from warm to cold at season duration', () => {
      const season = createSeason({
        currentSeason: SEASON_WARM,
        seasonElapsed: SEASON_DURATION - 1,
      })
      const changed = season.advance(1)
      expect(changed).toBe(true)
      expect(season.currentSeason).toBe(SEASON_COLD)
    })

    it('should flip from cold to warm at season duration', () => {
      const season = createSeason({
        currentSeason: SEASON_COLD,
        seasonElapsed: SEASON_DURATION - 1,
      })
      const changed = season.advance(1)
      expect(changed).toBe(true)
      expect(season.currentSeason).toBe(SEASON_WARM)
    })

    it('should carry over excess elapsed time after flip', () => {
      const season = createSeason({
        seasonElapsed: SEASON_DURATION - 5,
      })
      season.advance(10)
      expect(season.seasonElapsed).toBe(5)
    })
  })

  describe('toJSON', () => {
    it('should return a serializable snapshot', () => {
      const season = createSeason({
        currentSeason: SEASON_COLD,
        seasonElapsed: 150,
      })
      const json = season.toJSON()
      expect(json).toEqual({
        currentSeason: SEASON_COLD,
        seasonElapsed: 150,
      })
    })
  })
})
