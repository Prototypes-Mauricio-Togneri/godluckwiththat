import {describe, it, expect} from 'vitest'
import {WORKERS_PER_LEVEL} from '@/js/engine/balancing.js'
import {createProducer} from '../../helpers/factories.js'

describe('Producer', () => {
  describe('constructor', () => {
    it('should set workers and inherit Building fields', () => {
      const producer = createProducer({
        level: 3,
        workers: 7,
      })
      expect(producer.level).toBe(3)
      expect(producer.workers).toBe(7)
      expect(producer.constructionRemaining).toBe(0)
    })

    it('should default workers to 0', () => {
      const producer = createProducer({
        level: 1,
      })
      expect(producer.workers).toBe(0)
    })
  })

  describe('maxWorkers', () => {
    it('should return level times workers per level', () => {
      const producer = createProducer({
        level: 3,
      })
      expect(producer.maxWorkers).toBe(3 * WORKERS_PER_LEVEL)
    })

    it('should return 0 for unbuilt building', () => {
      const producer = createProducer({
        level: 0,
      })
      expect(producer.maxWorkers).toBe(0)
    })
  })

  describe('isEmpty', () => {
    it('should return true when no workers assigned', () => {
      const producer = createProducer({
        level: 2,
        workers: 0,
      })
      expect(producer.isEmpty).toBe(true)
    })

    it('should return false when workers assigned', () => {
      const producer = createProducer({
        level: 2,
        workers: 1,
      })
      expect(producer.isEmpty).toBe(false)
    })
  })

  describe('isFull', () => {
    it('should return true when at max workers', () => {
      const producer = createProducer({
        level: 1,
        workers: WORKERS_PER_LEVEL,
      })
      expect(producer.isFull).toBe(true)
    })

    it('should return false when below max workers', () => {
      const producer = createProducer({
        level: 1,
        workers: WORKERS_PER_LEVEL - 1,
      })
      expect(producer.isFull).toBe(false)
    })
  })

  describe('toJSON', () => {
    it('should include workers in serialized output', () => {
      const producer = createProducer({
        level: 2,
        workers: 5,
      })
      const json = producer.toJSON()
      expect(json.workers).toBe(5)
      expect(json.level).toBe(2)
      expect(json.constructionRemaining).toBe(0)
    })
  })
})
