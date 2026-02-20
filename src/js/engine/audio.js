import {AUDIO_CONFIG} from '@/js/engine/constants.js'
import storage from '@/js/engine/storage.js'

class Audio {
  constructor() {
    this._musicEnabled = storage.musicEnabled
    this._soundEnabled = storage.soundEnabled
    this._music = null
    this._musicPath = null
  }

  playSound(assetPath) {
    if (!this._soundEnabled) return
    const el = new window.Audio(assetPath)
    el.volume = this._volume(assetPath)
    el.play().catch(() => {})
  }

  playMusic(assetPath) {
    this._musicPath = assetPath
    if (!this._musicEnabled) return
    if (this._music && !this._music.paused) return
    this._music = new window.Audio(assetPath)
    this._music.loop = true
    this._music.volume = this._volume(assetPath)
    this._music.play().catch(() => {})
  }

  stopMusic() {
    if (!this._music) return
    this._music.pause()
    this._music.currentTime = 0
    this._music = null
    this._musicPath = null
  }

  pauseMusic() {
    if (!this._music) return
    this._music.pause()
  }

  resumeMusic() {
    if (!this._music) return
    this._music.play().catch(() => {})
  }

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

  setSoundEnabled(enabled) {
    this._soundEnabled = enabled
    storage.soundEnabled = enabled
  }

  _volume(assetPath) {
    const config = AUDIO_CONFIG[assetPath]
    return config ? config.volume : 1.0
  }
}

export default new Audio()
