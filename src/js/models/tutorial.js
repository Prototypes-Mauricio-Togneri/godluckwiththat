/**
 * Tutorial data model. Tracks step progression, completion state,
 * and dismissed modal history.
 *
 * @property {number} currentStep - Current tutorial step index (starts at 0)
 * @property {boolean} completed - Whether the tutorial has been completed
 * @property {Set<string>} dismissedModals - Set of dismissed modal identifiers
 * @property {string|null} activeModal - Currently displayed modal identifier (ephemeral, not serialized)
 */
class Tutorial {
  /**
   * @param {Object} [data] - Saved tutorial data (optional, defaults applied)
   */
  constructor(data) {
    this.currentStep = data?.currentStep ?? 0
    this.completed = data?.completed ?? false
    this.dismissedModals = new Set(data?.dismissedModals ?? [])
    this.activeModal = null
  }

  /** @returns {boolean} Whether the tutorial is still in progress */
  get isActive() {
    return !this.completed
  }

  /**
   * Serializes tutorial state for saving (excludes ephemeral activeModal).
   * @returns {Object} JSON-serializable tutorial data
   */
  toJSON() {
    return {
      currentStep: this.currentStep,
      completed: this.completed,
      dismissedModals: [...this.dismissedModals],
    }
  }
}

export default Tutorial
