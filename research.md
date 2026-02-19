# Research System

A tech tree system where players spend Knowledge + resources + time to unlock passive bonuses. Accessed via a dedicated header button that opens a tabbed modal.

## Design

- **5 categories** (tabs): General, Disasters, Resources, Religion, Military
- **Subcategories** within each category form linear research chains
- **Cost**: Knowledge + other resources (paid upfront when starting)
- **Duration**: Fixed timer per research (not affected by workers)
- **Parallelism**: Unlimited concurrent researches
- **Prerequisites**: Linear within subcategory only (level N requires level N-1)
- **Gating**: Each research requires a minimum Academy building level
- **Progress**: Active researches appear as future events with countdown
- **Bonuses**: Multipliers computed on-the-fly during game tick

### Categories & Subcategories

| Category | Subcategories | Bonus Effects |
|----------|--------------|---------------|
| General | Transportation, Construction, Expansion, Trading | +% worker productivity, -% construction time, -% expansion cost, -% trade fees |
| Disasters | Floods, Health, Earthquakes | -% flood impact, -% disease impact, -% earthquake impact |
| Resources | Food prod., Food cons., Wood prod., Wood cons., Mining, Knowledge, Storage | +/- % production/consumption rates, +% warehouse capacity |
| Religion | Faith | +% faith production |
| Military | TBD | TBD |

## Implementation Phases

### Phase 1: Data Model + Definitions + Tech Tree UI (View-Only)

Build the entire data layer and a read-only tech tree modal showing locked/available/completed states.

- Add enums: research categories, subcategories, individual keys, bonus types, event type
- Add `RESEARCH_DEFINITIONS` in `balancing.js` (costs, durations, academy gates, bonuses)
- Add `RESEARCH_TREE` in `constants.js` (structural tree topology)
- Create `Researches` model class (completed set, active map, bonus aggregation)
- Add `researches` property to Colony
- Add all i18n keys (en + es)
- Create `research_modal.vue` (tabbed modal, view-only)
- Add research button to game header

### Phase 2: Research Mechanics (Start, Pay, Timer, Events, Completion)

Wire up the ability to start and complete researches.

- Add `researchKey` field to Event base class
- Add `convertResearchToPast()` to Events container
- Add `startResearch()` to GameState (validate, deduct cost, create future event)
- Add `advanceResearch(delta)` to GameState (tick timers, handle completion)
- Hook `advanceResearch` into game tick loops
- Wire start button in research modal

### Phase 3: Apply Bonuses to Game Systems

Modify `GameState.update()` to apply research multipliers.

- Production bonuses: multiply food, wood, mining, knowledge, faith production rates
- Consumption reduction: reduce food/wood worker costs
- Storage bonus: multiply stockpile capacity caps
- Construction time: reduce build durations
- Expansion cost: reduce HQ upgrade costs
- Disaster bonuses: placeholder until disaster system exists

### Phase 4: Polish

- Balancing pass on all research values (costs, durations, academy gates, bonus percentages)
- Visual polish on research nodes (icons, animations, progress indicators)
- Documentation updates (CLAUDE.md, architecture.md, specs.md)
