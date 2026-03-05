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
   * Uses explicit property access instead of Object.entries() to avoid
   * proxy key enumeration and temporary array allocation on every 1s tick.
   * MAINTAIN: update this list when adding or removing non-HQ buildings.
   * @returns {number} Sum of all building levels excluding headquarters
   */
  get totalLevels() {
    return this.house.level + this.academy.level + this.storehouse.level
      + this.market.level + this.altar.level + this.temple.level
      + this.monument.level + this.farm.level + this.woodcutter.level
      + this.quarry.level + this.copperMine.level + this.ironMine.level
      + this.goldMine.level + this.barracks.level + this.archery.level
      + this.stable.level + this.workshop.level + this.wall.level
      + this.tower.level
  }

  /**
   * Returns the total number of workers assigned across all producer buildings.
   * @returns {number} Total workers assigned across all producer buildings
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
   * Uses explicit property access instead of Object.entries() to avoid
   * proxy key enumeration and temporary array allocation on every 1s tick.
   * MAINTAIN: update this list when adding or removing non-HQ buildings.
   * Each counts as one reserved territory slot.
   * @returns {number} Count of non-HQ buildings under construction
   */
  get pendingTerritory() {
    let count = 0
    if (this.house.isConstructing) {
      count++
    }
    if (this.academy.isConstructing) {
      count++
    }
    if (this.storehouse.isConstructing) {
      count++
    }
    if (this.market.isConstructing) {
      count++
    }
    if (this.altar.isConstructing) {
      count++
    }
    if (this.temple.isConstructing) {
      count++
    }
    if (this.monument.isConstructing) {
      count++
    }
    if (this.farm.isConstructing) {
      count++
    }
    if (this.woodcutter.isConstructing) {
      count++
    }
    if (this.quarry.isConstructing) {
      count++
    }
    if (this.copperMine.isConstructing) {
      count++
    }
    if (this.ironMine.isConstructing) {
      count++
    }
    if (this.goldMine.isConstructing) {
      count++
    }
    if (this.barracks.isConstructing) {
      count++
    }
    if (this.archery.isConstructing) {
      count++
    }
    if (this.stable.isConstructing) {
      count++
    }
    if (this.workshop.isConstructing) {
      count++
    }
    if (this.wall.isConstructing) {
      count++
    }
    if (this.tower.isConstructing) {
      count++
    }
    return count
  }
}

export default Buildings
