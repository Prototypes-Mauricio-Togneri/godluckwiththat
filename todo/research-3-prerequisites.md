# Research prerequisites

Source: [research.md](./research.md) → TODO, item 3: "Enforce prerequisites in `startResearch()` — today only the research modal prevents skipping a tier".

## Goal

The game rules themselves refuse to start tier N of a research chain until tier N-1 is completed. Today only the research window stops it, so anything that calls the start action directly (a future button, a debug helper, a bug in the window) can skip tiers. What the player sees stays the same.

## Current state

**What the start action checks** — `State.startResearch(key)` (`src/js/engine/state.js:1244-1271`) looks up `RESEARCH_COSTS[key]` and returns early (line 1253) when `!academy.canResearch(key) || !cost || !resources.canAfford(cost)`. Otherwise it deducts the cost, calls `academy.start(key, duration)`, adds a future event (`EVENT_TYPE_RESEARCH_COMPLETE`) and calls `this.update(0)`. A rejected start is silent (no event, no sound).

**What the Academy checks** — `Academy.canResearch(key)` (`src/js/models/buildings/academy.js:55-62`) returns `this.level >= 1 && !this.isActive(key) && !this.isCompleted(key)`. No tier check. `academy.start()` (69-71) has no guard of its own; `State` is the guard. `startResearch` is the only caller of `canResearch`.

**Where the tier rule lives today: the research window only** — `src/components/modals/research_modal.vue`:
- `nodeStatusMap` (41-58) walks each chain by index and picks the first match, in this order: `completed` (key in `ui.academy.completed`) → `active` (key in `ui.academy.activeKeys`) → `locked` (`idx > 0 && !ui.academy.completed.has(sub.researches[idx - 1])`, line 50) → `available`.
- `handleNodeClick` (72-78) calls `actions.startResearch(key)` only for `available` and affordable nodes.
- The window does **not** call `Academy.canResearch`. It reads `ui.academy`, a plain snapshot of Sets rebuilt by `syncAcademy()` (`src/components/screens/game_screen.vue:788-805`). The action wrapper is at 966-969.

**How the tree encodes order** — `RESEARCH_TREE` (`src/js/engine/constants.js:465-691`) is `categories → subcategories → researches[]`; the comment at 465-466 says position N requires N-1. `RESEARCH_MODAL_TREE` (693-694) is the same tree minus Disasters. `Academy.completedBonuses(researchTree)` (academy.js:88-112) takes the tree as an argument instead of importing it.
- No research key → previous key lookup, and no key → subcategory/tier helper, exists anywhere in `src/`.
- Keys are named `<subcategory><tier>` (`'transportation1'`, `'foodProduction2'`, `src/js/engine/enums.js:88+`), but nothing relies on the naming, and declaration order in `enums.js` is not tree order (Storage is declared after Resources, line 157).

**Import loop** — `constants.js` imports every building class at load time (Academy at line 5, used by `BUILDING_CLASS_MAP` at line 245). `headquarters.js:4` imports `HQ_TYPES` back from `constants.js`; that loop works because every test file loads `constants.js` before `headquarters.js`. `academy.js` imports nothing from `constants.js` today.

**Hidden category** — Disasters researches have costs (`src/js/engine/balancing.js:671+`), so `startResearch('floods1')` succeeds in the engine; only the window hides the tab.

**Saves** — `State.fromJSON` → `Colony.fromJSON` → Academy constructor (academy.js:17-25) restores `completed` and `active` as-is, without checks. It never goes through `startResearch`.

**Tests** — `tests/engine/state.test.js:2238-2345` (`startResearch`, 5 tests, all on `'foodProduction1'`) and `tests/models/buildings/academy.test.js:120-150` (`canResearch`, 4 tests, all on `'transportation1'`). None cover tiers. No Vue component tests exist (`docs/testing.md`, "What Is Not Tested").

## Decisions

### 1. Where the rule lives

