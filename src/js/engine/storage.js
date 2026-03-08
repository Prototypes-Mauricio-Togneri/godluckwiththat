import {STORAGE_AUTOSAVE_ENABLED, STORAGE_AUTOSAVE_INTERVAL, STORAGE_MUSIC_ENABLED, STORAGE_SAVED_GAME, STORAGE_SOUND_ENABLED} from '@/js/engine/enums.js'
import {AUTOSAVE_DEFAULT_INTERVAL} from '@/js/engine/constants.js'

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

  /** @returns {Object|null} Parsed saved game data, or null if none/corrupt */
  get savedGame() {
    try {
      const raw = window.localStorage.getItem(STORAGE_SAVED_GAME)
      return raw ? JSON.parse(raw) : null
    } catch {
      return null
    }
  }

  /** @param {Object} value - Game state data to persist */
  set savedGame(value) {
    try {
      window.localStorage.setItem(STORAGE_SAVED_GAME, JSON.stringify(value))
    } catch { /* quota exceeded */ }
  }

  /** @returns {boolean} Whether autosave is enabled */
  get autosaveEnabled() {
    try {
      return window.localStorage.getItem(STORAGE_AUTOSAVE_ENABLED) === 'true'
    } catch {
      return false
    }
  }

  /** @param {boolean} value - Whether autosave should be enabled */
  set autosaveEnabled(value) {
    try {
      window.localStorage.setItem(STORAGE_AUTOSAVE_ENABLED, value)
    } catch { /* quota exceeded */ }
  }

  /** @returns {number} Autosave interval in minutes */
  get autosaveInterval() {
    try {
      const raw = window.localStorage.getItem(STORAGE_AUTOSAVE_INTERVAL)
      return raw ? Number(raw) : AUTOSAVE_DEFAULT_INTERVAL
    } catch {
      return AUTOSAVE_DEFAULT_INTERVAL
    }
  }

  /** @param {number} value - Autosave interval in minutes */
  set autosaveInterval(value) {
    try {
      window.localStorage.setItem(STORAGE_AUTOSAVE_INTERVAL, value)
    } catch { /* quota exceeded */ }
  }

  /** Removes the saved game from localStorage. */
  deleteSavedGame() {
    try {
      window.localStorage.removeItem(STORAGE_SAVED_GAME)
    } catch { /* ignore */ }
  }
}

export default new Storage()
