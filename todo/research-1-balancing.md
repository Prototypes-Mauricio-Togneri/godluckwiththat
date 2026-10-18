# Research balancing

Source: [research.md](./research.md) → TODO, item 1 ("Balancing pass on all research values (costs, bonus percentages)").

## Goal

"Balanced" here means research follows the colony's progression instead of being a flat side purchase. Below, K means knowledge.

1. **Each tier is affordable in the HQ stage that unlocks its resources.** A standard-price tier costs a fixed slice of that stage's reference knowledge output: T1 ≈ 1 min, T2 ≈ 2.5 min, T3 ≈ 4 min, T4 ≈ 5 min, T5 ≈ 6 min.
2. **Duration is visible but secondary.** It should be about a quarter to a half of the time it took to gather the knowledge: T1 ≈ 15–30 s, T5 ≈ 2–3 min.
3. **Price follows value.** Use three price bands with a real spread (cheap ×0.75, standard ×1, premium ×1.5). No chain should do strictly more than another chain at the same price.
4. **Choices matter in a normal run.** At the final challenge (minute ~80), a player who keeps ~20% of workers in the Academy has all T1–T2, most T3, a few T4 and at most one or two T5. That is roughly 35–40 of the 60 researches that have an effect. The full tree is post-win content.
5. **The other two resources stay a side cost.** They should be ~15–30% of a research's total work, always storable in the stage that unlocks them, and never more than ~25% of that stage's HQ upgrade.
6. **Bonus values are whole percents** (see problem 8).

Reference points used for the numbers:

| Anchor | Value | Status |
|---|---|---|
| Run length | 10 challenges, delays + timeouts = 80 min minimum at 1× (`src/data/challenges.json`) | Fact |
| Stage timing | Village ≈ min 10–15, Town ≈ min 25–35 (Monument 5 is needed by min 32.5), City ≈ min 50–60 (500 gold is needed by min 80) | Assumption |
| Workforce | ~50 workers at Village, ~100 at Town, ~150 at City (challenges 9–10 sacrifice 50 and 100 workers) | Assumption |
| Reference Academy (~20% of workers) | Village level 2 = 1 K/s, Town level 4 = 2 K/s, City level 6 = 3 K/s (0.1 K per worker per second, 5 workers per level) | Derived from the two rows above |

## Current state

### Where the numbers live

- Research costs: `RESEARCH_COSTS`, 90 hand-typed `new Cost({...})` entries in `src/js/engine/balancing.js:370-858`
- Bonus values: `RESEARCH_SUBCATEGORY_BONUSES` in `src/js/engine/balancing.js:285-368`. They are summed per completed tier in `Academy.completedBonuses()` (`src/js/models/buildings/academy.js:88-112`) and attached to the tree in `RESEARCH_TREE` (`src/js/engine/constants.js:467-692`)
- Duration: `State.startResearch` uses the raw `cost.toSeconds` (`src/js/engine/state.js:1257`). `Cost.toSeconds` = `floor((Σ amount × 0.1) ^ 0.7)` (`src/js/models/cost.js:93-102`, weights and exponent in `balancing.js:12-22`). Buildings apply a construction multiplier (`src/js/models/buildings/building.js:35`); research does not
- Where bonuses apply:
  - Production multipliers: `state.js:460-469`. Transportation is added to all six bounded resources
  - Consumption: `state.js:386-391`
  - Storage and Habitation: `state.js:125-129`
  - Expansion cost: `state.js:1296-1301`
  - Construction time: `state.js:1309-1317`
  - Military and Disasters bonuses are not read anywhere
- Modal: costs are displayed from `RESEARCH_COSTS` (`src/components/modals/research_modal.vue:6`, `:15-23`). The effect text is `value * 100` with no rounding (`:171`); the accumulated pill rounds (`:97-98`)
- Save data: the Academy stores only completed keys and active `{key, remainingSeconds, duration}` (`academy.js:17-25`, `:118-134`). Costs are never saved

### Economy reference