- **A. Inside `Academy.canResearch`** *(recommended)* — the Academy's "can this start?" answer becomes complete, `startResearch` keeps a single guard, and any future caller gets the rule for free. Cost: the 4 existing `canResearch` tests change (see Decision 3).
- **B. Separate check in `State.startResearch` only** — no model change. Cost: `canResearch` keeps saying "yes" for a skipped tier, so its name lies and the next caller can bypass the rule.

Neither option makes the window share code: it reads a snapshot, not the Academy (see Decision 4).

### 2. How to find the previous tier

- **A. Precomputed `RESEARCH_PREREQUISITES` map in `constants.js`** *(recommended)* — built once from `RESEARCH_TREE` (`{transportation2: 'transportation1', ...}`, tier 1 has no entry). Same pattern as `BUILDING_IMAGE_MAP` (constants.js:384-390) and `RESEARCH_MODAL_TREE`; `docs/javascript.md` puts derived structural constants in `constants.js`. Cost: one new export and a small test.
- **B. Walk the tree on each call** — pass `RESEARCH_TREE` and search for the key's chain, like `completedBonuses` does. Cost: repeats tree-walking code; speed is irrelevant (runs on click), but the code is longer and harder to test.
- **C. Parse the key suffix** (`transportation3` → `transportation2`) — no new data. Cost: hardcodes a naming convention nothing enforces (the tree comment says position defines order, not names) and breaks on a rename or a 10th tier. Reject.

### 3. How the Academy gets the map

- **A. Pass it as an argument: `canResearch(key, prerequisites)`** *(recommended)* — mirrors `completedBonuses(researchTree)`, adds no import loop, and unit tests can pass a tiny inline map the way the `completedBonuses` tests pass inline trees. Make the parameter required: a `= {}` default would silently skip the check. Cost: the 4 existing `canResearch` tests must pass a map.
- **B. Import it in `academy.js`** — signature and existing tests stay unchanged; `headquarters.js` already does this with `HQ_TYPES`. Cost: adds a `constants.js` ↔ `academy.js` loop, and `academy.test.js` imports `academy.js` before `constants.js` (no current test does that for Headquarters), so `constants.js` would run before `Academy` is defined. Probably harmless under Vitest (most likely leaves the academy entry of `BUILDING_CLASS_MAP` undefined in that one test file), but unverified.

### 4. Switch the window's `locked` check to the shared map?

- **A. Leave the window as is** *(recommended)* — it can't call `canResearch` (snapshot), and its index check reads the same tree order as the new map, so the two can't disagree today. Cost: the "previous tier" rule is written twice (one line each).
- **B. Replace line 50 with a map lookup** — import `RESEARCH_PREREQUISITES`, then `const prerequisite = RESEARCH_PREREQUISITES[key]` and `else if (prerequisite && !ui.academy.completed.has(prerequisite))`. Keep the branch order completed → active → locked → available so completed and active nodes never show as locked. Cost: a Vue edit with no component tests (manual check only); the house rule to use the `frontend-design` skill for UI changes applies even though nothing visual changes.
- **C. Let the engine tell the window** — add a per-key "can start" flag to `ui.academy` in `syncAcademy`. A true single source. Cost: new sync data recomputed on every academy sync, for a rule that is already consistent; over-engineered.

### 5. Also block hidden categories (Disasters) in the engine?

- **A. No, keep it out of scope** *(recommended)* — it's a temporary display decision, not a game rule; no player path reaches the engine without the window; [disasters.md](./disasters.md) already tracks "hide until implemented". Cost: "cannot be started" in `docs/specs.md:305` stays a window-level guarantee.
- **B. Block a derived set of hidden keys in `startResearch`** (keys in `RESEARCH_TREE` but not in `RESEARCH_MODAL_TREE`). Cost: ties display choices to game rules, must be undone when disasters ship, extra tests.
- **C. Add an `enabled` flag per category in `RESEARCH_TREE`**, read by both the window filter and the engine. Cost: changes the tree shape and the window filter; the largest change.

