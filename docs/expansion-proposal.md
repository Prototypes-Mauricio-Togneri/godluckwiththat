# Game Expansion Proposal: New Buildings, Resources, and Mechanics

## Overview

This proposal fills the gaps in the current game (disasters, military purpose, divine challenges) and adds depth to mid/late-game decision-making. The game has a **finite ending** — no prestige/reset. Victory is achieved by passing through the portal after completing all Divine Challenges.

---

## New Resources (4)

### Herbs (bounded, stockpile-capped)
- **Unlocked at**: Settlement
- **Produced by**: Apothecary (workers forage)
- **Production rate**: 0.2 per worker per second
- **Consumed by**: Disease mitigation (auto-consumed during outbreaks), Tavern upkeep (morale potions), Divine Challenge offerings
- **Stockpile**: Standard Storehouse scaling (500 + 500 x storehouse level)
- **Design intent**: Early-mid resource that creates preparation decisions before disasters hit

### Tools (bounded, stockpile-capped)
- **Unlocked at**: Village
- **Produced by**: Smithy (workers craft from copper/iron)
- **Production rate**: 0.1 per worker per second, consumes 0.1 copper per worker per second
- At Smithy level 5+: switches to 0.05 iron per worker per second for 2x tool quality
- **Effect**: Global worker productivity bonus — +1% per 50 tools in stockpile (caps at +20%)
- **Consumed by**: Exploration expeditions, military unit creation, Divine Challenges
- **Design intent**: Creates a copper/iron sink and a meaningful "invest in efficiency vs. spend on expansion" decision

### Influence (unbounded)
- **Unlocked at**: Town
- **Produced by**: Oracle (converts faith to influence at 0.05 per worker per second, consuming 0.1 faith per worker per second)
- Also earned from Divine Challenge completion and passive colony-size trickle
- **Consumed by**: Late-game research, Sanctum activation, Harbor trade route upgrades, some Divine Challenges
- **Design intent**: A prestige-like currency that gates endgame content without a reset mechanic

### Relics (unbounded, rare)
- **Unlocked at**: Town (first obtainable from Harbor expeditions and Divine Challenges)
- **Not produced by any building** — only obtained as rewards
- **Sources**: Harbor exploration (rare loot), Divine Challenge completion (guaranteed 1 per challenge), special events
- **Effect**: Each relic grants a unique permanent bonus from a relic pool (e.g., +10% faith, -15% food consumption, +1 territory per HQ level)
- **Consumed by**: Sanctum leveling (requires relics to upgrade), final Divine Challenge
- **Design intent**: The collectible endgame driver — rare, exciting, each one meaningfully changes gameplay

---

## New Buildings (8)

### Colony Category

#### Apothecary (Settlement)
- Assigns workers to forage for herbs
- Worker capacity: level x 5
- Passive bonus: reduces disease disaster severity by 10% per level
- Level-up cost: base (50 wood, 25 stone) x 1.5^level
- **Role**: Health infrastructure — prepares colony for disasters, produces herbs for Tavern and challenges

#### Tavern (Town)
- Passive building (no workers assigned)
- Upkeep: consumes 0.5 food + 0.1 herbs + 0.05 gold per second per level
- Grants morale bonus: +0.05 per level (see Morale System)
- Level-up cost: base (100 wood, 50 stone, 30 copper) x 1.5^level
- **Role**: Quality of life — boosts all worker productivity through morale, but has significant ongoing resource drain

### Economy Category

#### Smithy (Village)
- Assigns workers to craft tools from copper (or iron at higher levels)
- Worker capacity: level x 5
- Production: 0.1 tools per worker per second
- Consumption: 0.1 copper per worker per second (level 5+: 0.05 iron for 2x quality tools)
- Level-up cost: base (70 wood, 35 stone) x 1.5^level
- **Role**: Resource conversion — transforms raw metals into productivity boosters

#### Harbor (Town)
- Enables Exploration expeditions (see Exploration System)
- Expedition slots: 1 + floor(level / 2)
- Expedition speed: base time reduced by 5% per level
- Workers sent on expeditions are committed (unavailable, like Temple prayer)
- Level-up cost: base (120 wood, 60 stone, 30 copper) x 1.5^level
- **Role**: Thematically perfect (shipwreck survivors rebuild maritime capability), opens exploration gameplay loop

### Religion Category

