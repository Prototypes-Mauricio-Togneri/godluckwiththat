# Tutorial System Implementation Plan

## Context

The game needs a tutorial system to guide new players through early-game mechanics. It consists of two subsystems:

1. **Sequential tutorial** -- 15 ordered steps shown as a fixed banner at the bottom of the screen. Auto-advances when the player completes each step. No skip option.
2. **Reactive dialogs** -- Modal popups triggered by game state transitions (season change, productivity drop, HQ upgrade). Each fires only once ever (persisted in save data).

## Architecture

### New Files

| File | Purpose |
|------|---------|
| `src/js/models/tutorial.js` | `Tutorial` class -- holds `currentStep`, `completed`, `dismissedDialogs` (Set), `activeDialog` (ephemeral) |
| `src/components/tutorial/tutorial_banner.vue` | Fixed bottom banner showing current step instruction |
| `src/components/tutorial/tutorial_dialog.vue` | Modal dialog for reactive tips (reuses existing modal pattern) |

### Modified Files

| File | Change |
|------|--------|
| `src/js/engine/enums.js` | Add `TUTORIAL_DIALOG_*` string enums |
| `src/js/engine/constants.js` | Add `TUTORIAL_STEPS` array, `TUTORIAL_DIALOGS` map, wire `Tutorial` into `createInitialColony*` factories |
| `src/js/models/colony.js` | Add `this.tutorial` field |
| `src/js/engine/state.js` | Add `checkTutorial()` method (called from `gameTick`); add reactive dialog triggers in `advanceSeason()` and `update()` |
| `src/components/screens/game_screen.vue` | Add `ui.tutorial` fields, `syncTutorial()`, render banner + dialog, `dismissTutorialDialog` action |
| `src/js/i18n/en.js` | Add ~20 tutorial i18n keys |
| `src/js/i18n/es.js` | Add ~20 tutorial i18n keys |
| `src/js/i18n/fr.js` | Add ~20 tutorial i18n keys |
| `src/js/i18n/ca.js` | Add ~20 tutorial i18n keys |
| `src/js/i18n/it.js` | Add ~20 tutorial i18n keys |
| `src/assets/styles.css` | Add `.tutorial-banner` styles (if shared) |

## Step Definitions

Defined as `TUTORIAL_STEPS` in `constants.js`. Each step has a `textKey` (i18n) and a `check(buildings)` function:

| # | Text Key | Completion Check |
|---|----------|-----------------|
| 1 | `tutorial.step.buildHouse` | `house.level >= 1` |
| 2 | `tutorial.step.buildFarm` | `farm.level >= 1` |
| 3 | `tutorial.step.buildWoodcutter` | `woodcutter.level >= 1` |
| 4 | `tutorial.step.assignFarmWorkers` | `farm.workers >= 3` |
| 5 | `tutorial.step.assignWoodcutterWorker` | `woodcutter.workers >= 1` |
| 6 | `tutorial.step.assignMoreWorkers` | `farm.workers > 3 \|\| woodcutter.workers > 1` |
| 7 | `tutorial.step.upgradeHouse2` | `house.level >= 2` |
| 8 | `tutorial.step.buildAltar` | `altar.level >= 1` |
| 9 | `tutorial.step.upgradeFarm2` | `farm.level >= 2` |
| 10 | `tutorial.step.upgradeWoodcutter2` | `woodcutter.level >= 2` |
| 11 | `tutorial.step.upgradeHouse3` | `house.level >= 3` |
| 12 | `tutorial.step.upgradeFarm3` | `farm.level >= 3` |
| 13 | `tutorial.step.upgradeWoodcutter3` | `woodcutter.level >= 3` |
| 14 | `tutorial.step.expandTerritory` | `headquarters.level >= 2` |
| 15 | `tutorial.step.upgradeHQ` | `headquarters.type !== HQ_TYPE_CAMP` |

Only `currentStep` (integer index) is persisted. Check functions live in the constant array and are re-evaluated against live state.

## Reactive Dialogs

Defined as `TUTORIAL_DIALOGS` in `constants.js`. Triggered by state transitions, shown as modals with a "Got it" dismiss button. Each fires once ever (key stored in `tutorial.dismissedDialogs` Set, persisted).

| Key | Trigger | Content |
|-----|---------|---------|
| `seasonChanged` | Season flips in `advanceSeason()` | Explain warm/cold effects on food/wood production |
| `productivityDrop` | `productivity < 1` transition in `update()` | Explain why productivity drops and how to recover |
| `hqUpgrade` | HQ type upgrade completes in `advanceConstruction()` | List newly unlocked buildings via `HQ_BUILDING_UNLOCKS[newType]` |

`activeDialog` is ephemeral (not persisted). On load, it starts as `null` and only fires on the next relevant transition.

