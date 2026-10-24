# Military — Implementation Plan

Design agreed on 2026-10-24. This file is the full plan; nothing in it is implemented yet. Every numeric value lives in `src/js/engine/balancing.js` and is a starting point for tuning.

## 1. Scope

**In**

- Units: infantry, archers and cavalry, bought instantly and dismissed for no refund
- Unit upkeep in food and wood
- Raids: scheduled, announced ahead of time, then resolved by a deterministic battle
- Wall and Tower effects in battle
- Tribute to delay or cancel a raid
- Military researches take effect: Attack, Defense and Warning
- Raid announcement sound (`SND_UNDER_ATTACK`)
- Military window and raid result window
- Two blessings: Celestial Fortification and Temporary Peace
- A first-raid tutorial popup
- Removal of the Workshop building

**Out (kept in `todo/military.md` for later)**

- Port and sending your own raids
- Traps
- Heroes and the Sanctified Hero blessing
- Siege units, on either side
- The "recover relic" challenge
- Celestial Fortification's "disasters" half, which waits for disasters

**Not needed**

- Save compatibility. Nobody is playing yet, so no migration code is written for the Workshop or the new military state.

## 2. Resolved design decisions

| # | Topic | Decision |
|---|---|---|
| 1 | Scope | Everything in `todo/military.md` except Port, traps, heroes; siege dropped too |
| 2 | Battle model | One-step strength comparison, resolved the moment a raid arrives |
| 3 | Population | Units do **not** use population. Each military building's level caps its unit type |
| 4 | Unit production | Instant purchase |
| 5 | Raid start and pacing | First raid a grace period after reaching Settlement. Raids come more often as the territory cap grows, and get bigger with the territory cap and years |
| 6 | Raid intel | Exact enemy counts per type are shown |
| 7 | Wall and Tower | The Wall absorbs damage before units take losses. The Tower fights as a fixed number of archers per level and never dies |
| 8 | UI | One military window, opened from the military cards and from the raid warning |
| 9 | Defeat | Losses scale with how badly you lost, up to set maximums. Building levels are taken from the punishment list only. Faith and knowledge are never taken |
| 10 | Victory | Nothing gained except survival |
| 11 | Tribute | The raid demands two fixed resource lists, one to delay and one to cancel, each paid in full. Delay can be repeated at a rising price and disappears once it would cost more than cancelling |
| 12 | Result | A window that pauses the game after every raid |
| 13 | Upkeep shortage | Upkeep counts toward the existing shortage penalty. No desertion |
| 14 | Hero blessing | Dropped |
| 15 | Randomness | Battles are deterministic. Enemy mix, tribute mix and which buildings lose levels are random |
| 16 | Old saves | Not supported |
| 17 | Tutorial | Fifth tutorial popup on the first raid announcement |
| 18 | Army on defeat | The whole army is lost |
| 19 | Assumptions kept | 5 units per building level; costs rise by tier; raids only bring unit types the player can already train |

## 3. Game rules

### 3.1 Units

| Unit | Trained at | Unlocked at | Beats |
|---|---|---|---|
| Infantry | Barracks | Settlement | Cavalry |
| Archer | Archery | Village | Infantry |
| Cavalry | Stable | Town | Archer |

- Cap per type: `building level × MILITARY_UNITS_PER_LEVEL`. An unbuilt building gives a cap of 0, so no separate unlock check is needed.
- **Buy:** deduct the unit's cost and add 1 unit. Ctrl+click buys up to `BULK_WORKER_AMOUNT` (10). The purchase is blocked at the cap or when the colony cannot afford the cost.
- **Dismiss:** remove the units. Nothing is refunded. Ctrl+click dismisses up to 10.
- Military buildings are never downgraded (punishments, raids and manual downgrades all skip them), so caps never shrink and units never exceed the cap.

### 3.2 Upkeep

Every unit consumes `upkeep.food` and `upkeep.wood` per second. Unit upkeep uses the same multipliers as worker upkeep:

- Food upkeep is reduced by Food Consumption research.
- Wood upkeep is reduced by Wood Consumption research and changed by the season modifier.

