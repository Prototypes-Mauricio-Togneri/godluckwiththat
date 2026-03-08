// Shared utility functions for resource affordability checks.

/**
 * Whether the given resource snapshot can cover the cost.
 * Works on plain objects (no class dependency).
 * @param {Object} resources - Flat resource snapshot {food, wood, stone, ...}
 * @param {Cost} cost - Cost instance with resource fields
 * @returns {boolean} True if every cost field is <= the corresponding resource
 */
export function canAffordCost(resources, cost) {
  return cost.food <= resources.food
    && cost.wood <= resources.wood
    && cost.stone <= resources.stone
    && cost.copper <= resources.copper
    && cost.iron <= resources.iron
    && cost.gold <= resources.gold
    && cost.knowledge <= resources.knowledge
    && cost.faith <= resources.faith
}
