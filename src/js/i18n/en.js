export const LOCALIZED_EN = {
  // Home screen
  'screen.home.title.line1': 'God Luck',
  'screen.home.title.line2': 'With That',
  'screen.home.play': 'Play',

  // Pause modal
  'modal.pause.title': 'Paused',
  'modal.pause.continue': 'Continue',
  'modal.pause.quit': 'Quit',

  // Resources
  'resource.food': 'Food',
  'resource.wood': 'Wood',
  'resource.stone': 'Stone',
  'resource.population': 'Population',
  'resource.idleWorkers': 'Idle Workers',
  'resource.territory': 'Territory',

  // Seasons
  'season.name': 'Season',
  'season.warm': 'Warm',
}

/** Lookup helper — returns the localized string for the given key. */
export const t = key => LOCALIZED_EN[key]
