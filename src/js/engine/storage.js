import {STORAGE_MUSIC_ENABLED, STORAGE_SOUND_ENABLED} from '@/js/engine/enums'

/**
 * Thin wrapper around localStorage for persisting user preferences.
 * Defaults to enabled (true) when no value has been stored yet.
 */
class Storage {
  /** @returns {boolean} Whether music is enabled */
  get musicEnabled() {
    try {
      return window.localStorage.getItem(STORAGE_MUSIC_ENABLED) !== 'false'
    } catch {
      return true
    }
  }

  /** @param {boolean} value - Whether music should be enabled */
  set musicEnabled(value) {
    try {
      window.localStorage.setItem(STORAGE_MUSIC_ENABLED, value)
    } catch { /* Safari Private Browsing may throw QuotaExceededError */ }
  }

  /** @returns {boolean} Whether sound effects are enabled */
  get soundEnabled() {
    try {
      return window.localStorage.getItem(STORAGE_SOUND_ENABLED) !== 'false'
    } catch {
      return true
    }
  }

  /** @param {boolean} value - Whether sound effects should be enabled */
  set soundEnabled(value) {
    try {
      window.localStorage.setItem(STORAGE_SOUND_ENABLED, value)
    } catch { /* Safari Private Browsing may throw QuotaExceededError */ }
  }
}

export default new Storage()