Army upkeep is added to colony consumption, so the existing shortage penalty and negative-production warnings apply unchanged. The army's share is stored separately (`state.armyConsumption`) so the header tooltip can show it.

### 3.3 Raid lifecycle

There is at most one raid at a time, in one of two phases.

1. **No raid.** While the HQ is still Camp, nothing happens. Once the HQ is Settlement or higher and there is no raid, a raid is created in the **waiting** phase:
   - The first raid ever (`raidCount === 0`) waits `RAID_GRACE_PERIOD`.
   - Later raids wait `max(RAID_INTERVAL_MIN, RAID_INTERVAL_BASE − RAID_INTERVAL_PER_TERRITORY × territoryCap)`.
   - `territoryCap` means the HQ territory cap plus `territoryBonus`.
   - The waiting timer is hidden from the player.
2. **Announcement** (waiting timer reaches 0). The raid switches to the **incoming** phase:
   - The enemy army is generated (see 3.4) and so is the base tribute demand (see 3.7).
   - Countdown: `RAID_WARNING_TIME × (1 + warning research bonus)`.
   - A clickable future event appears under Upcoming with action `'openMilitaryModal'`.
   - `SND_UNDER_ATTACK` plays.
   - The `raidIncoming` tutorial popup is triggered.
3. **Arrival** (incoming timer reaches 0):
   - The battle is resolved (see 3.5) and its effects are applied immediately.
   - A raid report is stored and the game pauses with the result window.
   - The future event is removed and a past event is added: "Raid repelled" or "Raid lost".
   - `raidCount` goes up by 1 and the raid is cleared, so the next one is scheduled.
4. **Temporary Peace active.** Raid timers do not advance in either phase, and no new raid is announced.
5. Raids keep coming after the final challenge is won. Game speed applies, as it does to every other timer.

### 3.4 Enemy army

- Size: `floor(RAID_UNITS_BASE + RAID_UNITS_PER_TERRITORY × territoryCap + RAID_UNITS_PER_YEAR × (year − 1))`.
- Types: only those the player can already train, meaning the type's building is unlocked by the current HQ type (`HQ_BUILDING_UNLOCKS`).
- Split: each allowed type gets a random weight; the count is split by weight using floor, and the remainder goes to one random allowed type.
- Enemy units use the same attack and health as the player's. Research and buildings apply only to the player.

### 3.5 Battle math (deterministic, shared by forecast and resolution)

This is a pure function in `src/js/engine/battle.js`. The forecast in the military window and the real battle both call it, so they always agree.

```
health(type)  = count × UNIT_STATS[type].health × (1 + defenseBonus)   // defenseBonus = 0 for the enemy
unitHealth    = Σ health(type)
share(type)   = health(type) / unitHealth                               // 0 when unitHealth = 0
playerShare(type) = (health(type) + (type = archer ? towerHealth : 0)) / (unitHealth + towerHealth)   // what the enemy counters; the tower's archers count as archers

counterFactor(type, opponent) = 1 + (UNIT_COUNTER_MULTIPLIER − 1) × opponent.share(UNIT_COUNTERS[type])

attack(army, opponent) = Σ count × UNIT_STATS[type].attack × (1 + attackBonus) × counterFactor(type, opponent)
playerAttack += towerLevel × TOWER_ARCHERS_PER_LEVEL × archer.attack × counterFactor(archer, enemy)   // no research bonus
towerHealth   = towerLevel × TOWER_ARCHERS_PER_LEVEL × archer.health                                 // no research bonus
playerHealth  = unitHealth + wallLevel × WALL_HEALTH_PER_LEVEL + towerHealth

power = attack × totalHealth          // Lanchester square law: power grows with the square of army size
ratio = sqrt(playerPower / enemyPower)
```

| Case | Outcome |
|---|---|
| `enemyPower = 0` | Victory with no losses (cannot normally happen) |
| `playerPower = 0`, i.e. no units and no tower | `ratio = 0`, full defeat |
| `ratio > 1` | **Victory**, see below |
| `ratio ≤ 1` | **Defeat**, see below |

**Victory**