| Item | Value | Source |
|---|---|---|
| Output per worker per second | food 1, wood 0.5, stone 0.3, copper 0.2, iron 0.1, gold 0.05, knowledge 0.1 | `balancing.js:188-226` |
| Work cost per unit (1 ÷ rate, in worker-seconds) | food 1, wood 2, stone 3.3, copper 5, iron 10, gold 20, **knowledge 10** | derived |
| Worker upkeep | 0.1 food + 0.1 wood per second; recruit 50 food | `balancing.js:242-250` |
| Worker slots / population | 5 per building level / 10 per house level | `balancing.js:235-238` |
| Storage cap | 500 × 1.2^storehouse level: L0 500, L4 1,036, L8 2,149 (knowledge is uncapped) | `balancing.js:255-256` |
| HQ type upgrades | Camp→Settlement 300 wood; Settlement→Village 500 wood + 300 stone; Village→Town 1,000 stone + 500 copper (needs storehouse L4); Town→City 2,000 copper + 1,000 iron (needs storehouse L8) | `balancing.js:167-183` |
| Unlocks | Knowledge, copper, Academy at Village; iron at Town; gold and Market at City | `constants.js:193-238` |
| Academy upgrade | 60 wood + 30 stone × 1.4^level (L9→10: 1,240 wood + 620 stone) | `balancing.js:42-48` |
| Construction | Every building can build at the same time (one level each); timers run from ~4 s to ~1 min | `state.js:1050`, `building.js:35` |

### Research costs today

| Tier | Resources | Knowledge (min–max) | Other two | Duration | Knowledge-gathering time at reference Academy |
|---|---|---|---|---|---|
| T1 | food + wood | 50–80 | 30–50 food, 20–30 wood | 5–6 s | 0.8–1.3 min at 1 K/s |
| T2 | wood + stone | 150–200 | 80–100 wood, 50–60 stone | 10–12 s | 2.5–3.3 min at 1 K/s |
| T3 | stone + copper | 400–500 | 200–250 stone, 80–100 copper | 19–22 s | 4.4–5.6 min at 1.5 K/s |
| T4 | copper + iron | 800–1,000 | 250–300 copper, 80–100 iron | 27–31 s | 6.7–8.3 min at 2 K/s |
| T5 | iron + gold | 1,500–1,800 | 400–450 iron, 120–150 gold | 41–46 s | 8.3–10 min at 3 K/s |

Price bands as typed (T1 price shown):

| Band | Chains | Drift |
|---|---|---|
| Cheap (50 K / 30 / 20) | Transportation, Food production, Wood production | Consistent |
| Middle (60 / 40 / 25) | Construction, Storage, Mining, Food consumption, Wood consumption, Faith, Warning | Construction becomes dear from T3. Storage and Mining become dear from T4. Food consumption, Wood consumption, Faith and Warning become cheap from T4 |
| Dear (80 / 50 / 30) | Expansion, Knowledge, Floods, Health, Earthquakes, Defense, Attack | Consistent |
| Own (70 / 40 / 30) | Habitation | Dearest from T4 (1,000 K, then 1,800 K) |

### Bonuses today

| Chain | Per tier | Full chain | Rough worth at full chain |
|---|---|---|---|
| Transportation | +5% | +25% food, wood, stone, copper, iron, gold | Exactly Food production + Wood production + Mining combined |
| Construction | −10% | −50% build time (multiplied with the Rapid Construction blessing) | Small: timers are short and run in parallel |
| Expansion | −10% | −50% HQ expansion cost, and therefore time | ≈ +1.5 HQ levels ≈ +15 territory (cost grows ×1.6 per level), also lifts the storage ceiling on expansion |
| Storage | +5% | +25% cap | ≈ 1.2 storehouse levels; a storehouse level costs a few hundred wood/stone and 1 territory |
| Habitation | +1 pop per house level | +5 per level (+50% over base 10) | At house L8 ≈ 4 house levels |
| Food / Wood production | +5% | +25% | — |
| Food / Wood consumption | −5% | −25% worker upkeep | — |
| Mining | +5% | +25% stone, copper, iron, gold | Late-game bottleneck resources |
| Knowledge | +5% | +25% knowledge | T1 (80 K) pays back in ~27 min at 1 K/s |
| Faith | +5% | +25% faith | Faith is the challenge currency (500 → 10,000) |
| Defense / Attack / Warning | +10% | +50% | No effect (no combat system) |
| Floods / Health / Earthquakes | −10% | −50% | No effect; tab hidden in the modal |

### Problems found

