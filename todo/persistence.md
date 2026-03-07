# Save & Load Feature

## Context
The game currently has no persistence — every session starts fresh. This feature adds save/load so players can continue where they left off. The home screen shows PLAY (new game) or CONTINUE (load saved game), the pause modal gets a SAVE button, and quitting prompts a confirmation with save options.

## Implementation Steps

### 1. Add storage constant (`src/js/engine/enums.js`)
- Add `STORAGE_SAVED_GAME = 'savedGame'` alongside existing `STORAGE_MUSIC_ENABLED` / `STORAGE_SOUND_ENABLED`

### 2. Extend Storage singleton (`src/js/engine/storage.js`)
- Import `STORAGE_SAVED_GAME`
- Add `savedGame` getter: reads + JSON.parses from localStorage, returns `null` on failure
- Add `savedGame` setter: JSON.stringifies + writes, try/catch for quota errors
- Add `deleteSavedGame()` method: removes the key

### 3. Add `toJSON()` methods (bottom-up)

**`building.js`** — add `toJSON()`: `{ level, constructionRemaining, constructionDuration }`

**`producer.js`** — override `toJSON()`: `{ ...super.toJSON(), workers }`

**`headquarters.js`** — override `toJSON()`: `{ ...super.toJSON(), type, upgradeRemaining, upgradeDuration }`

**`academy.js`** — already has `toJSON()`, no changes

**`market.js`** — already has `toJSON()`, no changes

**All other buildings** — inherit from Building or Producer, no changes

**`season.js`** — add `toJSON()`: `{ currentSeason, seasonElapsed }`

**`resources.js`** — add `toJSON()`: all 10 resource properties

**`buildings.js`** (container) — add `toJSON()`: iterates entries, calls each building's `toJSON()`

**`events.js`** — already has `toJSON()`, no changes

**`tutorial.js`** — already has `toJSON()`, no changes

**`colony.js`** — add `toJSON()`: `{ year, season, resources, buildings, events }` (skip production/consumption/productivity — ephemeral)

**`meta.js`** — add `toJSON()`: `{ version, createdDateTime, updatedDateTime: new Date().toISOString(), numberOfChallenges, tutorial }`

**`state.js`** — add `toJSON()`: `{ meta, colony }`

### 4. Add `static fromJSON()` methods

**`events.js`** — add `static fromJSON(data)`: constructs Events, rebuilds `future`/`past` arrays from serialized data, restores `_nextId`

**`buildings.js`** — add `static fromJSON(data, classMap)`: iterates entries, uses `BUILDING_CLASS_MAP` to instantiate correct class per key, returns new `Buildings(result)`. Takes `classMap` as parameter to avoid circular import with `constants.js`.

**`colony.js`** — add `static fromJSON(data, classMap)`: constructs sub-models (`new Season(data.season)`, `new Resources(data.resources)`, `Buildings.fromJSON(data.buildings, classMap)`, `Events.fromJSON(data.events)`, empty `new Production({})`, empty `new Consumption({})`), returns `new Colony(result)`. New imports: Season, Resources, Production, Consumption, Buildings, Events.

**`meta.js`** — add `static fromJSON(data)`: constructs `new Tutorial(data.tutorial)`, passes to `new Meta(...)`. Handles Date strings for `createdDateTime`/`updatedDateTime`. New import: Tutorial.

**`state.js`** — add `static fromJSON(data)`: calls `Meta.fromJSON()`, `Colony.fromJSON()` with `BUILDING_CLASS_MAP`, creates State, calls `state.update(0)` to recalculate all ephemeral/derived fields. Returns `null` on any error (corrupted save). New imports: Meta, Colony; add `BUILDING_CLASS_MAP` to existing constants import.

### 5. Add localization keys (all locale files under `src/js/i18n/`)
- `'screen.home.continue'` — "Continue"
- `'modal.pause.save'` — "Save"
- `'modal.confirmQuit.title'` — "Quit Game"
- `'modal.confirmQuit.message'` — "You have unsaved progress. What would you like to do?"
- `'modal.confirmQuit.cancel'` — "Cancel"
- `'modal.confirmQuit.saveAndQuit'` — "Save and Quit"
- `'modal.confirmQuit.quit'` — "Quit without Saving"

### 6. Modify home screen (`src/components/screens/home_screen.vue`)
- Import `storage`
- Add `hasSavedGame` computed from `storage.savedGame !== null`
- Show PLAY button when `!hasSavedGame`, CONTINUE button when `hasSavedGame`
- PLAY emits `@start` with `null` payload
- CONTINUE emits `@start` with `storage.savedGame` payload
- Dev auto-start: emit with `storage.savedGame` (loads save if exists, else fresh)

