import {describe, it, expect} from 'vitest'
import {canAffordCost} from '@/js/engine/utils.js'
import {createCost} from '../helpers/factories.js'

describe('canAffordCost', () => {
  const richResources = {
    food: 1000,
    wood: 1000,
    stone: 1000,
    copper: 1000,
    iron: 1000,
    gold: 1000,
    knowledge: 1000,
    faith: 1000,
  }

  const poorResources = {
    food: 0,
    wood: 0,
    stone: 0,
    copper: 0,
    iron: 0,
    gold: 0,
    knowledge: 0,
    faith: 0,
  }

  it('should return true when resources exceed cost', () => {
    const cost = createCost({
      food: 50,
      wood: 30,
    })
    expect(canAffordCost(richResources, cost)).toBe(true)
  })

  it('should return true when resources exactly match cost', () => {
    const resources = {
      food: 50,
      wood: 30,
      stone: 0,
      copper: 0,
      iron: 0,
      gold: 0,
      knowledge: 0,
      faith: 0,
    }
    const cost = createCost({
      food: 50,
      wood: 30,
    })
    expect(canAffordCost(resources, cost)).toBe(true)
  })

  it('should return false when any resource is insufficient', () => {
    const resources = {
      food: 49,
      wood: 1000,
      stone: 1000,
      copper: 1000,
      iron: 1000,
      gold: 1000,
      knowledge: 1000,
      faith: 1000,
    }
    const cost = createCost({
      food: 50,
    })
    expect(canAffordCost(resources, cost)).toBe(false)
  })

  it('should return false when resources are empty', () => {
    const cost = createCost({
      food: 1,
    })
    expect(canAffordCost(poorResources, cost)).toBe(false)
  })

  it('should return true for a zero cost', () => {
    const cost = createCost()
    expect(canAffordCost(poorResources, cost)).toBe(true)
  })

  it('should check all 8 resource types', () => {
    const resources = {
      food: 10,
      wood: 10,
      stone: 10,
      copper: 10,
      iron: 10,
      gold: 10,
      knowledge: 10,
      faith: 10,
    }
    const costAllResources = createCost({
      food: 10,
      wood: 10,
      stone: 10,
      copper: 10,
      iron: 10,
      gold: 10,
      knowledge: 10,
      faith: 10,
    })
    expect(canAffordCost(resources, costAllResources)).toBe(true)

    const costTooMuchFaith = createCost({
      faith: 11,
    })
    expect(canAffordCost(resources, costTooMuchFaith)).toBe(false)
  })
})