1. **Time is almost free.** Duration is 5–12% of the knowledge-gathering time. Knowledge is uncapped, so players bank it, and research runs without a concurrency limit. The timer never limits throughput; it only delays a bonus by seconds.
2. **Knowledge is 70–88% of every research's real cost.** Measured in worker-seconds, 1 knowledge costs as much as 1 iron. The other two resources barely matter. T5 needs at most 450 iron and 150 gold, which fits the base 500 storage, so storage never gates research. T4's copper and iron are only 8–15% of the Town→City upgrade.
3. **Bands barely differ and they drift.** Cheap vs dear is 1.6× at T1 but only 1.07× at T5. Seven chains switch band partway through.
4. **Price does not follow value.**
   - Transportation does exactly what Food production + Wood production + Mining do together, yet it is priced like Food production alone (cheapest band).
   - Knowledge, an investment chain, is in the dearest band and pays back too slowly to be worth buying early.
   - Storage is weaker than building a storehouse level.
   - Expansion, the strongest chain, is priced like Floods.
5. **T4/T5 are out of reach before the win.** The 12 chains with an effect need 37,420 K in total. Estimated knowledge by minute 80 is ~7,000–9,000 K, while T1–T3 alone cost 8,320 K.
6. **Military researches are on sale with no effect:** 15 of the 75 visible researches, ~9,550 K. This is already tracked in [military.md](./military.md).
7. **Additive reductions get stronger per tier.** Going from −40% to −50% turns ×1.67 into ×2, so the last Construction or Expansion tier is the most valuable one. Keep chain totals at or below 50%.
8. **Display:** the effect line prints `value * 100` without rounding, so non-whole percents show badly (0.07 → "7.000000000000001%").

## Decisions

### D1 — Hand-typed table or formula

- **A. Keep the hand-typed table and retype the numbers.** No refactor, but 90 entries (~490 lines) remain, drift continues, and every global retune touches ~270 numbers.
- **B. Formula, built in `constants.js` (recommended).**
  - `balancing.js` holds two values: `RESEARCH_TIER_COSTS` (five `Cost`s, one per tier, for a standard chain) and `RESEARCH_SUBCATEGORY_COST_MULTIPLIERS` (18 numbers).
  - `constants.js` builds `RESEARCH_COSTS` from `RESEARCH_TREE`.
  - Gains: ~490 lines become ~40, one knob sets the global pace and one per chain sets its price, and it follows `docs/javascript.md` (numbers in `balancing.js`, derived structures in `constants.js`).
  - Costs: the `RESEARCH_COSTS` import moves in two files, and you lose per-entry exceptions (none are needed). No current test asserts exact research costs (checked), so there is no test churn, and new structural tests become possible.
- **C. Formula built inside `balancing.js` with a small helper and explicit key lists.** Keeps import sites unchanged, but puts a factory function in `balancing.js` against `docs/javascript.md` and duplicates the tree's key lists.

### D2 — Research duration

- **A. Keep raw `toSeconds`.** With the proposed costs that is 4–43 s, on the same scale as buildings, and the timer stays irrelevant.
- **B. Add a `RESEARCH_TIME_MULTIPLIER` constant, starting at 4 (recommended).** One constant and one line in `startResearch`. Gives 16 s–2.9 min and keeps the "duration derived from cost" rule.
- **C. Fixed per-tier duration table (e.g. 30/60/120/180/300 s).** Explicit, but premium chains no longer take longer, it adds another table, and it drops the "derived from cost" rule.
- **D. Limit concurrent researches (e.g. by Academy level).** The only option that makes time a real constraint, but it is a new mechanic that contradicts the documented unlimited parallelism. Separate feature; not now.

### D3 — Should Construction research shorten research time?

- **A. No, keep the current documented behavior (recommended).** Construction stays about buildings, and research time stays predictable.
- **B. Yes, reuse the construction multiplier (including the Rapid Construction blessing).** One line, but Construction then pays twice and docs and tests must change.
- **C. A separate research-speed effect (e.g. on the Knowledge chain).** Needs a new bonus type plus new text in 5 locales. Out of scope.

### D4 — Bonus sizes per chain

- **Transportation:**
  - **A. +3% per tier and premium band (recommended).** Gives 60% of Food production + Wood production + Mining combined for about 60% of their combined price.
  - **B. Keep +5% but price it ×2.5.** It then becomes the most expensive research by far.
  - **C. Keep as is.** It remains the default first pick.
- **Construction (−50% at full chain):**
  - **A. Keep −10% per tier (recommended).** Timers are seconds to ~1 min and all buildings build at once, so −50% is worth less than it sounds.
  - **B. −8% per tier (−40%).**
