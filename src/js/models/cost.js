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
    this.food = data.food ?? 0
    this.wood = data.wood ?? 0
    this.stone = data.stone ?? 0
    this.copper = data.copper ?? 0
    this.iron = data.iron ?? 0
    this.gold = data.gold ?? 0
    this.knowledge = data.knowledge ?? 0
  }

  /**
   * @param {Resources} resources - Colony resource amounts to check against
   * @returns {boolean} True if every cost field is <= the corresponding resource
   */
  canAfford(resources) {
    return this.food <= resources.food
      && this.wood <= resources.wood
      && this.stone <= resources.stone
      && this.copper <= resources.copper
      && this.iron <= resources.iron
      && this.gold <= resources.gold
      && this.knowledge <= resources.knowledge
  }

  /**
   * Subtracts this cost from the given resources in place.
   * @param {Resources} resources - Colony resource amounts to deduct from
   */
  deductFrom(resources) {
    resources.food -= this.food
    resources.wood -= this.wood
    resources.stone -= this.stone
    resources.copper -= this.copper
    resources.iron -= this.iron
    resources.gold -= this.gold
    resources.knowledge -= this.knowledge
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