## Tutorial Model (`src/js/models/tutorial.js`)

```js
class Tutorial {
  constructor(data) {
    this.currentStep = data?.currentStep ?? 0
    this.completed = data?.completed ?? false
    this.dismissedDialogs = new Set(data?.dismissedDialogs ?? [])
    this.activeDialog = null  // ephemeral, not persisted
  }

  get isActive() { return !this.completed }

  toJSON() {
    return {
      currentStep: this.currentStep,
      completed: this.completed,
      dismissedDialogs: [...this.dismissedDialogs],
    }
  }
}
```

## State Integration

### `checkTutorial()` -- called every `gameTick` (1s interval)

```js
checkTutorial() {
  const tutorial = this.colony.tutorial
  if (!tutorial.isActive) return
  const step = TUTORIAL_STEPS[tutorial.currentStep]
  if (step?.check(this.colony.buildings)) {
    tutorial.currentStep++
    if (tutorial.currentStep >= TUTORIAL_STEPS.length) {
      tutorial.completed = true
    }
  }
}
```

### Reactive dialog triggers

- **Season change** (`advanceSeason`): After season flip, if `'seasonChanged'` not in `dismissedDialogs`, set `tutorial.activeDialog = 'seasonChanged'`
- **Productivity drop** (`update`): Track `_prevProductivity`. When it transitions from `>= 1` to `< 1`, if `'productivityDrop'` not in `dismissedDialogs`, set `tutorial.activeDialog = 'productivityDrop'`
- **HQ upgrade** (`advanceConstruction`): When HQ type upgrade completes, if `'hqUpgrade'` not in `dismissedDialogs`, set `tutorial.activeDialog = 'hqUpgrade'`

## UI Integration (`game_screen.vue`)

Add to `ui` shallowReactive:
```js
tutorial: {
  stepTextKey: null,
  stepNumber: 0,
  totalSteps: 0,
  isActive: false,
  activeDialog: null,
}
```

Add `syncTutorial()` called from `syncUI()`:
```js
function syncTutorial() {
  const { tutorial } = state.colony
  const step = TUTORIAL_STEPS[tutorial.currentStep]
  ui.tutorial = {
    stepTextKey: step?.textKey ?? null,
    stepNumber: tutorial.currentStep + 1,
    totalSteps: TUTORIAL_STEPS.length,
    isActive: tutorial.isActive,
    activeDialog: tutorial.activeDialog,
  }
}
```

Render banner and dialog:
```html
<TutorialBanner v-if="ui.tutorial.isActive" ... />
<TutorialDialog v-if="ui.tutorial.activeDialog" ... @close="dismissDialog" />
```

Dismiss handler calls `state.colony.tutorial.dismissedDialogs.add(key)`, sets `activeDialog = null`, then `syncUI()`.

## Banner Design (bottom fixed bar)

- `position: fixed; bottom: 0; left: 0; right: 0; z-index: 50`
- Shows step indicator (e.g., "3/15") and instruction text
- Non-blocking -- player can interact with the game freely
- Earthy theme matching the game's parchment aesthetic (use `frontend-design` skill)

## Dialog Design (modal overlay)

- Reuses existing `.modal-overlay` / `.modal-content` pattern
- Title, description text, optional building list (for HQ upgrade), "Got it" button
- Same visual style as other game modals

## Implementation Order

1. Add `TUTORIAL_DIALOG_*` enums to `enums.js`
2. Create `Tutorial` model class in `src/js/models/tutorial.js`
3. Add `tutorial` field to `Colony` constructor
4. Add `TUTORIAL_STEPS` and `TUTORIAL_DIALOGS` to `constants.js`, wire into `createInitialColony*`
5. Add `checkTutorial()` and reactive dialog triggers to `state.js`
6. Add `ui.tutorial`, `syncTutorial()`, dismiss handler to `game_screen.vue`
7. Create `tutorial_banner.vue` (use `frontend-design` skill)
8. Create `tutorial_dialog.vue` (use `frontend-design` skill)
9. Add i18n keys to all 5 locale files
10. Run `npm run lint -- --fix`
11. Run `/delta-review`
12. Update `docs/architecture.md` if needed

## Verification

1. Start a new game -> banner shows step 1 ("Build a house")
2. Build a house -> banner auto-advances to step 2
3. Progress through all 15 steps -> banner disappears after step 15
4. Wait for season change -> dialog appears explaining season effects, dismiss it -> never appears again
5. Let productivity drop below 100% -> dialog appears, dismiss -> never again
6. Upgrade HQ type -> dialog appears listing newly unlocked buildings
7. Reload page -> tutorial progress is preserved (once save/load is implemented; for now, tutorial restarts but dialogs are also reset since state is ephemeral)
