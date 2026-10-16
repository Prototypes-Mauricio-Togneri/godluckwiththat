import {RESOURCE_TIME_EXPONENT, RESOURCE_TIME_WEIGHTS} from '@/js/engine/balancing.js'
import {RESOURCE_COPPER, RESOURCE_FAITH, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/engine/enums.js'
import {floorWithTolerance} from '@/js/engine/utils.js'

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
    if (this._entries) {
      return this._entries
    }
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
    this._entries = map
    return map
  }

  /**
   * Returns a new Cost with each resource multiplied by the given factor and floored.
   * @param {number} factor - Multiplier to apply to every resource
   * @returns {Cost} New Cost with each resource multiplied and floored
   */
  multiplyFloor(factor) {
    return new Cost({
      food: floorWithTolerance(this.food * factor),
      wood: floorWithTolerance(this.wood * factor),
      stone: floorWithTolerance(this.stone * factor),
      copper: floorWithTolerance(this.copper * factor),
      iron: floorWithTolerance(this.iron * factor),
      gold: floorWithTolerance(this.gold * factor),
      knowledge: floorWithTolerance(this.knowledge * factor),
      faith: floorWithTolerance(this.faith * factor),
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
    return Math.floor(Math.pow(seconds, RESOURCE_TIME_EXPONENT))
  }
}

export default Cost
