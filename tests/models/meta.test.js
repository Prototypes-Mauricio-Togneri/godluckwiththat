import {describe, it, expect} from 'vitest'
import Meta from '@/js/models/meta.js'
import {createChallenges, createTutorial} from '../helpers/factories.js'

describe('Meta', () => {
  function createMeta(overrides = {}) {
    return new Meta({
      version: 1,
      createdDateTime: '2024-01-01T00:00:00.000Z',
      updatedDateTime: '2024-01-02T00:00:00.000Z',
      challenges: createChallenges(),
      tutorial: createTutorial(),
      ...overrides,
    })
  }

  describe('constructor', () => {
    it('should set all fields', () => {
      const meta = createMeta()
      expect(meta.version).toBe(1)
      expect(meta.createdDateTime).toBe('2024-01-01T00:00:00.000Z')
      expect(meta.challenges).toBeDefined()
      expect(meta.tutorial).toBeDefined()
    })

    it('should default gameSpeed', () => {
      const meta = createMeta()
      expect(meta.gameSpeed).toBe(1)
    })

    it('should accept custom gameSpeed', () => {
      const meta = createMeta({
        gameSpeed: 3,
      })
      expect(meta.gameSpeed).toBe(3)
    })
  })

  describe('fromJSON / toJSON', () => {
    it('should round-trip through serialization', () => {
      const original = createMeta({
        gameSpeed: 2,
      })
      const json = original.toJSON()
      const restored = Meta.fromJSON(json)
      expect(restored.version).toBe(1)
      expect(restored.gameSpeed).toBe(2)
      expect(restored.challenges).toBeDefined()
      expect(restored.tutorial).toBeDefined()
    })

    it('should update updatedDateTime on toJSON', () => {
      const meta = createMeta()
      const json = meta.toJSON()
      expect(json.updatedDateTime).not.toBe('2024-01-02T00:00:00.000Z')
    })
  })
})