```
lossShare     = 1 − sqrt(1 − 1 / ratio²)
healthLost    = lossShare × playerHealth
absorbed      = min(healthLost, wallHealth)        // the Wall soaks first and is never damaged
unitsLost(t)  = min(count(t), round(count(t) × (healthLost − absorbed) / (unitHealth + towerHealth)))   // the tower's archers share losses but never die
```

**Defeat**

```
severity        = sqrt(1 − ratio²)                 // 0 = near tie, 1 = no defense
units           → all lost
resourceShare   = severity × RAID_DEFEAT_MAX_RESOURCES            // of each stored food/wood/stone/copper/iron/gold
workersLost     = round(severity × RAID_DEFEAT_MAX_WORKERS × workers)
levelsLost      = round(severity × RAID_DEFEAT_MAX_LEVELS)        // 0 while Celestial Fortification is active
```

The function returns `{victory, ratio, playerPower, enemyPower, unitsLost{type}, severity, resourceShare, workersLost, levelsLost}`. The worker and level counts need the colony's current worker total, which is passed in. The engine then applies the losses through the existing punishment helpers (see 5.4).

**Worked examples** (starting values from §4)

| Fight | Result |
|---|---|
| 10 infantry vs 9 infantry, no buildings | ratio 1.11. Victory, 6 infantry lost |
| Same, plus a level 1 wall | ratio 1.28. Victory, 2 infantry lost |
| 10 infantry vs 10 cavalry | ratio 1.29, infantry win |
| 10 archers vs 10 infantry | ratio 1.41, archers win |
| 10 cavalry vs 10 archers | ratio 1.55, cavalry win |
| 0 units vs anything | Defeat at full severity: 30% of each resource, 10% of workers, 3 levels |

### 3.6 Defeat effects

- The army is lost: all units are set to 0.
- Resources: `floor(stock × (1 − resourceShare))` for each bounded resource. Faith and knowledge are untouched.
- Workers: the existing sacrifice rule, idle workers first and then random producers.
- Building levels: the existing random downgrade over the downgradable buildings, with the same eligibility rules and the same handling of a level-1 building under construction.
- All of this is applied at battle time, so the report lists what was actually lost.

### 3.7 Tribute

**Base demand.** It is generated once, at the announcement:

1. Value = `TRIBUTE_VALUE_PER_UNIT × enemy unit count`.
2. Pick between `TRIBUTE_MIN_RESOURCES` and `TRIBUTE_MAX_RESOURCES` distinct resources at random. They are chosen from the bounded resources currently unlocked in the header (`HQ_RESOURCE_UNLOCKS`): food, wood, stone, copper, iron, gold.
3. Split the value evenly across them. Each amount is `ceil(share / TRIBUTE_RESOURCE_VALUES[resource])`, rounded up to a multiple of `TRIBUTE_ROUNDING`.

**Delay**

- Price: `base × TRIBUTE_DELAY_GROWTH ^ delaysPaid`.
- It is offered only while `TRIBUTE_DELAY_GROWTH ^ delaysPaid ≤ TRIBUTE_CANCEL_MULTIPLIER`. With 1.5 and 3, that allows 3 delays.
- Paying adds `TRIBUTE_DELAY_SECONDS` to the countdown and increments `delaysPaid`.

**Cancel**

- Price: `base × TRIBUTE_CANCEL_MULTIPLIER`.
- Paying removes the raid, adds a "Raid called off" past event, increments `raidCount` and lets the next raid be scheduled normally.

Both prices must be paid in full and are blocked if the colony cannot afford them.

### 3.8 Research

| Research | Effect |
|---|---|
| Attack (`BONUS_UNIT_ATTACK`) | +10% unit attack per tier. Not the Tower |
| Defense (`BONUS_UNIT_DEFENSE`) | +10% unit health per tier. Not the Wall |
| Warning (`BONUS_WARNING_TIME`) | +10% announcement countdown per tier. Delays already paid are not scaled |

### 3.9 Blessings

| Blessing | Effect | Duration | Offered in |
|---|---|---|---|
| Temporary Peace (`temporaryPeace`) | Raid timers freeze; no announcement | 300 s | Challenge 6, replacing Forest Bloom |
| Celestial Fortification (`celestialFortification`) | A lost raid takes no building levels | 300 s | Challenge 8, replacing Celestial Prosperity |

