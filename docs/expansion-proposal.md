### Economy Category

#### Harbor (Town)
- Enables Exploration expeditions (see Exploration System)
- Expedition slots: 1 + floor(level / 2)
- Expedition speed: base time reduced by 5% per level
- Workers sent on expeditions are committed (unavailable, like Temple prayer)
- Level-up cost: base (120 wood, 60 stone, 30 copper) x 1.5^level
- **Role**: Thematically perfect (shipwreck survivors rebuild maritime capability), opens exploration gameplay loop

### Military Category

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