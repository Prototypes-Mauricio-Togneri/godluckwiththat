# Research System

A tech tree system where players spend Knowledge + resources + time to unlock passive bonuses. Accessed via the Academy card, which opens a tabbed modal.

## Design

- **5 categories** (tabs): General, Disasters, Resources, Religion, Military
- **Subcategories** within each category form linear research chains
- **Cost**: Knowledge + other resources (paid upfront when starting)
- **Duration**: Derived from cost via `cost.toSeconds` (same as building upgrades)
- **Parallelism**: Unlimited concurrent researches
- **Prerequisites**: Linear within subcategory only (level N requires level N-1)
- **Gating**: Requires Academy to be built (level >= 1)
- **Progress**: Active researches appear as future events with countdown
- **Bonuses**: Multipliers computed on-the-fly during game tick

### Categories & Subcategories

- **General** — Transportation, Construction, Expansion, Storage, Habitation
  - +5%/tier worker productivity, -10%/tier construction time, -10%/tier expansion cost, +10%/tier storage capacity, +1/tier population
- **Resources** — Food prod., Food cons., Wood prod., Wood cons., Mining, Knowledge
  - +/-5%/tier production/consumption rates
- **Disasters** — Floods, Health, Earthquakes
  - -10%/tier flood/disease/earthquake impact
- **Religion** — Faith
  - +5%/tier faith production
- **Military** — Defense, Attack, Warning
  - +10%/tier unit defense, +10%/tier unit attack, +10%/tier warning time

## Implementation Phases

### Phase 1: Data Model + Definitions + Tech Tree UI (View-Only) — DONE

Built the entire data layer and a read-only tech tree modal showing locked/available/completed states.

- Add enums: research categories, subcategories, individual keys, bonus types, event type
- Add `RESEARCH_COSTS` in `balancing.js` (costs, bonuses)
- Add `RESEARCH_TREE` in `constants.js` (structural tree topology)
- Create Academy model class (completed set, active map, bonus aggregation)
- Add academy to Colony buildings
- Add all i18n keys (en, es, fr)
- Create `research_modal.vue` (tabbed modal, view-only)
- Add research button to game header

### Phase 2: Research Mechanics (Start, Pay, Timer, Events, Completion) — DONE

Wired up the ability to start and complete researches.

- Add `researchKey` field to Event base class
- Add `startResearch()` to State (validate, deduct cost, create future event) — `state.js:440`
- Add `advanceResearch(delta)` to State (tick timers, handle completion) — `state.js:249`
- Hook `advanceResearch` into game tick loops
- Wire start button in research modal

### Phase 3: Apply Bonuses to Game Systems

Bonus aggregation runs every tick at `state.js:51` via `buildings.academy.completedBonuses(RESEARCH_TREE)`, returning a `{bonusType: cumulativeValue}` map. Each bonus value is a cumulative float (e.g. 3 tiers of Transportation at 0.05/tier → `workerProductivity: 0.15`). Habitation is flat (3 tiers → `habitation: 3`).

#### Step 3a: Production bonuses (6 bonuses) — DONE

`PRODUCTION_BONUS_MAP` in `balancing.js` maps each building to its bonus type. Applied in the `PRODUCTION_RATES` loop at `state.js:68-82`:

```js
const workerMult = 1 + (bonuses[BONUS_WORKER_PRODUCTIVITY] ?? 0)
for (const [buildingKey, config] of Object.entries(PRODUCTION_RATES)) {
  const building = buildings[buildingKey]
  if (building.level > 0) {
    const bonusType = PRODUCTION_BONUS_MAP[buildingKey]
    const resMult = 1 + (bonusType ? (bonuses[bonusType] ?? 0) : 0)
    if (config.passive) {
      production[config.resource] += building.level * config.rate * resMult
    } else if (building.workers > 0) {
      production[config.resource] += building.workers * config.rate * resMult * workerMult
    }
  }
}
```

**Bonuses covered:**
- `BONUS_FOOD_PRODUCTION` → Farm (+5%/tier)
- `BONUS_WOOD_PRODUCTION` → Woodcutter (+5%/tier)
- `BONUS_MINING_PRODUCTION` → Quarry, Copper Mine, Iron Mine, Gold Mine (+5%/tier)
- `BONUS_KNOWLEDGE_PRODUCTION` → Academy (+5%/tier)
- `BONUS_FAITH_PRODUCTION` → Temple, Altar (+5%/tier)

The seasonal food modifier (`state.js:86`) stacks multiplicatively on top.

#### Step 3b: Worker productivity bonus (1 bonus) — DONE

`BONUS_WORKER_PRODUCTIVITY` is applied as an additional multiplier in the worker branch only (`state.js:67,79`). Stacks with per-resource bonuses (e.g. a farm with 3 Transportation tiers + 2 Food Production tiers gets `rate * 1.15 * 1.10`).

#### Step 3c: Consumption reduction bonuses (2 bonuses) — DONE

Effective consumption rates computed once at `state.js:102-103`, used for both deduction (`state.js:104-110`) and display (`state.js:151-157`):

```js
const effFoodCons = WORKER_FOOD_CONSUMPTION * (1 - (bonuses[BONUS_FOOD_CONSUMPTION] ?? 0))
const effWoodCons = WORKER_WOOD_CONSUMPTION * (1 - (bonuses[BONUS_WOOD_CONSUMPTION] ?? 0))
```

