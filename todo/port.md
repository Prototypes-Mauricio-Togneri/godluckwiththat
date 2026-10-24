## Port (not implemented)

- Each level
  - +1% in food production (thought fishing), unaffected by season
  - +1% in wood production, unaffected by season
  - -1% in trading fee (the Market already gives -1% per level above 1)
  - Allows to send raids
    - Enables military raids (send units to plunder)
    - Raid slots: 1 + floor(level / 3)
    - Raid speed: base time reduced by 5% per level
    - Raid success rate: 60% base + 3% per level + military research bonuses
    - Returns: food, wood, stone, gold (scaled to units sent and raid tier)
    - Risk: units can be lost on failed raids
