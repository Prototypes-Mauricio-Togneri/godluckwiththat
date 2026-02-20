/**
 * Thin wrapper around localStorage for persisting user preferences.
 * Defaults to enabled (true) when no value has been stored yet.
 */
class Storage {
  /** @returns {boolean} Whether music is enabled */
  get musicEnabled() {
    return window.localStorage.getItem('musicEnabled') !== 'false'
  }

  /** @param {boolean} value - Whether music should be enabled */
  set musicEnabled(value) {
    window.localStorage.setItem('musicEnabled', value)
  }

  /** @returns {boolean} Whether sound effects are enabled */
  get soundEnabled() {
    return window.localStorage.getItem('soundEnabled') !== 'false'
  }

  /** @param {boolean} value - Whether sound effects should be enabled */
  set soundEnabled(value) {
    window.localStorage.setItem('soundEnabled', value)
  }
}

export default new Storage()
