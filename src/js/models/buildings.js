/**
 * Tracks building data for the colony.
 */
class Buildings {
  /**
   * @param {Object} data - Initial building data keyed by building name
   */
  constructor(data) {
    this.headquarters = data.headquarters
    this.house = data.house
    this.academy = data.academy
    this.storehouse = data.storehouse
    this.market = data.market
    this.altar = data.altar
    this.shrine = data.shrine
    this.temple = data.temple
    this.monument = data.monument
    this.farm = data.farm
    this.woodcutter = data.woodcutter
    this.quarry = data.quarry
    this.copperMine = data.copperMine
    this.ironMine = data.ironMine
    this.goldMine = data.goldMine
    this.barracks = data.barracks
    this.archery = data.archery
    this.cavalry = data.cavalry
    this.workshop = data.workshop
    this.wall = data.wall
    this.tower = data.tower
  }
}

export default Buildings