### 6. Existing saves with out-of-order research

Can it happen today? Not through play. The only path to `academy.start()` is `startResearch`; its only caller is the window; the window locks tier N until N-1 is in its completed snapshot; and the completed set never shrinks (no code removes entries), so a stale snapshot can only be stricter, never looser. The dev starting colonies (`createInitialColonyBasic` / `createInitialColonyAdvanced`, constants.js:892+ and 985+) seed no research. Only a hand-edited save could hold such state.

- **A. Leave as is** *(recommended)* — the new rule only gates *starting*. An out-of-order completed tier keeps its bonus, an out-of-order active one finishes normally, and the window already renders such states consistently. Cost: none.
- **B. Clean up on load** — drop completed and active entries whose previous tier isn't completed. Cost: deletes progress the player paid for, needs a refund or a message, and more tests, for a case play can't produce.

## Implementation steps

Assumes the recommended options (1A, 2A, 3A, 4A, 5A, 6A).

1. `src/js/engine/constants.js` — right after `RESEARCH_MODAL_TREE` (line 694), add:

    ```js
    // Research prerequisites — research key → key of the previous tier in its chain (tier 1 keys have no entry).
    // Derived from RESEARCH_TREE order, which stays the single definition of each chain.
    export const RESEARCH_PREREQUISITES = Object.fromEntries(
      RESEARCH_TREE.flatMap(entry => entry.subcategories.flatMap(subcategory => subcategory.researches.slice(1).map((key, index) => [
        key,
        subcategory.researches[index],
      ]))),
    )
    ```

    `slice(1)` shifts indexes down by one, so `researches[index]` is the previous tier.

2. `src/js/models/buildings/academy.js:55-62` — extend `canResearch`:

    ```js
      /**
       * Whether the academy can start a given research.
       * Tier N of a chain requires tier N-1 to be completed (not just active).
       * @param {string} key - Research key
       * @param {Object<string, string>} prerequisites - RESEARCH_PREREQUISITES from constants.js
       * @returns {boolean} Whether the research can be started
       */
      canResearch(key, prerequisites) {
        const prerequisite = prerequisites[key] // Previous tier; undefined for tier 1
        return this.level >= 1 && !this.isActive(key) && !this.isCompleted(key) && (!prerequisite || this.isCompleted(prerequisite))
      }
    ```

3. `src/js/engine/state.js` — add `RESEARCH_PREREQUISITES` to the `constants.js` import on line 8 (alphabetical, before `RESEARCH_TREE`) and change line 1253 to:

    ```js
        if (!academy.canResearch(key, RESEARCH_PREREQUISITES) || !cost || !resources.canAfford(cost)) {
    ```

    Nothing else in `startResearch` changes: a blocked call still returns before any deduction, event or `update(0)`.

4. Tests, then docs (next sections).

## Tests

**`tests/models/buildings/academy.test.js` → `Academy` → `canResearch` (120-150)**

- Declare an inline map at the top of the block, e.g. `const prerequisites = {transportation2: 'transportation1', transportation3: 'transportation2'}`, and pass it in the 4 existing tests. They use `'transportation1'`, which has no entry, so their expectations stay the same.
- Add:
  - `should return false when the previous tier is not completed` — level 1, nothing completed: `canResearch('transportation2', prerequisites)` → `false`.
  - `should return true when the previous tier is completed` — `completed: ['transportation1']` → `true` for `'transportation2'`.
  - `should return false when the previous tier is only active` — after `academy.start('transportation1', 60)` → `false` for `'transportation2'`.
  - `should return false when skipping more than one tier` — `completed: ['transportation1']` → `false` for `'transportation3'`.

**`tests/engine/constants.test.js` → `constants` → new `describe('RESEARCH_PREREQUISITES')`** (import `RESEARCH_PREREQUISITES` and `RESEARCH_TREE`)