**Bonuses covered:**
- `BONUS_FOOD_CONSUMPTION` → reduces food upkeep per worker (-5%/tier, linear)
- `BONUS_WOOD_CONSUMPTION` → reduces wood upkeep per worker (-5%/tier, linear)

#### Step 3d: Storage capacity bonus (1 bonus) — DONE

**Where:** `storehouse.js:20-22` (`storageCap` getter) and `state.js:54,113-118` (storage cap usage).

**Current code** (`storehouse.js`):
```js
get storageCap() {
  return STOREHOUSE_BASE_CAPACITY + this.level * STOREHOUSE_CAPACITY_PER_LEVEL
}
```

**Plan:** Keep `storageCap` as a pure getter (per project conventions). Apply the bonus in `state.js` where the cap is consumed — compute an effective cap once after getting `bonuses`:

```js
const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
const storageCap = Math.floor(buildings.storehouse.storageCap * (1 + storageBonus))
```

Then use this local `storageCap` for all 6 resource caps (`state.js:113-118`) and the market trade cap (`state.js:480`).

#### Step 3e: Construction time bonus (1 bonus) — DONE

**Where:** `state.js` — 3 locations that derive duration from cost:
- Line 316: `levelUpBuilding()` — calls `building.levelUp(cost)` which internally uses `cost.toSeconds`
- Line 356: `expandTerritory()` — calls `hq.levelUp(cost)` (same path)
- Line 385: `upgradeHeadquarters()` — calls `hq.upgradeType(cost)` which uses `cost.toSeconds`

**Plan:** Apply the bonus to reduce duration at each call site. Since `levelUp()` and `upgradeType()` both derive duration from the cost, either:
- Pass a pre-discounted cost to these methods, or
- Add an optional `durationMultiplier` parameter

Extract the bonus computation to avoid repetition:
```js
const constructionBonus = bonuses[BONUS_CONSTRUCTION_TIME] ?? 0
const durationMult = 1 / (1 + constructionBonus)
```

`Math.max(1, ...)` prevents zero-length construction.

**Note:** Research durations (`startResearch()` at `state.js:459`) are NOT affected — the construction bonus only applies to buildings.

#### Step 3f: Expansion cost bonus (1 bonus) — DONE

`BONUS_EXPANSION_COST` reduces the resource cost of territory expansion (level-up).

**Implemented:** Added `expansionCost` getter on `State` (`state.js`) that applies the discount to `hq.levelUpCost`. `expandTerritory()` uses `this.expansionCost` instead of `hq.levelUpCost`. The HQ card reads `state.expansionCost` to display the discounted price.

#### Step 3g: Disaster bonuses (3 bonuses) — DEFERRED

`BONUS_FLOOD_IMPACT`, `BONUS_DISEASE_IMPACT`, `BONUS_EARTHQUAKE_IMPACT` require a disaster system that does not exist yet. These bonuses will be consumed when the disaster system is implemented. No changes needed now.

#### Step 3h: Military bonuses (2 bonuses) — DEFERRED

`BONUS_UNIT_DEFENSE`, `BONUS_UNIT_ATTACK` require a combat system that does not exist yet. These bonuses will be consumed when the military system is implemented. No changes needed now.

#### Step 3i: Warning time bonus (1 bonus) — DEFERRED

`BONUS_WARNING_TIME` requires a disaster warning system that does not exist yet. This bonus will be consumed when the disaster system is implemented. No changes needed now.

#### Remaining Implementation

##### Next: Storage + Construction + Expansion (steps 3d + 3e + 3f) — 3 bonuses

| Category | Subcategory  | Bonus                     | Effect                              |
|----------|--------------|---------------------------|-------------------------------------|
| General  | Storage      | `BONUS_STORAGE_CAPACITY`  | +10%/tier all resource stockpile caps |
| General  | Construction | `BONUS_CONSTRUCTION_TIME` | -10%/tier building/upgrade duration |
| General  | Expansion    | `BONUS_EXPANSION_COST`    | -10%/tier HQ type upgrade cost      |

Files: `state.js`, `headquarters_card.vue`

##### Deferred (steps 3g + 3h + 3i) — 6 bonuses

Blocked on unbuilt game systems (disasters, military, warnings).

| Category  | Subcategory | Bonus                      | Blocked on              |
|-----------|-------------|----------------------------|-------------------------|
| Disasters | Floods      | `BONUS_FLOOD_IMPACT`       | Disaster system         |
| Disasters | Health      | `BONUS_DISEASE_IMPACT`     | Disaster system         |
| Disasters | Earthquakes | `BONUS_EARTHQUAKE_IMPACT`  | Disaster system         |
| Military  | Defense     | `BONUS_UNIT_DEFENSE`       | Combat system           |
| Military  | Attack      | `BONUS_UNIT_ATTACK`        | Combat system           |
| Military  | Warning     | `BONUS_WARNING_TIME`       | Disaster warning system |

#### Totals

- **Implemented:** 10 (Habitation + 6 production + worker productivity + 2 consumption)
- **Remaining:** 3 (storage + construction + expansion)
- **Deferred:** 6 (3 disaster + 2 military + 1 warning)

### Phase 4: Polish

- Balancing pass on all research values (costs, bonus percentages)
- Visual polish on research nodes (icons, animations, progress indicators)
- Documentation updates (CLAUDE.md, architecture.md, specs.md)
