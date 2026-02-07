/**
 * Container for all colony building instances.
 *
 * @property {Headquarters} headquarters - Main colony building
 * @property {House} house - Worker housing
 * @property {Academy} academy - Knowledge production
 * @property {Storehouse} storehouse - Storage capacity upgrades
 * @property {Market} market - Resource trading
 * @property {Altar} altar - Faith building
 * @property {Shrine} shrine - Faith building
 * @property {Temple} temple - Faith building
 * @property {Monument} monument - Faith building
 * @property {Farm} farm - Food production
 * @property {Woodcutter} woodcutter - Wood production
 * @property {Quarry} quarry - Stone production
 * @property {CopperMine} copperMine - Copper production
 * @property {IronMine} ironMine - Iron production
 * @property {GoldMine} goldMine - Gold production
 * @property {Barracks} barracks - Military infantry
 * @property {Archery} archery - Military ranged
 * @property {Stable} stable - Military mounted
 * @property {Workshop} workshop - Military siege
 * @property {Wall} wall - Defensive structure
 * @property {Tower} tower - Defensive structure
 */
class Buildings {
  /**
   * @param {Object} data - Pre-constructed building instances keyed by name
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
    this.stable = data.stable
    this.workshop = data.workshop
    this.wall = data.wall
    this.tower = data.tower
  }
}

export default Buildings