- **Expansion (−50% at full chain):**
  - **A. −8% per tier (−40% ≈ +11 territory, about one Holy Expansion blessing) and premium band (recommended).**
  - **B. Keep −10% and premium band** (≈ +15 territory).
  - **C. −6% per tier (−30%).** Likely too weak for a premium price.
- **Storage:**
  - **A. +10% per tier, cheap band (recommended).** +50% ≈ 2.2 storehouse levels.
  - **B. Keep +5%.** It stays weaker than building a storehouse level.
- **Knowledge:**
  - **A. +10% per tier, cheap band (recommended).** T1 pays back in ~7.5 min at 1 K/s instead of ~27.
  - **B. Keep +5% and only make it cheap.**
- **Habitation:** keep +1 per house level, premium band. Fractions give odd caps (e.g. 73.5 at house L7).
- **Food / Wood production and consumption, Mining, Faith:** keep 5%.

### D5 — Military and Disasters values

- **A. Leave the bonus values (10%) untouched, price them standard, and revisit when the systems exist (recommended).** Tuning them now is guesswork without combat or disaster numbers.
- **B. Set them to 0 until the systems exist.** The modal would show "+0%", and players still waste knowledge.
- **C. Also hide the Military tab like Disasters** (filter in `RESEARCH_MODAL_TREE`, `constants.js:694`). This stops the wasted spending, but it is the [military.md](./military.md) TODO item and belongs in its own change.

## Proposed numbers

Starting points to tune by playtesting. They assume D1 B, D2 B (×4), D4 A and D5 A.

Tier base costs for a standard chain (×1):

| Tier | Knowledge | Other two | Target knowledge-gathering time |
|---|---|---|---|
| T1 | 60 | 40 food, 30 wood | 1 min at 1 K/s (Village) |
| T2 | 150 | 100 wood, 60 stone | 2.5 min at 1 K/s (Village) |
| T3 | 360 | 200 stone, 80 copper | 4 min at 1.5 K/s (late Village / early Town) |
| T4 | 600 | 200 copper, 80 iron | 5 min at 2 K/s (Town) |
| T5 | 1,100 | 250 iron, 100 gold | 6 min at 3 K/s (City) |

The other two resources are 14–29% of total work. T3 equals 20% of the stone and 16% of the copper of Village→Town. Premium T5 (375 iron, 150 gold) still fits the base 500 storage.

Price bands (game names in brackets where they differ):

| Band | Multiplier | Chains |
|---|---|---|
| Cheap | 0.75 | Food production (Farming), Food consumption (Preservation), Wood production (Lumber), Wood consumption (Warmth), Knowledge, Storage |
| Standard | 1 | Mining, Faith, Construction, Defense, Attack, Warning, Floods, Health, Earthquakes |
| Premium | 1.5 | Transportation, Expansion, Habitation |

Resulting costs (floored by `multiplyFloor`) and durations from the real formula:

| Tier | Cheap | Standard | Premium | Raw `toSeconds` (cheap / std / prem) | ×4 duration |
|---|---|---|---|---|---|
| T1 | 45 K, 30 food, 22 wood | 60 K, 40 food, 30 wood | 90 K, 60 food, 45 wood | 4 / 6 / 7 s | 16 / 24 / 28 s |
| T2 | 112 K, 75 wood, 45 stone | 150 K, 100 wood, 60 stone | 225 K, 150 wood, 90 stone | 9 / 11 / 14 s | 36 / 44 / 56 s |
| T3 | 270 K, 150 stone, 60 copper | 360 K, 200 stone, 80 copper | 540 K, 300 stone, 120 copper | 15 / 18 / 24 s | 60 / 72 / 96 s |
| T4 | 450 K, 150 copper, 60 iron | 600 K, 200 copper, 80 iron | 900 K, 300 copper, 120 iron | 18 / 22 / 30 s | 72 / 88 / 120 s |
| T5 | 825 K, 187 iron, 75 gold | 1,100 K, 250 iron, 100 gold | 1,650 K, 375 iron, 150 gold | 26 / 32 / 43 s | 104 / 128 / 172 s |

Duration ≈ 25–40% of the knowledge-gathering time at every tier and band (Goal 2).

Budget check. The 12 chains with an effect weigh the same as 12 standard chains (6 × 0.75 + 3 × 1 + 3 × 1.5).

| | T1+T2 | T3 | T4 | T5 | Total |
|---|---|---|---|---|---|
| Knowledge needed | 2,517 | 4,320 | 7,200 | 13,200 | 27,237 (today 37,420) |

