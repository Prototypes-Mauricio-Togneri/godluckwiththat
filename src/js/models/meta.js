/**
 * Game metadata. Tracks save version, timestamps,
 * challenge configuration, and tutorial progress.
 *
 * @property {number} version - Save format version
 * @property {string} createdDateTime - When the game was created (ISO string)
 * @property {string} updatedDateTime - When the game was last updated (ISO string)
 * @property {number} numberOfChallenges - Total divine challenges
 * @property {Tutorial} tutorial - Tutorial progress
 */
class Meta {
  /**
   * @param {Object} data - Meta data
   */
  constructor(data) {
    this.version = data.version // Save format version
    this.createdDateTime = data.createdDateTime // When the game was created
    this.updatedDateTime = data.updatedDateTime // When the game was last updated
    this.numberOfChallenges = data.numberOfChallenges // Total divine challenges
    this.tutorial = data.tutorial // Tutorial progress
  }
}

export default Meta
