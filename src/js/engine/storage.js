import {STORAGE_MUSIC_ENABLED, STORAGE_SAVED_GAME, STORAGE_SOUND_ENABLED} from '@/js/engine/enums'

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

  /** Removes the saved game from localStorage. */
  deleteSavedGame() {
    try {
      window.localStorage.removeItem(STORAGE_SAVED_GAME)
    } catch { /* ignore */ }
  }
}

export default new Storage()