With ~7,000–9,000 K by minute 80, that buys all T1–T3 (6,837) plus 0–3 T4, or skipped T3s traded for a T5 (Goal 4).

Bonus values:

| Chain | Now (per tier) | Proposed (per tier → full chain) | Band |
|---|---|---|---|
| Transportation | +5% | +3% → +15% | Premium |
| Construction | −10% | −10% → −50% (keep) | Standard |
| Expansion | −10% | −8% → −40% | Premium |
| Storage | +5% | +10% → +50% | Cheap |
| Habitation | +1 | +1 → +5 (keep) | Premium |
| Food / Wood production | +5% | keep | Cheap |
| Food / Wood consumption | −5% | keep | Cheap |
| Mining | +5% | keep | Standard |
| Knowledge | +5% | +10% → +50% | Cheap |
| Faith | +5% | keep | Standard |
| Defense / Attack / Warning | +10% | keep (placeholder) | Standard |
| Floods / Health / Earthquakes | −10% | keep (placeholder) | Standard |

All proposed values print as whole percents (0.03, 0.05, 0.08, 0.10).

## Implementation steps

1. **`src/js/engine/balancing.js` — Research section.**
   - Add `RESEARCH_TIME_MULTIPLIER = 4` with a comment: multiplies `Cost.toSeconds` for research only.
   - Add `RESEARCH_TIER_COSTS`: an array of five `new Cost({...})` from the tier table, with index 0 = T1.
   - Add `RESEARCH_SUBCATEGORY_COST_MULTIPLIERS`: an 18-key map of `RESEARCH_SUBCATEGORY_*` → 0.75 / 1 / 1.5, grouped and commented by band.
   - Update `RESEARCH_SUBCATEGORY_BONUSES` values: Transportation 0.03, Expansion 0.08, Storage 0.10, Knowledge 0.10.
   - Delete the hand-typed `RESEARCH_COSTS` (lines 370-858) and drop the 90 `RESEARCH_*_N` names from the import on line 5 (keep the `RESEARCH_SUBCATEGORY_*` ones).
2. **`src/js/engine/constants.js` — build the costs.**
   - Import the two new values.
   - After `RESEARCH_TREE` (before `RESEARCH_MODAL_TREE`, line 694), export `RESEARCH_COSTS`. For each subcategory and each research index `i`, it is `RESEARCH_TIER_COSTS[i].multiplyFloor(RESEARCH_SUBCATEGORY_COST_MULTIPLIERS[sub.key])`, built as a plain object keyed by research key so the existing lookups keep working.
3. **`src/js/engine/state.js` — use the new costs and duration.**
   - Line 3: remove `RESEARCH_COSTS` from the `balancing.js` import, add `RESEARCH_TIME_MULTIPLIER`, and add `RESEARCH_COSTS` to the `constants.js` import on line 8.
   - In `startResearch` (line 1257), set `const duration = Math.max(1, Math.floor(cost.toSeconds * RESEARCH_TIME_MULTIPLIER))`, the same shape as `building.js:35`. Do not apply the construction multiplier (D3 A).
4. **`src/components/modals/research_modal.vue:5-6` — import only.** Import `RESEARCH_COSTS` from `constants.js` together with `RESEARCH_MODAL_TREE`. There is no visual change.
5. **Tests.**
   - `tests/engine/balancing.test.js`, new describe blocks:
     - `RESEARCH_TIER_COSTS` has 5 `Cost`s with rising knowledge and the expected resource pair per tier (T1 food+wood … T5 iron+gold)
     - `RESEARCH_SUBCATEGORY_COST_MULTIPLIERS` has every `RESEARCH_SUBCATEGORY_*` key with a value > 0
     - `RESEARCH_TIME_MULTIPLIER` ≥ 1
     - every `RESEARCH_SUBCATEGORY_BONUSES` value × 100 is an integer (guards problem 8)
   - `tests/engine/constants.test.js`, new `RESEARCH_COSTS` block:
     - every key in `RESEARCH_TREE` has a `Cost`, and there are no extra keys
     - knowledge rises tier by tier within each chain
     - one spot check (e.g. Food production T1 equals tier 1 × 0.75)
   - `tests/engine/state.test.js` `startResearch` (2238-2345):
     - add "duration is `cost.toSeconds` × `RESEARCH_TIME_MULTIPLIER`" (check the active research's `duration` and the future event's `remainingSeconds`)
     - add "completed Construction research does not shorten research"
     - the existing tests stay valid: cheap T1 (45 K / 30 / 22) fits their 500 / 500 / 500 with storehouse L1
   - Tests whose bonus values stay the same and still pass:
     - `state.test.js:962-1000` (Habitation +1 → cap 11)
     - `state.test.js:4705-4733` (5 Construction tiers → 0.25)
     - `state.test.js:556-575` (Expansion; loose assertion)
     - If D4 changes Habitation or Construction, update those two exact assertions.
   - `tests/models/buildings/academy.test.js` builds its own trees and is unaffected.
   - `docs/testing.md`: update the `balancing.test.js` (line 29) and `constants.test.js` (line 33) rows and the `state.test.js` counts (line 34).