- Both last 300 s or less, so the existing "no stacking" rule still holds (a retry takes at least 330 s).
- Both use the shared blessing image.

### 3.10 Tutorial

- New popup key `raidIncoming`, triggered at the first announcement.
- Adding it to `TUTORIAL_MODALS` makes tutorial completion wait for it. The banner is already empty after the last step, so the player sees no difference.
- Players whose device already completed the tutorial never see it, which is existing behavior.

## 4. Starting balance values (`balancing.js`, new "Military" section)

| Constant | Value |
|---|---|
| `MILITARY_UNITS_PER_LEVEL` | 5 |
| `UNIT_STATS[infantry]` | attack 10, health 30; cost 40 food + 20 wood; upkeep 0.1 food + 0.05 wood/s |
| `UNIT_STATS[archer]` | attack 15, health 20; cost 40 wood + 20 copper; upkeep 0.1 food + 0.1 wood/s |
| `UNIT_STATS[cavalry]` | attack 12, health 30; cost 60 food + 25 iron; upkeep 0.2 food + 0.05 wood/s |
| `UNIT_COUNTER_MULTIPLIER` | 2 |
| `WALL_HEALTH_PER_LEVEL` | 100 |
| `TOWER_ARCHERS_PER_LEVEL` | 3 |
| `RAID_GRACE_PERIOD` | 300 s |
| `RAID_INTERVAL_BASE` / `_PER_TERRITORY` / `_MIN` | 600 s / 4 s / 240 s |
| `RAID_WARNING_TIME` | 120 s |
| `RAID_UNITS_BASE` / `_PER_TERRITORY` / `_PER_YEAR` | 3 / 0.15 / 2 |
| `RAID_DEFEAT_MAX_RESOURCES` / `_WORKERS` / `_LEVELS` | 0.3 / 0.1 / 3 |
| `TRIBUTE_VALUE_PER_UNIT` | 25 |
| `TRIBUTE_RESOURCE_VALUES` | food 1, wood 1, stone 1.5, copper 2, iron 3, gold 5 |
| `TRIBUTE_MIN_RESOURCES` / `_MAX_RESOURCES` | 2 / 3 |
| `TRIBUTE_DELAY_GROWTH` / `TRIBUTE_CANCEL_MULTIPLIER` | 1.5 / 3 |
| `TRIBUTE_DELAY_SECONDS` | 120 s |
| `TRIBUTE_ROUNDING` | 5 |

The stats are set so that every counter wins at equal numbers (see the worked examples). With a ×1.5 counter bonus, or with stronger cavalry, cavalry would beat infantry one-on-one, which breaks the triangle.

## 5. Implementation steps

### Step 1 — Remove the Workshop

**Delete**

- `src/js/models/buildings/workshop.js`
- `src/components/buildings/workshop_card.vue`
- `tests/models/buildings/workshop.test.js`
- `public/img/buildings/military/workshop.jpg`, then run `npm run generate-assets`

**Edit**

- `enums.js`: drop `BUILDING_WORKSHOP`.
- `balancing.js`: remove its `BUILDING_UPGRADES` entry.
- `constants.js`:
  - remove it from the imports, `HQ_BUILDING_UNLOCKS[HQ_TYPE_CITY]`, `BUILDING_CLASS_MAP`, the military column of `BUILDING_GRID`, and the Basic and Advanced colony factories
  - fix the "20 buildings" comments
- `buildings.js`: remove the field, the JSDoc, the `totalLevels` term and the `pendingTerritory` check.
- `game_screen.vue`: remove the import and the `CARD_COMPONENTS` entry.
- All 5 locales: remove `building.workshop` and `buildingHelp.workshop`.
- Tests:
  - `tests/helpers/building_keys.js` (20 → 19)
  - `tests/engine/enums.test.js`
  - `tests/models/buildings.test.js`
  - `tests/models/colony.test.js`
  - `tests/engine/state.test.js`: the building factory, and the key list near line 2530

### Step 2 — Enums, balancing, constants

**`enums.js`**

