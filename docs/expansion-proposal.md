### 1. Divine Challenges

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

### 2. Disaster System

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