6. **Docs.**
   - `docs/specs.md`:
     - line 307: duration = `toSeconds × RESEARCH_TIME_MULTIPLIER`, and cost = tier base × chain price band
     - lines 311-335: new percentages
     - line 456: the Research definitions entry lists the three new constants and says `RESEARCH_COSTS` is derived in `constants.js`
   - `docs/architecture.md`:
     - line 287: where costs come from, and the duration multiplier
     - line 289: `RESEARCH_TREE` also drives `RESEARCH_COSTS`
   - `todo/research.md`: update the Design "Cost" / "Duration" bullets and the category percentages, then move the balancing item from TODO to Done ("first pass; tune by playtest").
   - `AGENTS.md`: no change. i18n: no change, because effect strings take the value as a parameter.
7. **Playtest.** There is no debug or cheat menu and no save editor. The tools are:
   - `createInitialColony()` (`constants.js:884-886`) switches between `createInitialColonyBasic()` (real pacing) and `createInitialColonyAdvanced()` (City, 60 workers, 1,000 of each resource, 1,500 K, Academy L1).
   - Game speed 2× / 3× in-game. It scales everything evenly, so pacing ratios hold.
   - The save is plain JSON in localStorage key `savedGame`. Edit resources or `academy.completed` in DevTools, then use Continue.

   Protocol:
   1. On the Basic colony at 3×, note the game minute of reaching Village / Town / City, the Academy level and knowledge per second at each, and which researches are done at challenge 5 and at challenge 10.
   2. Compare with the Goal: T1 within ~2 min of Academy L1, 35–40 effects by minute 80, timers noticeable but not blocking.
   3. Tune in this order: `RESEARCH_TIER_COSTS` (global pace), then a chain's band or bonus (a chain that is always or never picked), then `RESEARCH_TIME_MULTIPLIER`.
   4. Do a quick pass on the Advanced colony: start one T5 per band to confirm durations and that the modal shows +3%, −8% and +10%.

## Verification

```sh
npm run lint:fix
npx vitest run tests/engine/balancing.test.js tests/engine/constants.test.js
npx vitest run tests/engine/state.test.js -t "startResearch|advanceResearch|expansionCost|_constructionDurationMult"
npx vitest run tests/models/buildings/academy.test.js
npm test
npm run build   # research_modal.vue is not unit-tested; the build catches a wrong import
```

## Out of scope / risks

- **Save compatibility:** no migration is needed, because saves store only research keys and active timers.
  - New bonus values apply immediately to old saves, since bonuses are recomputed from keys.
  - Researches already running finish on their old, shorter timer.
- **Military and Disasters:** values stay placeholders. Hiding the Military tab is the [military.md](./military.md) TODO.
- **Other research TODOs:** prerequisite enforcement in `startResearch` and Academy-downgrade behavior are separate items in [research.md](./research.md).
- **Duration not shown before starting:** the modal shows no duration until a research starts. With ×4 timers, a duration line in the cost tooltip may be wanted. That is a UI follow-up and needs the `frontend-design` skill.
- **`createInitialColony()` currently returns the advanced dev colony** (`constants.js:884-886`, changed in commit `5699f11f`), while `docs/architecture.md:133` says it uses Basic. A pacing playtest on it measures nothing, and if shipped every new game starts as a City.
- **The reference points are estimates:** stage timings and reference Academy levels are guesses, so treat every proposed number as a first pass.
- **Gold is soft at City:** the Market turns 200 food into ~133 gold, so T5's gold cost is a light gate.
- **Bonus values must stay whole percents** until the effect text rounds (`research_modal.vue:171`).
