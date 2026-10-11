import {TUTORIAL_MODALS, TUTORIAL_STEPS} from '@/js/engine/constants.js'

/**
 * Tutorial data model. Tracks step progression, completion state,
 * and dismissed modal history.
 *
 * @property {number} currentStep - Current tutorial step index (starts at 0)
 * @property {boolean} completed - Whether the tutorial has been completed
 * @property {Set<string>} dismissedModals - Set of dismissed modal identifiers
 * @property {string|null} activeModal - Currently displayed modal identifier
 */
class Tutorial {
  /**
   * @param {Object} [data] - Saved tutorial data (optional, defaults applied)
   */
  constructor(data) {
    this.currentStep = data?.currentStep ?? 0 // Current tutorial step index
    this.completed = data?.completed ?? false // Whether the tutorial is complete
    this.dismissedModals = new Set(data?.dismissedModals ?? []) // Set of dismissed modal identifiers
    // Only restore a known modal key, so an edited or outdated save can't break the modal lookup
    const savedModal = data?.activeModal
    this.activeModal = Object.keys(TUTORIAL_MODALS).includes(savedModal) ? savedModal : null // Currently displayed modal identifier
  }

  /** @returns {boolean} Whether the tutorial is still in progress */
  get isActive() {
    return !this.completed
  }

  /** @returns {boolean} Whether all tutorial steps have been completed */
  get allStepsCompleted() {
    return this.currentStep >= TUTORIAL_STEPS.length
  }

  /** @returns {boolean} Whether all tutorial modals have been dismissed */
  get allModalsDismissed() {
    return Object.keys(TUTORIAL_MODALS).every(key => this.dismissedModals.has(key))
  }

  /**
   * Serializes tutorial state for saving.
   * @returns {Object} JSON-serializable tutorial data
   */
  toJSON() {
    return {
      currentStep: this.currentStep,
      completed: this.completed,
      dismissedModals: [...this.dismissedModals],
      activeModal: this.activeModal,
    }
  }
}

export default Tutorial