| Group | Values |
|---|---|
| Units | `UNIT_INFANTRY = 'infantry'`, `UNIT_ARCHER = 'archer'`, `UNIT_CAVALRY = 'cavalry'` |
| Raid phases | `RAID_PHASE_WAITING = 'waiting'`, `RAID_PHASE_INCOMING = 'incoming'` |
| Tribute | `TRIBUTE_DELAY = 'delay'`, `TRIBUTE_CANCEL = 'cancel'` |
| Events | `EVENT_TYPE_RAID_INCOMING = 'raid_incoming'`, `EVENT_TYPE_RAID_RESULT = 'raid_result'` |
| Blessings | `BLESSING_TEMPORARY_PEACE = 'temporaryPeace'`, `BLESSING_CELESTIAL_FORTIFICATION = 'celestialFortification'` |
| Tutorial | `TUTORIAL_MODAL_RAID_INCOMING = 'raidIncoming'` |

**`balancing.js`**: all values in §4.

**`constants.js`**

- `UNIT_TYPES`: an ordered array.
- `UNIT_BUILDINGS`: unit to building key.
- `UNIT_COUNTERS`: unit to the unit it beats.
- `TUTORIAL_MODALS[raidIncoming]`.

### Step 3 — Battle math (`src/js/engine/battle.js`, new)

- Pure, exported functions: `armyHealth`, `armyAttack`, `resolveBattle(defender, attacker)`.
- `defender = {units, wallLevel, towerLevel, attackBonus, defenseBonus, workers}`
- `attacker = {units}`
- Implements §3.5 exactly. No colony access, no randomness.

### Step 4 — Models

**`src/js/models/raid.js` (new, `Raid`)**

- Fields: `phase`, `remainingSeconds`, `enemy {infantry, archer, cavalry}`, `demand` (a `Cost`), `delaysPaid`.
- Getters: `enemyCount`, `delayCost`, `cancelCost`, `canDelay`.
- Methods: `advance(delta)` (clamps at 0, returns `true` when it reaches 0), `toJSON`, `static fromJSON`.

**`src/js/models/military.js` (new, `Military`)**

- Fields: `units {infantry, archer, cavalry}`, `raid` (`Raid|null`), `raidCount`.
- Getter: `totalUnits`.
- Methods: `toJSON`, `static fromJSON`, with defaults for missing fields as the other models have.

**`src/js/models/raid_report.js` (new, `RaidReport`)**

- Fields:
  - `victory`
  - `army` (units before the battle)
  - `enemy`
  - `unitsLost`
  - `resourcesLost` (resource → amount)
  - `workersLost`
  - `buildingsLost` (array of building keys, one per level)
- Methods: `toJSON`, `static fromJSON`.

**`Colony`**: add `military` to the constructor, `fromJSON` and `toJSON`. Add `new Military()` to `createInitialColonyBasic` and `createInitialColonyAdvanced`.

**Buildings**

- Barracks, Archery and Stable: getter `unitCap = level × MILITARY_UNITS_PER_LEVEL`.
- Wall: getter `absorb = level × WALL_HEALTH_PER_LEVEL`.
- Tower: getter `archers = level × TOWER_ARCHERS_PER_LEVEL`.
- Update their JSDoc. The current text says "queue capacity and training speed", which is now wrong.

### Step 5 — Engine (`src/js/engine/state.js`)

**5.1 Fields**

- `this.armyConsumption = {food: 0, wood: 0}`
- `this.raidReport = null`, with a comment explaining it is non-null while the result window shows

**5.2 Upkeep**

- `_computeConsumptionRates(bonuses, seasonMultipliers, workerCount, units)`:
  - adds `Σ units × UNIT_STATS.upkeep` using the same food and wood multipliers
  - returns `{rates, multipliers, armyRates}`
  - the "no workers" early return must also account for units
- `update()` stores `armyConsumption`.
- Update the JSDoc table.

**5.3 Player actions**

- `buyUnits(type, count)`: loops while below the cap and the colony can afford it, deducts, increments, then calls `update(0)`. Returns the number bought.
- `dismissUnits(type, count)`: clamps to the units owned, then calls `update(0)`.
- `payTribute(kind)`:
  - requires an incoming raid
  - for a delay, also requires `canDelay`
  - checks the colony can afford it, deducts, then applies §3.7
  - for a delay, re-syncs the event (see 5.6)
  - for a cancel, dismisses the event and adds a past event
  - then calls `update(0)`
