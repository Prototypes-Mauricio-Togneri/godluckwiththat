class Storage {
  get musicEnabled() {
    return window.localStorage.getItem('musicEnabled') !== 'false'
  }

  set musicEnabled(value) {
    window.localStorage.setItem('musicEnabled', value)
  }

  get soundEnabled() {
    return window.localStorage.getItem('soundEnabled') !== 'false'
  }

  set soundEnabled(value) {
    window.localStorage.setItem('soundEnabled', value)
  }
}

export default new Storage()
