import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_CLASS_MAP, createInitialColony, createInitialMeta, createInitialChallenges} from '@/js/engine/constants.js'
import Colony from '@/js/models/colony.js'
import Meta from '@/js/models/meta.js'
import Challenges from '@/js/models/challenges.js'
import {VALID_BUILDING_KEYS} from '../helpers/building_keys.js'

describe('constants', () => {
  describe('BUILDING_CLASS_MAP', () => {
    it('every key is a valid BUILDING_* enum', () => {
      for (const key of Object.keys(BUILDING_CLASS_MAP)) {
        expect(VALID_BUILDING_KEYS.has(key), `unexpected key "${key}"`).toBe(true)
      }
    })

    it('every value is a constructor function', () => {
      for (const [
        key,
        BuildingClass,
      ] of Object.entries(BUILDING_CLASS_MAP)) {
        expect(typeof BuildingClass, `${key} value`).toBe('function')
        expect(BuildingClass.prototype, `${key} has no prototype`).toBeDefined()
      }
    })
  })

  describe('BUILDING_CLASS_MAP and BUILDING_UPGRADES consistency', () => {
    it('no orphaned keys between BUILDING_CLASS_MAP and BUILDING_UPGRADES', () => {
      const classMapKeys = new Set(Object.keys(BUILDING_CLASS_MAP))
      const upgradesKeys = new Set(Object.keys(BUILDING_UPGRADES))

      for (const key of classMapKeys) {
        expect(upgradesKeys.has(key), `"${key}" is in BUILDING_CLASS_MAP but not BUILDING_UPGRADES`).toBe(true)
      }
      for (const key of upgradesKeys) {
        expect(classMapKeys.has(key), `"${key}" is in BUILDING_UPGRADES but not BUILDING_CLASS_MAP`).toBe(true)
      }
    })
  })

  describe('factory functions', () => {
    it('createInitialColony returns a Colony instance', () => {
      const colony = createInitialColony()
      expect(colony).toBeInstanceOf(Colony)
    })

    it('createInitialMeta returns a Meta instance', () => {
      const meta = createInitialMeta()
      expect(meta).toBeInstanceOf(Meta)
    })

    it('createInitialChallenges returns a Challenges instance', () => {
      const challenges = createInitialChallenges()
      expect(challenges).toBeInstanceOf(Challenges)
    })
  })
})
