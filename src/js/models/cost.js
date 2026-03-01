import {RESOURCE_TIME_WEIGHTS} from '@/js/engine/balancing.js'
import {RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'

/**
 * Multi-resource cost holder.
 * Represents a cost (or price) expressed as a combination of resources.
 *
 * @property {number} food - Food portion of the cost
 * @property {number} wood - Wood portion of the cost
 * @property {number} stone - Stone portion of the cost
 * @property {number} copper - Copper portion of the cost
 * @property {number} iron - Iron portion of the cost
 * @property {number} gold - Gold portion of the cost
 * @property {number} knowledge - Knowledge portion of the cost
 * @property {number} faith - Faith portion of the cost
 */
class Cost {
  /**
   * @param {Object} data - Resource amounts (omitted keys default to 0)
   */
  constructor(data = {}) {
    this.food = data.food ?? 0 // Food cost (default 0)
    this.wood = data.wood ?? 0 // Wood cost (default 0)
    this.stone = data.stone ?? 0 // Stone cost (default 0)
    this.copper = data.copper ?? 0 // Copper cost (default 0)
    this.iron = data.iron ?? 0 // Iron cost (default 0)
    this.gold = data.gold ?? 0 // Gold cost (default 0)
    this.knowledge = data.knowledge ?? 0 // Knowledge cost (default 0)
    this.faith = data.faith ?? 0 // Faith cost (default 0)
  }

  /**
   * Returns non-zero resource entries as a Map of key → amount.
   * @returns {Map<string, number>} Non-zero resource entries as key-amount pairs
   */
  get entries() {
    const map = new Map()
    if (this.food > 0) {
      map.set(RESOURCE_FOOD, this.food)
    }
    if (this.wood > 0) {
      map.set(RESOURCE_WOOD, this.wood)
    }
    if (this.stone > 0) {
      map.set(RESOURCE_STONE, this.stone)
    }
    if (this.copper > 0) {
      map.set(RESOURCE_COPPER, this.copper)
    }
    if (this.iron > 0) {
      map.set(RESOURCE_IRON, this.iron)
    }
    if (this.gold > 0) {
      map.set(RESOURCE_GOLD, this.gold)
    }
    if (this.knowledge > 0) {
      map.set(RESOURCE_KNOWLEDGE, this.knowledge)
    }
    if (this.faith > 0) {
      map.set(RESOURCE_FAITH, this.faith)
    }
    return map
  }

  /**
   * Returns a new Cost with each resource multiplied by the given factor.
   * @param {number} factor - Multiplier to apply to every resource
   * @returns {Cost} New Cost with each resource multiplied
   */
  multiply(factor) {
    return new Cost({
      food: this.food * factor,
      wood: this.wood * factor,
      stone: this.stone * factor,
      copper: this.copper * factor,
      iron: this.iron * factor,
      gold: this.gold * factor,
      knowledge: this.knowledge * factor,
      faith: this.faith * factor,
    })
  }

  /**
   * Returns a new Cost with each resource floored to the nearest integer.
   * @returns {Cost} New Cost with each resource floored
   */
  get floor() {
    return new Cost({
      food: Math.floor(this.food),
      wood: Math.floor(this.wood),
      stone: Math.floor(this.stone),
      copper: Math.floor(this.copper),
      iron: Math.floor(this.iron),
      gold: Math.floor(this.gold),
      knowledge: Math.floor(this.knowledge),
      faith: Math.floor(this.faith),
    })
  }

  /**
   * Derives a build time in seconds from the weighted sum of resource costs.
   * Each resource unit contributes its weight from RESOURCE_TIME_WEIGHTS.
   * @returns {number} Total time in seconds
   */
  get toSeconds() {
    let seconds = 0
    for (const [
      resource,
      amount,
    ] of this.entries) {
      seconds += amount * (RESOURCE_TIME_WEIGHTS[resource] ?? 0)
    }
    return Math.floor(seconds)
  }
}

export default Cost