- `acknowledgeRaid()`: clears `raidReport`, sets `paused = Boolean(tutorial.activeModal || challengeModal)`, then calls `update(0)`.

**5.4 Punishment helper refactor (no behavior change)**

Split `_applyPunishment` into helpers that report what they removed:

- `_removeResourceShare(fraction)` returns the amount lost per resource.
- `_sacrificeWorkers(count)` returns the number removed.
- `_downgradeRandomBuildings(count)` returns the downgraded keys.

`_applyPunishment` calls these; its existing tests must pass unchanged.

**5.5 Raid step**

- `advanceRaids(delta)` implements §3.3. It returns early when `paused`.
- Helpers:
  - `_raidInterval` (getter)
  - `_raidWarningTime` (getter)
  - `_generateRaidArmy()`
  - `_generateTributeDemand(enemyCount)`
  - `_announceRaid()`
  - `_resolveRaid()`
- `_resolveRaid()`:
  1. builds the defender from the colony, research and buildings
  2. calls `resolveBattle`
  3. applies the losses (§3.6) and builds the `RaidReport`
  4. adds the past event and plays a sound (`SND_NOTIFICATION_ALERT` on victory, `SND_NOTIFICATION_DISASTER` on defeat)
  5. sets `paused = true` and calls `update(0)`
- `_raidForecast` (getter) returns the `resolveBattle` result for the current incoming raid, for the UI.

**5.6 Event sync**

- Every non-paused step lowers future events' countdowns by the elapsed time. Raid countdowns can freeze (Temporary Peace) or jump (delay), so the raid event follows its own timer instead.
- Add `Events.setFutureRemaining(type, seconds)`: updates the event and re-inserts it in sorted order, only when the value changed.
- `advanceRaids` calls it on every step, including while Temporary Peace is active.
- Order in `advanceProgress` (`game_screen.vue`): season → construction → research → challenges → events → **raids**. Running raids last corrects the event after `advanceEvents` has lowered it, and keeps a challenge result and a raid result from landing in the same step.

**5.7 Pausing**

- `dismissTutorialModal`: `paused = Boolean(activeModal || challengeModal || raidReport)`.
- `selectBlessing` and `acknowledgePunishment` keep their behavior. A raid cannot resolve while a challenge window is open, because `advanceRaids` returns early when paused.

**5.8 Research**

- Attack and Defense bonuses go into the defender passed to `resolveBattle`.
- The Warning bonus goes into `_raidWarningTime`.

**5.9 Blessings**

- `advanceRaids` skips timer advance while Temporary Peace is active.
- `_resolveRaid` forces `levelsLost = 0` while Celestial Fortification is active.

**5.10 Save and load**

- `toJSON`: add `raidReport`.
- `fromJSON`:
  - restores it
  - re-pauses when `challengeModal || tutorial.activeModal || raidReport`
- The raid event text uses only numeric params, so `_relocalizeFutureEvents` needs no new branch.

### Step 6 — Blessings data and UI

- `src/data/challenges.json`:
  - challenge 6: `forestBloom` becomes `{type: "temporaryPeace", timeout: 300}`
  - challenge 8: `celestialProsperity` becomes `{type: "celestialFortification", timeout: 300}`
- `challenge_success_modal.vue`: add a `blessingDescription` case for each new type, with a duration parameter.
- `game_screen.vue`: no change needed in `blessingToUIEntry`, since the new types have no numeric params. The active-blessings list picks them up because `timeout > 0`.
- Locales: `blessing.<type>`, `.description` and `.effect` for both new types.

### Step 7 — UI (load the `frontend-design` skill first)

**7.1 `game_screen.vue`**

- `ui.military`:
  - per unit type: count, cap, cost entries, can-afford flag, upkeep
  - wall absorb and tower archers
  - raid: phase, countdown (incoming only), enemy counts, delay and cancel cost entries, `canDelay`
  - forecast