### 7. Pass State through app.vue (`src/app.vue`)
- Import `State`, `createInitialMeta`, `createInitialColony`
- Add `gameState` ref
- `startGame(savedData)`:
  - If `savedData`: `gameState = State.fromJSON(savedData)`
  - If `fromJSON` returns `null` (corrupted) or no saved data: create fresh State with `createInitialMeta()` + `createInitialColony()`, call `update(0)`
  - Set `currentScreen = 'game'`
- Pass `gameState` as `:initial-state` prop to GameScreen

### 8. Receive State as prop (`src/components/screens/game_screen.vue`)
- Add `initialState` prop (Object, required)
- Replace `new State(createInitialMeta(), createInitialColony()); state.update(0)` with `props.initialState`
- Remove unused `createInitialMeta`/`createInitialColony` imports
- Import `storage`
- Add `saveGame()`: `storage.savedGame = state.toJSON(); showModal.value = false`
- Change quit handler to show confirm quit modal instead of emitting directly

### 9. Add SAVE button to pause modal (`src/components/modals/pause_modal.vue`)
- Add `'save'` to emits
- Add SAVE button between Continue and Quit: `@click="playTap(); emit('save')"`
- The `save` emit triggers `saveGame()` in game_screen which also closes the modal

### 10. Create confirm quit modal (`src/components/modals/confirm_quit_modal.vue`)
- New component following pause_modal patterns (script setup, visible ref, rAF entrance animation)
- Emits: `cancel`, `saveAndQuit`, `quit`
- Three buttons: Cancel, Save and Quit, Quit (danger style)
- Uses `frontend-design` skill for styling

### 11. Wire quit flow in game_screen.vue
- Add `showConfirmQuit` ref
- Pause modal `@quit` → sets `showConfirmQuit = true`, hides pause modal
- ConfirmQuitModal `@cancel` → hides confirm, shows pause modal again
- ConfirmQuitModal `@saveAndQuit` → calls `storage.savedGame = state.toJSON()`, emits `quit`
- ConfirmQuitModal `@quit` → emits `quit` without saving

### 12. Lint & review
- Run `npm run lint -- --fix`
- Run `/delta-review`
- Check if `docs/architecture.md` or `docs/specs.md` need updating

## Key Files
| File | Change |
|------|--------|
| `src/js/engine/enums.js` | Add `STORAGE_SAVED_GAME` |
| `src/js/engine/storage.js` | Add `savedGame` getter/setter, `deleteSavedGame()` |
| `src/js/engine/state.js` | Add `toJSON()`, `static fromJSON()` |
| `src/js/models/meta.js` | Add `toJSON()`, `static fromJSON()` |
| `src/js/models/colony.js` | Add `toJSON()`, `static fromJSON()` |
| `src/js/models/buildings.js` | Add `toJSON()`, `static fromJSON(data, classMap)` |
| `src/js/models/buildings/building.js` | Add `toJSON()` |
| `src/js/models/buildings/producer.js` | Add `toJSON()` override |
| `src/js/models/buildings/headquarters.js` | Add `toJSON()` override |
| `src/js/models/season.js` | Add `toJSON()` |
| `src/js/models/resources.js` | Add `toJSON()` |
| `src/js/models/events/events.js` | Add `static fromJSON()` |
| `src/js/i18n/*.js` | Add 7 new keys |
| `src/components/screens/home_screen.vue` | PLAY vs CONTINUE logic |
| `src/app.vue` | Create State from saved data, pass as prop |
| `src/components/screens/game_screen.vue` | Receive State prop, save/quit flow |
| `src/components/modals/pause_modal.vue` | Add SAVE button |
| `src/components/modals/confirm_quit_modal.vue` | New component |

## Verification
1. Start fresh (no localStorage) → home screen shows PLAY → click → new game starts
2. In-game, pause → click SAVE → modal closes, `localStorage.savedGame` is populated
3. Refresh page → home screen shows CONTINUE → click → game resumes with saved state (year, resources, buildings, research, events all intact)
4. Pause → Quit → confirmation modal appears with 3 buttons
5. Cancel → returns to pause modal
6. Save and Quit → saves + returns to home screen (CONTINUE visible)
7. Quit → returns to home screen without saving
8. Corrupt localStorage manually → CONTINUE click falls back to new game gracefully
