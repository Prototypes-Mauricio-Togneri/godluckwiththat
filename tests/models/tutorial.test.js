import {describe, it, expect} from 'vitest'
import Tutorial from '@/js/models/tutorial.js'
import {createTutorial} from '../helpers/factories.js'

describe('Tutorial', () => {
  describe('constructor', () => {
    it('should default to step 0 and not completed', () => {
      const tutorial = createTutorial()
      expect(tutorial.currentStep).toBe(0)
      expect(tutorial.completed).toBe(false)
      expect(tutorial.dismissedModals).toBeInstanceOf(Set)
      expect(tutorial.dismissedModals.size).toBe(0)
      expect(tutorial.activeModal).toBeNull()
    })

    it('should set provided values', () => {
      const tutorial = createTutorial({
        currentStep: 5,
        completed: true,
        dismissedModals: [
          'seasonChanged',
          'negativeProduction',
        ],
      })
      expect(tutorial.currentStep).toBe(5)
      expect(tutorial.completed).toBe(true)
      expect(tutorial.dismissedModals.size).toBe(2)
      expect(tutorial.dismissedModals.has('seasonChanged')).toBe(true)
    })

    it('should drop an unknown or malformed saved activeModal', () => {
      expect(createTutorial({
        activeModal: 'unknownModal',
      }).activeModal).toBeNull()
      expect(createTutorial({
        activeModal: {
          toString: 1,
        },
      }).activeModal).toBeNull()
    })
  })

  describe('isActive', () => {
    it('should return true when not completed', () => {
      const tutorial = createTutorial()
      expect(tutorial.isActive).toBe(true)
    })

    it('should return false when completed', () => {
      const tutorial = createTutorial({
        completed: true,
      })
      expect(tutorial.isActive).toBe(false)
    })
  })

  describe('toJSON', () => {
    it('should serialize dismissedModals as array', () => {
      const tutorial = createTutorial({
        currentStep: 3,
        dismissedModals: ['seasonChanged'],
      })
      const json = tutorial.toJSON()
      expect(json.currentStep).toBe(3)
      expect(json.completed).toBe(false)
      expect(Array.isArray(json.dismissedModals)).toBe(true)
      expect(json.dismissedModals).toContain('seasonChanged')
    })

    it('should include activeModal in serialization', () => {
      const tutorial = createTutorial()
      tutorial.activeModal = 'seasonChanged'
      const json = tutorial.toJSON()
      expect(json.activeModal).toBe('seasonChanged')
    })

    it('should produce a round-trippable snapshot', () => {
      const original = createTutorial({
        currentStep: 7,
        completed: true,
        dismissedModals: [
          'seasonChanged',
          'hqUpgrade',
        ],
      })
      original.activeModal = 'negativeProduction'
      const json = original.toJSON()
      const restored = new Tutorial(json)
      expect(restored.currentStep).toBe(7)
      expect(restored.completed).toBe(true)
      expect(restored.dismissedModals.size).toBe(2)
      expect(restored.activeModal).toBe('negativeProduction')
    })
  })
})
