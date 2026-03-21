import {describe, it, expect} from 'vitest'
import {BUILDING_UPGRADES} from '@/js/engine/balancing.js'
import {BUILDING_CLASS_MAP, TUTORIAL_STEPS, createInitialColony, createInitialColonyBasic, createInitialColonyAdvanced, createInitialMeta, createInitialChallenges} from '@/js/engine/constants.js'
import {BUILDING_HEADQUARTERS, HQ_TYPE_CAMP, HQ_TYPE_CITY, HQ_TYPE_SETTLEMENT} from '@/js/engine/enums.js'
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

    it('createInitialChallenges defaults missing punishment fields to null', () => {
      const challenges = createInitialChallenges()
      const optionalFields = [
        'timeout',
        'faith',
        'productivityFarm',
        'productivityWoodcutter',
        'productivityMines',
        'productivityGeneral',
        'resources',
        'workers',
        'levels',
      ]
      for (const challenge of challenges.pending) {
        for (const field of optionalFields) {
          expect(challenge.punishment[field],
            `challenge ${challenge.index} punishment.${field} should not be undefined`,
          ).not.toBeUndefined()
        }
      }
    })

    it('createInitialChallenges resolves absent punishment fields to null', () => {
      const challenges = createInitialChallenges()
      // Challenge 3 (plague) omits timeout, productivityFarm, productivityWoodcutter,
      // productivityMines, productivityGeneral, and levels in the JSON template
      const plague = challenges.pending.find(challenge => challenge.index === 3)
      expect(plague.punishment.timeout).toBeNull()
      expect(plague.punishment.productivityFarm).toBeNull()
      expect(plague.punishment.productivityWoodcutter).toBeNull()
      expect(plague.punishment.productivityMines).toBeNull()
      expect(plague.punishment.productivityGeneral).toBeNull()
      expect(plague.punishment.levels).toBeNull()
    })

    describe('createInitialColonyBasic', () => {
      it('should return a Colony instance', () => {
        const colony = createInitialColonyBasic()
        expect(colony).toBeInstanceOf(Colony)
      })

      it('should have HQ at level 1 with type camp', () => {
        const colony = createInitialColonyBasic()
        const headquarters = colony.buildings[BUILDING_HEADQUARTERS]
        expect(headquarters.level).toBe(1)
        expect(headquarters.type).toBe(HQ_TYPE_CAMP)
      })

      it('should have starting food of 250 and wood of 100', () => {
        const colony = createInitialColonyBasic()
        expect(colony.resources.food).toBe(250)
        expect(colony.resources.wood).toBe(100)
      })
    })

    describe('createInitialColonyAdvanced', () => {
      it('should return a Colony instance', () => {
        const colony = createInitialColonyAdvanced()
        expect(colony).toBeInstanceOf(Colony)
      })

      it('should have HQ at level 5 with type city', () => {
        const colony = createInitialColonyAdvanced()
        const headquarters = colony.buildings[BUILDING_HEADQUARTERS]
        expect(headquarters.level).toBe(5)
        expect(headquarters.type).toBe(HQ_TYPE_CITY)
      })

      it('should have 60 workers and 1000 of each basic resource', () => {
        const colony = createInitialColonyAdvanced()
        expect(colony.resources.workers).toBe(60)
        expect(colony.resources.food).toBe(1000)
        expect(colony.resources.wood).toBe(1000)
        expect(colony.resources.stone).toBe(1000)
        expect(colony.resources.copper).toBe(1000)
        expect(colony.resources.iron).toBe(1000)
        expect(colony.resources.gold).toBe(1000)
      })
    })
  })

  describe('TUTORIAL_STEPS', () => {
    it('upgradeCamp check returns true when HQ type is not camp', () => {
      const upgradeCampStep = TUTORIAL_STEPS.find(step => step.building === BUILDING_HEADQUARTERS && step.textKey === 'tutorial.step.upgradeCamp')
      const buildings = {
        headquarters: {
          type: HQ_TYPE_SETTLEMENT,
        },
      }
      expect(upgradeCampStep.check(buildings)).toBe(true)
    })

    it('upgradeCamp check returns false when HQ type is camp', () => {
      const upgradeCampStep = TUTORIAL_STEPS.find(step => step.building === BUILDING_HEADQUARTERS && step.textKey === 'tutorial.step.upgradeCamp')
      const buildings = {
        headquarters: {
          type: HQ_TYPE_CAMP,
        },
      }
      expect(upgradeCampStep.check(buildings)).toBe(false)
    })
  })
})
