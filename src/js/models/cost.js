import {RESOURCE_COPPER, RESOURCE_FOOD, RESOURCE_GOLD, RESOURCE_IRON, RESOURCE_KNOWLEDGE, RESOURCE_STONE, RESOURCE_WOOD} from '@/js/constants.js'

/**
 * Multi-resource cost holder.
 * Represents a cost (or price) expressed as a combination of resources.
 *
 * @property {number} food
 * @property {number} wood
 * @property {number} stone
 * @property {number} copper
 * @property {number} iron
 * @property {number} gold
 * @property {number} knowledge
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
  }

  /**
   * Returns non-zero resource entries as a Map of key → amount.
   * @returns {Map<string, number>}
   */
  entries() {
    const map = new Map()
    if (this.food > 0) map.set(RESOURCE_FOOD, this.food)
    if (this.wood > 0) map.set(RESOURCE_WOOD, this.wood)
    if (this.stone > 0) map.set(RESOURCE_STONE, this.stone)
    if (this.copper > 0) map.set(RESOURCE_COPPER, this.copper)
    if (this.iron > 0) map.set(RESOURCE_IRON, this.iron)
    if (this.gold > 0) map.set(RESOURCE_GOLD, this.gold)
    if (this.knowledge > 0) map.set(RESOURCE_KNOWLEDGE, this.knowledge)
    return map
  }
}

export default Cost
