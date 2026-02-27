# Research System

A tech tree system where players spend Knowledge + resources + time to unlock passive bonuses. Accessed via the Academy card, which opens a tabbed modal.

## Design

- **5 categories** (tabs): General, Disasters, Resources, Religion, Military
- **Subcategories** within each category form linear research chains
- **Cost**: Knowledge + other resources (paid upfront when starting)
- **Duration**: Derived from cost via `cost.toSeconds()` (same as building upgrades)
- **Parallelism**: Unlimited concurrent researches
- **Prerequisites**: Linear within subcategory only (level N requires level N-1)
- **Gating**: Requires Academy to be built (level >= 1)
- **Progress**: Active researches appear as future events with countdown
- **Bonuses**: Multipliers computed on-the-fly during game tick

### Categories & Subcategories

| Category | Subcategories | Bonus Effects |
|----------|--------------|---------------|
| General | Transportation, Construction, Expansion, Storage, Habitation | +5%/tier worker productivity, -10%/tier construction time, -10%/tier expansion cost, +10%/tier storage capacity, +1/tier population |
| Resources | Food prod., Food cons., Wood prod., Wood cons., Mining, Knowledge | +/-5%/tier production/consumption rates |
| Disasters | Floods, Health, Earthquakes | -10%/tier flood/disease/earthquake impact |
| Religion | Faith | +5%/tier faith production |
| Military | Defense, Attack, Warning | +10%/tier unit defense, +10%/tier unit attack, +10%/tier warning time |

## Implementation Phases

### Phase 1: Data Model + Definitions + Tech Tree UI (View-Only)

Build the entire data layer and a read-only tech tree modal showing locked/available/completed states.

- Add enums: research categories, subcategories, individual keys, bonus types, event type
- Add `RESEARCH_DEFINITIONS` in `balancing.js` (costs, bonuses)
- Add `RESEARCH_TREE` in `constants.js` (structural tree topology)
- Create `Researches` model class (completed set, active map, bonus aggregation)
- Add `researches` property to Colony
- Add all i18n keys (en, es, fr)
- Create `research_modal.vue` (tabbed modal, view-only)
- Add research button to game header

### Phase 2: Research Mechanics (Start, Pay, Timer, Events, Completion)

Wire up the ability to start and complete researches.

- Add `researchKey` field to Event base class
- Add `startResearch()` to GameState (validate, deduct cost, create future event)
- Add `advanceResearch(delta)` to GameState (tick timers, handle completion)
- Hook `advanceResearch` into game tick loops
- Wire start button in research modal

### Phase 3: Apply Bonuses to Game Systems

Modify `GameState.update()` to apply research multipliers. Bonus aggregation is implemented (`completedBonuses()` runs every tick), but only `BONUS_HABITATION` is consumed (passed to `populationCap()`). All other 17 bonuses are computed but discarded. Remaining bonuses to wire up:

- Production bonuses: multiply food, wood, mining, knowledge, faith production rates
- Consumption reduction: reduce food/wood worker costs
- Storage bonus: multiply stockpile capacity caps
- Construction time: reduce build durations
- Expansion cost: reduce HQ upgrade costs
- Disaster bonuses: reduce flood/disease/earthquake impact
- Military bonuses: apply unit defense, unit attack, warning time

### Phase 4: Polish

- Balancing pass on all research values (costs, bonus percentages)
- Visual polish on research nodes (icons, animations, progress indicators)
- Documentation updates (CLAUDE.md, architecture.md, specs.md)
