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

| Category  | Subcategories                                                    | Bonus Effects                                                                                                                       |
|-----------|------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| General   | Transportation, Construction, Expansion, Storage, Habitation     | +5%/tier worker productivity, -10%/tier construction time, -10%/tier expansion cost, +10%/tier storage capacity, +1/tier population  |
| Resources | Food prod., Food cons., Wood prod., Wood cons., Mining, Knowledge | +/-5%/tier production/consumption rates                                                                                             |
| Disasters | Floods, Health, Earthquakes                                      | -10%/tier flood/disease/earthquake impact                                                                                           |
| Religion  | Faith                                                            | +5%/tier faith production                                                                                                           |
| Military  | Defense, Attack, Warning                                         | +10%/tier unit defense, +10%/tier unit attack, +10%/tier warning time                                                               |

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

Bonus aggregation is implemented — `completedBonuses()` runs every tick at `game_state.js:55` and returns a `{bonusType: cumulativeValue}` map. Currently only `BONUS_HABITATION` is consumed (passed to `populationCap()` at line 57). All other 17 bonuses are computed but discarded.

#### Current state

The `bonuses` object is already available in `update()`. Each bonus value is a cumulative float (e.g. 3 tiers of Transportation at 0.05/tier → `workerProductivity: 0.15`). Habitation is flat (3 tiers → `habitation: 3`).

#### Step 3a: Production bonuses (6 bonuses)

**Where:** `game_state.js` lines 76-88, the `PRODUCTION_RATES` loop.

**Current code:**
```js
for (const [buildingKey, config] of Object.entries(PRODUCTION_RATES)) {
  const building = buildings[buildingKey]
  if (building.level > 0) {
    if (config.passive) {
      production[config.resource] += building.level * config.rate
    } else if (building.workers > 0) {
      production[config.resource] += building.workers * config.rate
    }
  }
}
```

**Plan:** Create a lookup that maps each `buildingKey` to its production bonus type, then multiply the rate by `(1 + bonus)`.

Add to `balancing.js` alongside `PRODUCTION_RATES`:
```js
export const PRODUCTION_BONUS_MAP = {
  [BUILDING_FARM]:        BONUS_FOOD_PRODUCTION,
  [BUILDING_WOODCUTTER]:  BONUS_WOOD_PRODUCTION,
  [BUILDING_QUARRY]:      BONUS_MINING_PRODUCTION,
  [BUILDING_COPPER_MINE]: BONUS_MINING_PRODUCTION,
  [BUILDING_IRON_MINE]:   BONUS_MINING_PRODUCTION,
  [BUILDING_GOLD_MINE]:   BONUS_MINING_PRODUCTION,
  [BUILDING_ACADEMY]:     BONUS_KNOWLEDGE_PRODUCTION,
  [BUILDING_TEMPLE]:      BONUS_FAITH_PRODUCTION,
  [BUILDING_ALTAR]:       BONUS_FAITH_PRODUCTION,
}
```

Then in the loop, compute the effective rate:
```js
const bonusType = PRODUCTION_BONUS_MAP[buildingKey]
const bonusMult = 1 + (bonusType ? (bonuses[bonusType] ?? 0) : 0)
// ... use config.rate * bonusMult in both passive and worker branches
```

**Bonuses covered:**
- `BONUS_FOOD_PRODUCTION` → Farm (+5%/tier)
- `BONUS_WOOD_PRODUCTION` → Woodcutter (+5%/tier)
- `BONUS_MINING_PRODUCTION` → Quarry, Copper Mine, Iron Mine, Gold Mine (+5%/tier)
- `BONUS_KNOWLEDGE_PRODUCTION` → Academy (+5%/tier)
- `BONUS_FAITH_PRODUCTION` → Temple, Altar (+5%/tier)

**Note:** The seasonal food modifier (line 92) stacks multiplicatively on top — no change needed there.

#### Step 3b: Worker productivity bonus (1 bonus)

**Where:** Same `PRODUCTION_RATES` loop, `game_state.js` lines 76-88.

`BONUS_WORKER_PRODUCTIVITY` increases output for all worker-based (non-passive) buildings. Apply as an additional multiplier in the `else if (building.workers > 0)` branch only:

```js
const workerMult = 1 + (bonuses[BONUS_WORKER_PRODUCTIVITY] ?? 0)
// worker branch becomes:
production[config.resource] += building.workers * config.rate * bonusMult * workerMult
```

This stacks with per-resource bonuses (e.g. a farm with 3 Transportation tiers + 2 Food Production tiers gets `rate * 1.15 * 1.10`).

#### Step 3c: Consumption reduction bonuses (2 bonuses)

**Where:** `game_state.js` lines 107-114 (actual resource deduction) and lines 154-157 (displayed production rates).

**Current code (deduction):**
```js
const foodCost = totalWorkers * WORKER_FOOD_CONSUMPTION * delta
const woodCost = totalWorkers * WORKER_WOOD_CONSUMPTION * (1 + woodSeasonMod) * delta
```

**Current code (display):**
```js
production.food -= resources.workers * WORKER_FOOD_CONSUMPTION
production.wood -= resources.workers * WORKER_WOOD_CONSUMPTION * (1 + woodSeasonMod)
```

**Plan:** Compute effective consumption rates once, use in both places:
```js
const effFoodCons = WORKER_FOOD_CONSUMPTION * (1 / (1 + (bonuses[BONUS_FOOD_CONSUMPTION] ?? 0)))
const effWoodCons = WORKER_WOOD_CONSUMPTION * (1 / (1 + (bonuses[BONUS_WOOD_CONSUMPTION] ?? 0)))
```

Replace `WORKER_FOOD_CONSUMPTION` → `effFoodCons` and `WORKER_WOOD_CONSUMPTION` → `effWoodCons` in all 4 locations above.

**Bonuses covered:**
- `BONUS_FOOD_CONSUMPTION` → reduces food upkeep per worker (+5%/tier reduction)
- `BONUS_WOOD_CONSUMPTION` → reduces wood upkeep per worker (+5%/tier reduction)

#### Step 3d: Storage capacity bonus (1 bonus)

**Where:** `storehouse.js:20-22` (`storageCap()` method) and `game_state.js:58-63` (6 calls to `storageCap()`).

**Current code:**
```js
storageCap() {
  return STOREHOUSE_BASE_CAPACITY + this.level * STOREHOUSE_CAPACITY_PER_LEVEL
}
```

**Plan:** Add a `storageBonus` parameter:
```js
storageCap(storageBonus = 0) {
  return Math.floor((STOREHOUSE_BASE_CAPACITY + this.level * STOREHOUSE_CAPACITY_PER_LEVEL) * (1 + storageBonus))
}
```

In `game_state.js`, extract the bonus and pass to all 6 calls:
```js
const storageBonus = bonuses[BONUS_STORAGE_CAPACITY] ?? 0
stockpile.food = buildings.storehouse.storageCap(storageBonus)
// ... same for wood, stone, copper, iron, gold
```

#### Step 3e: Construction time bonus (1 bonus)

**Where:** `game_state.js` — 3 locations that compute `cost.toSeconds()`:
- Line 273: `levelUpBuilding()` (regular buildings)
- Line 314: `levelUpHeadquarters()` (HQ level up)
- Line 343: `upgradeHeadquarters()` (HQ type upgrade)

**Plan:** At each location, apply the bonus to reduce duration:
```js
const constructionBonus = this.colony.researches.completedBonuses(RESEARCH_TREE)[BONUS_CONSTRUCTION_TIME] ?? 0
const duration = Math.max(1, Math.floor(cost.toSeconds() / (1 + constructionBonus)))
```

`Math.max(1, ...)` prevents zero-length construction. Extract the bonus computation into a helper to avoid repetition.

**Note:** Research durations (`startResearch()` line 451) are NOT affected by construction time bonus — researches have their own timer and the construction bonus only applies to buildings.

#### Step 3f: Expansion cost bonus (1 bonus)

**Where:** `headquarters.js:58-60` (`upgradeCost()`) and `game_state.js:339` (`upgradeHeadquarters()`).

`BONUS_EXPANSION_COST` reduces the resource cost of HQ type upgrades.

**Option A — Apply in GameState (recommended):** Modify `upgradeHeadquarters()` to apply the discount after getting the base cost. This keeps the model pure and avoids threading bonuses through building classes:

```js
upgradeHeadquarters() {
  const hq = buildings.headquarters
  const baseCost = hq.upgradeCost()
  if (!baseCost) return
  const expansionBonus = this.colony.researches.completedBonuses(RESEARCH_TREE)[BONUS_EXPANSION_COST] ?? 0
  const cost = baseCost.multiply(1 / (1 + expansionBonus)).floor()
  if (!resources.canAfford(cost)) return
  resources.deduct(cost)
  // ...
}
```

**UI consideration:** The HQ card (`headquarters_card.vue:66`) calls `hq.upgradeCost()` directly to display costs. To show discounted costs in the UI, either:
- Pass the bonus to `upgradeCost(expansionBonus)`, or
- Compute the discount in the component via an injected `bonuses` ref

Recommend: Add a `discountedUpgradeCost` computed in the component that applies the multiplier, so both display and logic use the same discount.

#### Step 3g: Disaster bonuses (3 bonuses) — DEFERRED

`BONUS_FLOOD_IMPACT`, `BONUS_DISEASE_IMPACT`, `BONUS_EARTHQUAKE_IMPACT` require a disaster system that does not exist yet. These bonuses will be consumed when the disaster system is implemented. No changes needed now.

#### Step 3h: Military bonuses (2 bonuses) — DEFERRED

`BONUS_UNIT_DEFENSE`, `BONUS_UNIT_ATTACK` require a combat system that does not exist yet. These bonuses will be consumed when the military system is implemented. No changes needed now.

#### Step 3i: Warning time bonus (1 bonus) — DEFERRED

`BONUS_WARNING_TIME` requires a disaster warning system that does not exist yet. This bonus will be consumed when the disaster system is implemented. No changes needed now.

#### Implementation Stages

##### Stage 1: Production & Consumption (steps 3a + 3b + 3c) — 9 bonuses

All changes in `game_state.js` `update()` (lines 76-157) + new `PRODUCTION_BONUS_MAP` in `balancing.js`.

| Category  | Subcategory      | Bonus                        | Effect                                         |
|-----------|------------------|------------------------------|------------------------------------------------|
| General   | Transportation   | `BONUS_WORKER_PRODUCTIVITY`  | +5%/tier to all worker-based buildings         |
| Resources | Food Production  | `BONUS_FOOD_PRODUCTION`      | +5%/tier Farm output                           |
| Resources | Food Consumption | `BONUS_FOOD_CONSUMPTION`     | -5%/tier food upkeep per worker                |
| Resources | Wood Production  | `BONUS_WOOD_PRODUCTION`      | +5%/tier Woodcutter output                     |
| Resources | Wood Consumption | `BONUS_WOOD_CONSUMPTION`     | -5%/tier wood upkeep per worker                |
| Resources | Mining           | `BONUS_MINING_PRODUCTION`    | +5%/tier Quarry, Copper/Iron/Gold Mine output  |
| Resources | Knowledge        | `BONUS_KNOWLEDGE_PRODUCTION` | +5%/tier Academy output                        |
| Religion  | Faith            | `BONUS_FAITH_PRODUCTION`     | +5%/tier Temple + Altar output                 |

Files: `balancing.js`, `game_state.js`

##### Stage 2: Storage (step 3d) — 1 bonus

| Category | Subcategory | Bonus                    | Effect                                |
|----------|-------------|--------------------------|---------------------------------------|
| General  | Storage     | `BONUS_STORAGE_CAPACITY` | +10%/tier all resource stockpile caps |

Files: `storehouse.js`, `game_state.js`

##### Stage 3: Construction & Expansion (steps 3e + 3f) — 2 bonuses

| Category | Subcategory  | Bonus                     | Effect                              |
|----------|--------------|---------------------------|-------------------------------------|
| General  | Construction | `BONUS_CONSTRUCTION_TIME` | -10%/tier building/upgrade duration |
| General  | Expansion    | `BONUS_EXPANSION_COST`    | -10%/tier HQ type upgrade cost      |

Files: `game_state.js`, `headquarters_card.vue`

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

- **Already implemented:** 1 (Habitation)
- **Stage 1-3:** 12 bonuses
- **Deferred:** 6 bonuses (3 disaster + 2 military + 1 warning)

### Phase 4: Polish

- Balancing pass on all research values (costs, bonus percentages)
- Visual polish on research nodes (icons, animations, progress indicators)
- Documentation updates (CLAUDE.md, architecture.md, specs.md)