- `ui.raidReport` and `ui.armyConsumption`.
- `syncMilitary()`: called from `syncUI()` and after military actions. `syncTimers()` refreshes the raid countdown.
- Actions:
  - `buyUnits` and `dismissUnits`: resources, production, military, tutorial
  - `payTribute`: resources, production, military, events
  - `acknowledgeRaid`: `state.acknowledgeRaid(); resumeClocks(); syncUI()`
- `provide('openMilitaryModal')`, a `showMilitaryModal` ref, and `handleEventAction` handling `'openMilitaryModal'`.
- Render `RaidResultModal` when `ui.raidReport` is set.
- Close the military window automatically when a result window appears.
- The pause-menu close watcher must not unpause while `state.raidReport` is set.
- `advanceProgress`: add `state.advanceRaids(delta)` last.
- Header food and wood tooltip: add an "Army" row after "Consuming", shown when `ui.armyConsumption[resource] > 0`.

**7.2 `src/components/modals/military_modal.vue` (new, based on the market window)**

- Header: "?" help (opens `ModalHelpModal`), close X, title.
- Resource summary bar, as in the market window.
- **Army**: one row per unit type.
  - Shows the unit image (the building image), name, `count/cap`, a − dismiss button, a + buy button and cost items (red when short).
  - Ctrl+click works on both buttons.
  - Disabled tooltips explain why: building not built, at cap, not enough resources, nothing to dismiss.
  - Types whose building is not unlocked yet are shown locked.
- **Defenses**: the Wall's absorb amount and the Tower's archer count, or "not built".
- **Incoming raid**:
  - incoming: countdown plus enemy counts per type
  - waiting: "No raid announced", without revealing the timer
- **Forecast** (incoming only), which updates live as units are bought:
  - victory: units lost per type, or "no losses"
  - defeat: "army lost", plus the resource %, workers and levels
  - a strength comparison bar based on `ratio`
- **Tribute** (incoming only):
  - a delay row with cost items, a "+2:00" button and a disabled reason, hidden when `canDelay` is false
  - a cancel row with cost items and a button
- Escape closes the window, and the focus and Escape stacks are used as in the market window.

**7.3 `src/components/modals/raid_result_modal.vue` (new, based on the challenge failure window)**

- A blocking window: no backdrop dismiss, and an empty Escape handler.
- Title: "Raid repelled" or "Raid lost".
- Two columns: your army against the raiders, with counts and losses.
- On defeat: resources lost (amounts), workers lost, and buildings that lost levels (localized names, grouped with ×N).
- One "Continue" button that calls `actions.acknowledgeRaid()`.

**7.4 Cards**

- `barracks_card.vue`, `archery_card.vue`, `stable_card.vue`: a unit count `count/cap` and an open-window button (`.card-modal-btn`, as on the academy card).
- `wall_card.vue`, `tower_card.vue`: the open-window button.
- `base_card.vue`: level-up tooltip gain lines for the military buildings, following the existing lines:
  - +5 units for Barracks, Archery and Stable
  - +100 absorbed for the Wall
  - +3 archers for the Tower

**7.5 Help texts**

- Rewrite `buildingHelp` for Barracks, Archery, Stable, Wall and Tower to describe their real effects.
- Add `modal.militaryHelp.title` and `.body`, covering counters, wall and tower, raids, tribute and upkeep.

### Step 8 — Localization (all 5 locales: en, es, ca, fr, it)

New keys, following the existing flat dot-notation:

- `unit.*` for each type
- `military.*` for the window's sections, buttons, tooltips, forecast and tribute
- `raid.result.*`
- `event.raidIncoming`, `event.raidRepelled`, `event.raidLost`, `event.raidCancelled`
- `blessing.temporaryPeace*` and `blessing.celestialFortification*`
- `tutorial.modal.raidIncoming.title` and `.body`
- the header "Army" label
- the card tooltips
- the level-up gain lines
- `modal.militaryHelp.*`
- the rewritten `buildingHelp.*`

Remove the Workshop keys. `tests/i18n/locale_keys.test.js` checks that all locales match.

### Step 9 — Tests

**New files**

- `tests/engine/battle.test.js`:
  - mirror fights, and each counter winning at equal numbers
  - the Wall absorbing (no losses against a weak raid)
  - the Tower adding attack, with its bonus against infantry
  - Attack and Defense research
  - zero army giving severity 1, and a near tie giving severity near 0
  - loss rounding and caps
  - an empty enemy