#### Oracle (Town)
- Assigns workers to convert faith into influence
- Worker capacity: level x 5
- Production: 0.05 influence per worker per second
- Consumption: 0.1 faith per worker per second
- Bonus: At level 3+ reveals next Divine Challenge requirements
- Level-up cost: base (100 wood, 50 stone, 25 copper) x 1.5^level
- **Role**: Bridges religion system to endgame, provides challenge intel

#### Sanctum (City)
- Endgame building. Max 5 levels. No workers — leveling IS the mechanic
- Each level: permanent colony-wide buff (+5% all production, +5% all storage, etc.)
- Level-up cost: exceptionally high, requires relics (level 1: 500 wood, 300 stone, 200 copper, 100 iron, 50 gold, 2 relics; further levels TBD with steep scaling)
- **Level 5 Sanctum = prerequisite for the final Divine Challenge (win condition)**
- **Role**: The endgame religion capstone — massive investment, massive payoff, required for victory

### Military Category

#### Watchtower (Settlement)
- Passive building (no workers)
- Provides advance warning of disasters and enemy raids
- Warning time: 30 + (15 x level) seconds before event hits
- Stacks with Warning research tree bonus
- Level-up cost: base (45 wood, 20 stone) x 1.5^level
- **Role**: Pure intel/defense — distinct from Tower (offensive), enables preparation for disasters

#### War Camp (City)
- Enables military Raids (send units to plunder)
- Raid slots: 1 + floor(level / 3)
- Raid speed: base time reduced by 5% per level
- Raid success rate: 60% base + 3% per level + military research bonuses
- Returns: food, wood, stone, gold (scaled to units sent and raid tier)
- Risk: units can be lost on failed raids
- Level-up cost: base (150 wood, 75 stone, 40 iron) x 1.5^level
- **Role**: Gives military buildings a purpose — unit creation now has a payoff loop

---

## New Mechanics (4)

### 1. Disaster System

Builds on the existing (but unimplemented) Disaster research tree (Floods, Health, Earthquakes).

**Timing and Frequency**
- First disaster possible after Year 3 (gives player time to establish)
- Check every season transition: 15% base chance, +5% per year after Year 3 (caps at 60%)
- Only one disaster active at a time
- Watchtower provides advance warning (event appears in Events column with countdown timer)

**Disaster Types**

| Type | Season Bias | Effect | Duration |
|------|-------------|--------|----------|
| **Floods** | 50% warm / 20% cold | Destroys 10-30% of food + wood stockpile, reduces Farm output by 50% | 60 seconds |
| **Disease** | 30% either season | 20-40% of workers become sick (produce nothing, still consume upkeep) | 120 seconds (halved with Apothecary + herbs) |
| **Earthquakes** | 20% warm / 50% cold | Random building loses 1 level (min 1), territory reduced by 10% | 60 seconds |

**Severity Scaling**
- Base severity = 1.0 + (year - 3) x 0.1 (caps at 2.0 at Year 13)
- Research: -10% impact per tier (from existing disaster research trees)
- Apothecary: -10% disease severity per level (specific to disease)
- Herbs: auto-consumed during disease to cure workers faster
- Watchtower: doesn't reduce severity, but enables preparation time

### 2. Exploration System (via Harbor)

**Expedition Types**

| Type | Duration | Workers | Resource Cost | Worker Loss Risk |
|------|----------|---------|---------------|-----------------|
| Scout | 120s | 3 | 50 food, 20 wood | 5% |
| Voyage | 300s | 8 | 150 food, 80 wood, 30 tools | 15% |
| Expedition | 600s | 15 | 300 food, 150 wood, 80 tools, 20 gold | 25% |

**Loot Tables** (rolled on completion)

| Type | Resources | Relic Chance | Event Chance |
|------|-----------|-------------|--------------|
| Scout | 50-150 food/wood/stone | 5% | — |
| Voyage | 100-400 mixed | 15% | 10% |
| Expedition | 300-800 mixed | 35% | 25% |

**Exploration Events**
- Found survivors: +3-5 free workers (no recruitment cost)
- Pirate encounter: lose some resources but gain map intel
- Ancient ruins: guaranteed relic
- Trade route: permanent +5% Market price for one resource
- Storm: lose extra workers, fewer resources returned

**Worker Commitment**: Workers on expedition are unavailable until completion (same pattern as Temple commitment). UI shows expedition progress bar and ETA.

### 3. Divine Challenges

The core narrative driver that ties everything together. The gods test the colony's worthiness to pass through the portal.