- `should map each research to the previous tier in its chain` — loop every subcategory of `RESEARCH_TREE`; for `index >= 1`, `RESEARCH_PREREQUISITES[researches[index]]` `toBe(researches[index - 1])`.
- `should have no entry for tier 1 researches` — `RESEARCH_PREREQUISITES[researches[0]]` `toBeUndefined()` for every subcategory.
- `should have one entry per non-first research` — key count equals total researches minus subcategory count, computed from the tree (don't hardcode 72).

**`tests/engine/state.test.js` → `State` → `startResearch` (2238-2345)** — reuse `createState` with the overrides the existing tests use (`food`/`wood`/`knowledge: 500`, academy level 1, storehouse level 1; the default stone of 200 covers the 50 that `foodProduction2` costs):

- `should not start a tier whose previous tier is not completed` — `startResearch('foodProduction2')` → not active; `knowledge`, `wood` and `stone` equal their values before the call; `events.future` has length 0.
- `should start a tier when the previous tier is completed` — academy `completed: ['foodProduction1']` → `foodProduction2` active, knowledge decreased.
- `should not start a tier while the previous tier is still active` — `startResearch('foodProduction1')` then `startResearch('foodProduction2')` → `foodProduction2` not active, `events.future` has length 1.
- Tier 1 with academy level ≥ 1 is already covered by `should deduct cost and start research`.

**Research window** — no component tests exist (no `@vue/test-utils`), and under 4A the window isn't touched. Covered by the manual check below.

## Docs to update

- `docs/architecture.md:149` — add "previous tier completed" to the preconditions list and replace the last sentence ("Tier prerequisites ... are not checked here") with: blocked when the previous tier in the chain isn't completed (`RESEARCH_PREREQUISITES`).
- `docs/architecture.md:283` — `canResearch(key, prerequisites)` (requires level ≥ 1, not active, not completed, previous tier completed).
- `docs/architecture.md:289` — add: `RESEARCH_PREREQUISITES` maps each research key to its previous tier, derived from `RESEARCH_TREE`, and is passed to `Academy.canResearch`.
- `docs/specs.md:305-308` — no edit needed: 306 ("Tier N requires tier N-1") is now enforced by the rules too, and 305 stays accurate under 5A. Edit 305 only if 5B or 5C is picked.
- `docs/testing.md` — `constants.test.js` row: add `RESEARCH_PREREQUISITES`; `academy.test.js` (line 68): `canResearch` incl. tier prerequisites; `state.test.js` row: test count 256 → 259.
- `todo/research.md:59` — delete the TODO bullet; optionally add "tier prerequisites" to the Phase 2 line under Done.

## Verification

1. `npm run lint:fix`, then fix any remaining errors.
2. Targeted runs, then each whole file:
   - `npx vitest run tests/models/buildings/academy.test.js -t canResearch`
   - `npx vitest run tests/engine/constants.test.js -t RESEARCH_PREREQUISITES`
   - `npx vitest run tests/engine/state.test.js -t startResearch`
3. `npm test` (required by AGENTS.md).
4. Manual, `npm run dev`: open the Academy window — tier 1 nodes are available and tier 2 is locked; start a tier 1, tier 2 stays locked until it completes, then becomes available and can be started.

## Out of scope / risks

- Hidden Disasters researches stay startable by the engine (Decision 5).
- Academy downgraded to level 0 while researches run: separate TODO in [research.md](./research.md).
- Save loading accepts unknown or out-of-order keys (Decision 6).
- A blocked start is silent. If the window and the rules ever disagree, clicking an "available" node does nothing, with no feedback. Both read tree order, so this only becomes a risk if prerequisites stop being linear; then the map values become arrays and the window should switch to the map (Decision 4B).
- Unrelated doc drift: the "Deferred" note in [research.md](./research.md) says these researches "can already be bought", but Disasters ones can't be bought from the window since that tab was hidden.
