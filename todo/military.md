# Military

* As you develop your colony, you will expand your territory. This will attract the natives on the island. For that you will have to develop an army to defend your colony from their raids.
* Attack waves come one after the other from
  - Bandits: their attacks are not announced
  - Other tribes: their attacks are informed in advance
* Their power increases over time
* Launch a preventive attack and destroy the enemy and loot resources
* Must balance the units for defenses and attacks and avoid having only one type of units. Encourage the trident of units
* Losing a raid attack
  - Losing resources
  - Losing workers
  - Some buildings' level are downgraded
* Military units consume resources to survive but they don’t produce any
* Strengths
  - Infantry > Cavalry
  - Archers > Infantry
  - Cavalry > Archers
  - Siege > Buildings
* Heroes
  - Special units that are much stronger than the rest and have unique abilities
* Defenses
  - Wall
  - Tower
* Ideas
  - Send expeditions to expand the territory. The more soldiers and the longer you send them, the more slots you get
  - Negotiate with enemies (give them goods) to delay it or cancel the attack
  - Pay a tribute to enemies to make them allies to trade
  - Traps
    - Cheap but they only work once
    - Risk/reward: They can kill a very weak or very strong unit

## Current state

* Barracks, Archery, Stable, Workshop, Wall and Tower can be built (they cost resources and take territory) but have no effect yet
* Defense, Attack and Warning researches can be bought, but their bonuses are not used yet
* No units, raids, combat, heroes, traps or Port
* `SND_UNDER_ATTACK` is loaded but never played

## Port (not implemented)
* Each level
  - +1% in food production (thought fishing), unaffected by season
  - +1% in wood production, unaffected by season
  - -1% in trading fee (the Market already gives -1% per level)
  - Allows to send raids
    - Enables military raids (send units to plunder)
    - Raid slots: 1 + floor(level / 3)
    - Raid speed: base time reduced by 5% per level
    - Raid success rate: 60% base + 3% per level + military research bonuses
    - Returns: food, wood, stone, gold (scaled to units sent and raid tier)
    - Risk: units can be lost on failed raids

## TODO
- Open military window
- See military
- Create units
- See upcoming attacks
- Make military research bonuses take effect (`BONUS_UNIT_DEFENSE`, `BONUS_UNIT_ATTACK`, `BONUS_WARNING_TIME`)
- Give the existing military buildings an effect
- Until then, hide or mark as "coming soon" the military buildings and researches, so players don't spend resources on them for nothing

* **Recover relic** challenge type: send military away to recover a relic. Skipped for now (military not implemented)

## Blessings (not yet implemented)

* `CELESTIAL_FORTIFICATION`: Buildings more resilient to attacks and disasters
* `TEMPORARY_PEACE`: No enemy raids
* `SANCTIFIED_HERO`: Gives a special military unit