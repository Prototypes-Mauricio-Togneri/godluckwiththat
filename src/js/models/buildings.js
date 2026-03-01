import {BUILDING_HEADQUARTERS} from '@/js/engine/enums.js'

/**
 * Container for all colony building instances.
 *
 * @property {Headquarters} headquarters - Main colony building
 * @property {House} house - Worker housing
 * @property {Academy} academy - Knowledge production
 * @property {Storehouse} storehouse - Storage capacity upgrades
 * @property {Market} market - Resource trading
 * @property {Altar} altar - Passive faith generation
 * @property {Temple} temple - Worker-based faith production
 * @property {Monument} monument - One-time faith grants per level
 * @property {Farm} farm - Food production
 * @property {Woodcutter} woodcutter - Wood production
 * @property {Quarry} quarry - Stone production
 * @property {CopperMine} copperMine - Copper production
 * @property {IronMine} ironMine - Iron production
 * @property {GoldMine} goldMine - Gold production
 * @property {Barracks} barracks - Infantry training
 * @property {Archery} archery - Archer unit training
 * @property {Stable} stable - Cavalry unit training
 * @property {Workshop} workshop - Siege unit training
 * @property {Wall} wall - Defensive fortification
 * @property {Tower} tower - Ranged attack structure
 */
class Buildings {
  /**
   * @param {Object} data - Pre-constructed building instances keyed by name
   */
  constructor(data) {
    this.headquarters = data.headquarters // Main colony building
    this.house = data.house // Worker housing
    this.academy = data.academy // Knowledge production
    this.storehouse = data.storehouse // Storage capacity upgrades
    this.market = data.market // Resource trading
    this.altar = data.altar // Passive faith generation
    this.temple = data.temple // Worker-based faith production
    this.monument = data.monument // One-time faith grants per level
    this.farm = data.farm // Food production
    this.woodcutter = data.woodcutter // Wood production
    this.quarry = data.quarry // Stone production
    this.copperMine = data.copperMine // Copper production
    this.ironMine = data.ironMine // Iron production
    this.goldMine = data.goldMine // Gold production
    this.barracks = data.barracks // Infantry training
    this.archery = data.archery // Archer unit training
    this.stable = data.stable // Cavalry unit training
    this.workshop = data.workshop // Siege unit training
    this.wall = data.wall // Defensive fortification
    this.tower = data.tower // Ranged attack structure
  }

  /**
   * Returns the sum of all building levels excluding headquarters.
   * @returns {number}
   */
  get totalLevels() {
    return Object.values(this).reduce((sum, building) => sum + building.level, 0) - this.headquarters.level
  }

  /**
   * Returns the total number of workers assigned across all producer buildings.
   * @returns {number}
   */
  get totalAssignedWorkers() {
    return this.farm.workers
      + this.woodcutter.workers
      + this.quarry.workers
      + this.copperMine.workers
      + this.ironMine.workers
      + this.goldMine.workers
      + this.temple.workers
      + this.academy.workers
  }

  /**
   * Returns the count of non-HQ buildings currently under construction.
   * Each counts as one reserved territory slot.
   * @returns {number}
   */
  get pendingTerritory() {
    return Object.entries(this).reduce((sum, [
      key,
      building,
    ]) => {
      if (key === BUILDING_HEADQUARTERS) {
        return sum
      }
      return sum + (building.isConstructing ? 1 : 0)
    }, 0)
  }
}

export default Buildings
