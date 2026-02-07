import Building from './building.js'

/**
 * Colony headquarters building.
 */
class Headquarters extends Building {
  /**
   * @param {Object} data - Initial headquarters data with level and type
   */
  constructor(data) {
    super(data)
    this.type = data.type // Headquarters progression type (e.g. 'camp')
  }
}

export default Headquarters
