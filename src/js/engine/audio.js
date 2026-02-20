import {AUDIO_CONFIG} from '@/js/engine/constants.js'
import storage from '@/js/engine/storage.js'

/**
 * Manages sound effects and background music playback.
 * Persists enabled/disabled preferences via storage.
 */
class Audio {
  constructor() {
    this._musicEnabled = storage.musicEnabled // Whether music is on (persisted)
    this._soundEnabled = storage.soundEnabled // Whether sounds are on (persisted)
    this._music = null // Current HTMLAudioElement for music
    this._musicPath = null // Asset path of the current music track
  }

  /**
   * Plays a one-shot sound effect.
   * @param {string} assetPath - Asset path constant from assets.js
   */
  playSound(assetPath) {
    if (!this._soundEnabled) return
    const el = new window.Audio(assetPath)
    el.volume = this._volume(assetPath)
    el.play().catch(() => {})
  }

  /**
   * Starts looping background music. No-op if already playing.
   * @param {string} assetPath - Asset path constant from assets.js
   */
  playMusic(assetPath) {
    this._musicPath = assetPath
    if (!this._musicEnabled) return
    if (this._music && !this._music.paused) return
    this._music = new window.Audio(assetPath)
    this._music.loop = true
    this._music.volume = this._volume(assetPath)
    this._music.play().catch(() => {})
  }

  /**
   * Stops music and resets playback position.
   */
  stopMusic() {
    if (!this._music) return
    this._music.pause()
    this._music.currentTime = 0
    this._music = null
    this._musicPath = null
  }

  /**
   * Pauses the current music track without resetting position.
   */
  pauseMusic() {
    if (!this._music) return
    this._music.pause()
  }

  /**
   * Resumes a previously paused music track.
   */
  resumeMusic() {
    if (!this._music) return
    this._music.play().catch(() => {})
  }

  /**
   * Toggles music on or off. Persists the preference and starts/stops playback accordingly.
   * @param {boolean} enabled - Whether music should be enabled
   */
  setMusicEnabled(enabled) {
    this._musicEnabled = enabled
    storage.musicEnabled = enabled
    if (enabled && this._musicPath && !this._music) {
      this._music = new window.Audio(this._musicPath)
      this._music.loop = true
      this._music.volume = this._volume(this._musicPath)
      this._music.play().catch(() => {})
    }
    if (!enabled && this._music) {
      this._music.pause()
      this._music = null
    }
  }

  /**
   * Toggles sound effects on or off. Persists the preference.
   * @param {boolean} enabled - Whether sound effects should be enabled
   */
  setSoundEnabled(enabled) {
    this._soundEnabled = enabled
    storage.soundEnabled = enabled
  }

  /**
   * Resolves volume for an asset from AUDIO_CONFIG, defaulting to 1.0.
   * @param {string} assetPath - Asset path to look up
   * @returns {number} Volume level between 0 and 1
   */
  _volume(assetPath) {
    const config = AUDIO_CONFIG[assetPath]
    return config ? config.volume : 1.0
  }
}

export default new Audio()