- `tests/models/raid.test.js`: delay price growth, `canDelay` false after 3 delays, cancel price, `advance` clamping, serialization.
- `tests/models/military.test.js`: defaults, `totalUnits`, serialization.
- `tests/models/raid_report.test.js`: serialization.

**Existing files**

- Building tests for Barracks, Archery, Stable, Wall and Tower: the new getters.
- `tests/engine/state.test.js`, new describe blocks:
  - `buyUnits` and `dismissUnits`
  - consumption with an army
  - `advanceRaids`:
    - no raids at Camp, grace period, interval scaling with territory
    - announcement: event, sound and popup
    - warning research
    - enemy types limited to unlocked ones
    - Temporary Peace freezing the timers
    - event countdown kept in sync and sorted
  - `_resolveRaid`:
    - victory and defeat effects
    - Celestial Fortification
    - pause and report
    - past event, `raidCount`
  - `payTribute`: delay, repeated growth, delay hidden past the cancel price, cancel, unaffordable
  - `acknowledgeRaid`: unpause rules with a tutorial or challenge window open
  - the punishment helpers' return values
  - serialization of military and `raidReport`, and re-pause on load
- `tests/models/events/events.test.js`: `setFutureRemaining`.
- `tests/models/colony.test.js` and `tests/models/serialization.test.js`: Military, Raid and RaidReport robustness.
- `tests/engine/constants.test.js`: the unit maps; the new blessing types from `challenges.json`.
- `tests/engine/balancing.test.js`: sanity checks on the new constants.
- `tests/helpers/factories.js`: `createMilitary`, `createRaid`.
- Random parts (enemy split, tribute mix) are tested with `vi.spyOn(Math, 'random')`.

### Step 10 — Docs

| File | Changes |
|---|---|
| `docs/specs.md` | Drop the "planned" markers for military. Colony unlocks without the Workshop. Resource consumers. Military buildings section. A new **Military** section with units, upkeep, raids, battle, defeat, tribute and the window. Military research bonuses active. Raid events. The two new blessings. The Difficulties section. Balancing list |
| `docs/architecture.md` | 19 buildings. The military and raid result windows. The Military, Raid and RaidReport models. The new `State` fields and actions. The raid step in the tick system. Raid events and `setFutureRemaining`. The header Army row. provide/inject. The cards |
| `docs/testing.md` | New test files and new describe blocks |
| `todo/military.md` | Reduce to what is left: Port, traps, heroes, Sanctified Hero, siege, relic challenge, the disasters half of Celestial Fortification |
| `todo/todo.md` | Adjust the military line |

`AGENTS.md` should need no change; check it. `src/assets/changelog.md` is not touched, since release notes are written at release time.

## 6. Verification

1. `npm run lint:fix`, then fix what remains.
2. Targeted runs while building: `npx vitest run tests/engine/battle.test.js`, then the model files, then `tests/engine/state.test.js`.
3. The full `npm test` once at the end, as `AGENTS.md` requires.
4. `npm run build`.
5. The `delta-review` skill on the changed files.
6. A browser check. In dev the game auto-starts from the advanced colony (City), which is handy here. Check:
   - buying and dismissing units
   - the forecast updating
   - delay and cancel
   - a raid arriving and the result window pausing the game
   - the header Army row
   - Escape and the pause menu while the result window is open

## 7. Assumptions to confirm during review

- The Attack and Defense researches affect units only, not the Tower or the Wall.
- Unit upkeep uses the worker consumption research and the season modifiers.
- The raid event icon is the wall image, unit icons reuse the Barracks, Archery and Stable images, and the result window uses the wall image.
- A "raid repelled / lost / called off" entry is added to the event history as well as the result window, as `docs/specs.md` already plans for raid outcomes.
- Losses are applied when the battle happens, not when the window is closed, unlike challenge punishments.

## 8. Noticed, not part of this work

- `createInitialColony()` in `constants.js` returns the advanced test colony (City, many workers), but `docs/architecture.md` says new games start from the basic colony. If this is not intentional, every new game starts late-game.