**Structure**
- 10 sequential challenges (must complete #N before #N+1 unlocks)
- Each has: narrative text, 1-3 requirements, reward, optional time limit
- Reward: 1 guaranteed relic + influence + unique permanent bonus
- Some timed challenges: failure triggers a disaster + 50% faith loss, re-attempt after 1 year cooldown

**Challenge Progression**

| # | Name | Requirements | Reward Bonus |
|---|------|-------------|-------------|
| 1 | Trial of Devotion | 500 faith accumulated | — |
| 2 | Offering of Growth | Sacrifice 300 food + 200 wood | +5% food production |
| 3 | Pillar of Stone | Monument level 3 + 500 stone | +5% building speed |
| 4 | Test of Knowledge | 5 researches completed + 200 knowledge | +5% research speed |
| 5 | Forge of Will | 100 tools + Smithy level 3 | +10% tool efficiency |
| 6 | Voyage of Faith | 3 expeditions completed + 1000 faith | Harbor speed bonus |
| 7 | Army of the Devoted | 50 military units + Barracks level 4 | +10% military strength |
| 8 | Prosperity's Price | Sacrifice 500 gold + 300 iron + 200 copper | +10% all production |
| 9 | Resilience | Survive 3 disasters + Apothecary level 4 | Disaster immunity 300s |
| 10 | The Final Passage | Sanctum level 5 + 5000 faith + 10 relics + all resource sacrifice | **VICTORY** |

**Oracle Integration**: Oracle level 3+ shows next challenge requirements before activation. Level 5 shows exact numbers.

### 4. Morale System

A global multiplier affecting all worker production rates (not upkeep consumption).

**Range**: 0.5x (Miserable) to 1.5x (Euphoric). Default: 1.0x (Content).

**Positive Factors**

| Factor | Bonus | Condition |
|--------|-------|-----------|
| Tavern | +0.05 per level | Tavern built and supplied |
| Food surplus | +0.1 | Net food production > 0 |
| Challenge completed | +0.05 per completed | Permanent, stacks |
| Low idle ratio | +0.05 | Less than 10% workers idle |
| Relic collection | +0.02 per relic | Permanent, stacks |

**Negative Factors**

| Factor | Penalty | Duration |
|--------|---------|----------|
| Disaster struck | -0.2 | 60 seconds after disaster |
| Food shortage | -0.3 | While food = 0 |
| Failed challenge | -0.15 | Until next challenge completed |
| Overcrowding | -0.1 | While territory > 90% capacity |
| Worker death | -0.1 | 120 seconds after workers lost |

**Display**: Morale indicator in game header (icon + percentage), tooltip breaks down all active factors.

---

## Progression Integration

### Updated Building Unlock Table

| Tier | Existing (unlocked here) | New Buildings |
|------|--------------------------|---------------|
| Camp | HQ, House, Altar, Farm, Woodcutter | — |
| Settlement | Storehouse, Shrine, Quarry, Barracks | **Watchtower**, **Apothecary** |
| Village | Academy, Temple, Copper Mine, Archery | **Smithy** |
| Town | Monument, Iron Mine, Stable, Wall | **Tavern**, **Harbor**, **Oracle** |
| City | Market, Gold Mine, Workshop, Tower | **Sanctum**, **War Camp** |

### Updated Resource Unlock Table

| Tier | Existing Resources | New Resources |
|------|-------------------|---------------|
| Camp | Food, Wood, Faith | — |
| Settlement | +Stone, Knowledge | **+Herbs** |
| Village | +Copper | **+Tools** |
| Town | +Iron | **+Influence**, **+Relics** (from expeditions) |
| City | +Gold | — |

---

## Win Condition

1. Progress through all 5 colony tiers (Camp through City)
2. Build and level the Sanctum to level 5 (requires relics and massive resources)
3. Complete all 10 Divine Challenges (collecting relics along the way)
4. Final Challenge: sacrifice massive resources + faith + all relics at Sanctum level 5
5. **Pass through the portal — Victory screen with game stats (time played, buildings built, disasters survived, etc.)**

---

## Suggested Implementation Order

| Phase | Content | Rationale |
|-------|---------|-----------|
| 1 | Herbs + Apothecary + Watchtower + Disaster System | Smallest scope, builds on existing research tree, adds urgency |
| 2 | Tools + Smithy + Morale System + Tavern | Resource conversion loop, new decision layer |
| 3 | Harbor + Exploration System + Relics | New gameplay loop, relic collection begins |
| 4 | Influence + Oracle + Sanctum + Divine Challenges | Narrative progression, win condition |
| 5 | War Camp + Raid System | Military gets a purpose |
