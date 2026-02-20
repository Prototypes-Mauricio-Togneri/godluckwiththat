import {AUDIO_CONFIG} from '@/js/engine/constants.js'

class Audio {
  constructor() {
    this._muted = false
    this._music = null
    this._musicPath = null
  }

  playSound(assetPath) {
    if (this._muted) return
    const el = new window.Audio(assetPath)
    el.volume = this._volume(assetPath)
    el.play().catch(() => {})
  }

  playMusic(assetPath) {
    if (this._musicPath === assetPath && this._music && !this._music.paused) return
    this.stopMusic()
    this._music = new window.Audio(assetPath)
    this._music.loop = true
    this._music.volume = this._muted ? 0 : this._volume(assetPath)
    this._musicPath = assetPath
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

  setMuted(muted) {
    this._muted = muted
    if (this._music) {
      this._music.volume = muted ? 0 : this._volume(this._musicPath)
    }
  }

  _volume(assetPath) {
    const config = AUDIO_CONFIG[assetPath]
    return config ? config.volume : 1.0
  }
}

export default new Audio()
