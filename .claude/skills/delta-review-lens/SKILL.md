---
name: delta-review-lens
description: Project lens for God Luck With That, a hybrid incremental strategy game built with Vite and Vue 3 (JavaScript, Composition API). Supplies the project-specific briefs — architecture, domain, security, resource parity and style — that the delta-review skill turns into reviewer agents. Not a standalone review skill: it defines no change-set collection, orchestration, severities, or fixes of its own.
---

This file is a **lens**, not a review. The `delta-review` skill reads it, takes each `##` section below as one reviewer brief, and owns everything else — collecting the change set, spawning agents, refuting findings, assigning severity, reporting, and fixing. Nothing here overrides that.

**The project.** An incremental colony-management game: 20 buildings across 4 categories, worker assignment, a season cycle, a research tree, a market, and 10 sequential divine challenges as the win condition. Vue 3 with `<script setup>`, no Vue Router — screens switch on a `currentScreen` ref in `app.vue`. The game engine lives in plain JavaScript under `src/js/engine/` and `src/js/models/`; Vue components under `src/components/`; five locales under `src/js/i18n/`. Tests run on Vitest under `tests/`, mirroring the engine, models, helpers and i18n directories.

**What already ran before you.** `CLAUDE.md` requires `npm run lint:fix` and `npm test` before this review. ESLint with `@stylistic` and `eslint-plugin-vue` already enforces semicolons, quotes, indentation, spacing, trailing commas and Vue template rules — **never report what the linter reports**. Assume the suite passed; report a test concern only when the change made an existing test wrong rather than failing.

**What to read first.** `CLAUDE.md` for every review, then the doc matching the change: `docs/architecture.md` (state, tick system, components), `docs/specs.md` (buildings, seasons, progression), `docs/javascript.md` (naming, constants, imports, comments), `docs/localization.md`, `docs/ui.md`, `docs/audio.md`, `docs/performance.md`, `docs/testing.md`.

## Architecture

Layer boundaries, the reactivity contract, registration points, and the failure modes of a two-loop incremental game.

- **The reactivity split is the load-bearing design decision.** `State` and every model are **plain JavaScript, deliberately not wrapped in `reactive()`** — the engine runs with zero Proxy overhead. `game_screen.vue` holds a `shallowReactive` view model (`ui`) fed by two functions: `syncTimers()` (fast path, throttled by `UI_SYNC_INTERVAL`, time-sensitive fields only) and `syncUI()` (full copy, on each 1-second tick and after every player action). Three ways a change breaks this, all silent: wrapping engine state in `reactive`/`ref` and reintroducing the overhead; adding a state field that no sync copies, so the UI never shows it; or reading engine state directly from a component instead of `ui`, producing a value that renders once and never updates.
- **All state mutation is centralised in `State` methods.** Each guards its preconditions, mutates, then calls `this.update(0)` to recalculate derived values. A component that mutates `state`, `colony` or a model directly bypasses both the guard and the recalculation. Components dispatch through `inject('actions')` and read through `inject('ui')` — not through props threaded down the tree.
- **Engine and view stay separated.** No Vue import, no `t()` call for display formatting, and no DOM access inside `src/js/engine/` or `src/js/models/`; no game rules, formulas or balancing decisions inside `.vue` files.
- **Two loops advance time, and the fallback path double-counts if you let it.** A 1-second `setInterval` (`gameTick`) calls `state.update(deltaSec)`; a `requestAnimationFrame` loop (`progressTick`) calls `advanceSeason`, `advanceConstruction`, `advanceResearch`, `advanceEvents` and `advanceChallenges` for smooth progress. `gameTick` also calls all five as a fallback for backgrounded tabs where rAF is suspended. Any new timed subsystem must be idempotent under this arrangement and must take `delta` rather than assuming a fixed step, or it will run at a different speed depending on whether the tab is focused.
- **Registration points for a new building are plural and unforgiving** — a `BUILDING_*` enum, a class in `src/js/models/buildings/`, `BUILDING_CLASS_MAP`, `BUILDING_GRID`, `BUILDING_UPGRADES`, `CARD_COMPONENTS` in `game_screen.vue`, `HQ_BUILDING_UNLOCKS`, `PRODUCTION_RATES` if it produces, `DOWNGRADABLE_BUILDINGS` if it can be downgraded, plus a card component, an image and locale keys. A missing entry usually fails silently rather than throwing.
- **Modals follow one pattern:** parent owns visibility with `v-if`, the modal emits `close` on backdrop `.self`, close button and Escape, and mounts and unmounts cleanly. Nested help modals close themselves in the capture phase with `stopImmediatePropagation`, and the parent guards its own Escape handler. A new modal that leaves a `keydown` listener attached after unmount, or that swallows Escape from its parent, breaks the whole stack.
- **Imports use the `@` alias**, never relative paths. `src/js/engine/assets.js` is generated — never hand-edited.
- **Runtime failure modes to hunt:** work added to `syncUI()` (it runs on every tick and every action — see `docs/performance.md` for the budget) or to `syncTimers()` (it runs every frame); allocation inside either or inside `progressTick`; a `watch` or `computed` over a large structure recreated each sync; listeners, intervals or rAF handles not released in `onUnmounted`; and autosave writing a full `toJSON()` on a short interval.

**Report shape:** the component, model or loop affected, the boundary or contract broken, and the runtime or maintenance consequence.

## Domain

Economy, progression and persistence — where code runs perfectly and the game is still wrong.

- **The production formula has a fixed shape** (`_computeProductionRates`): stage one is `workers × rate`, or `level × rate` for passive producers; stage two starts each resource at multiplier `1` and **adds** research bonuses, worker productivity, blessing boosts, punishment reductions and the season modifier (food only). Final rate is `base × multiplier`, then multiplied by general productivity in `update()`. A bonus applied multiplicatively, applied twice, or folded into the base instead of the multiplier changes the whole curve while every number still looks plausible.
- **General productivity has a deliberate anti-feedback design.** It is recomputed each tick from **pre-penalty** production rates and current consumption, so a penalised rate cannot drive productivity toward zero on the next tick. It is `0` when no workers exist, otherwise reduced by deficit ratio × `SHORTAGE_MAX_PENALTY`, worst-of when both food and wood are negative. Feeding post-penalty rates back in re-creates the death spiral this was written to avoid.
- **Consumption applies to every worker, idle and assigned**, is reduced by research bonuses, and wood is additionally scaled by season. It is computed before production and clamped at zero on shortage.
- **Caps and territory.** Bounded resources clamp to `storehouse.storageCap(storageBonus)` after application; faith and knowledge are unbounded. Territory in use is `totalLevels + pendingTerritory`, so a building under construction reserves its slot; the cap is `headquarters.territoryCap + resources.territoryBonus`, and HQ is exempt from the territory block since it is what raises the cap. Any change that counts construction differently makes territory over- or under-sellable.
- **Edge-detected event sets.** `_resourcesNegativeProduction` and `_resourcesAtCap` fire an event on the transition into the state and dismiss it on recovery, one tick delayed. Comparing levels instead of transitions produces an event every tick; forgetting the recovery path leaves a stale warning on screen forever.
- **Save/load is a two-sided contract.** `State.toJSON()` fans out through `Meta`, `Colony`, `Season`, `Resources`, `Buildings` (all 20) and `Events`; `fromJSON` reverses it and then calls `update(0)` to rehydrate derived fields, returning `null` on any error. A field added to a model without both sides updated is silently lost on load — and because `fromJSON` returns `null` on error, a broken reader turns into "no saved game" rather than a visible failure. `meta.version` exists for migration: a shape change to persisted data needs either backward-compatible reads or a version bump with a migration path.
- **Derived state must not be persisted.** Consumption, productivity and the negative-production set are ephemeral and recalculated each tick; writing them into `toJSON` freezes a stale value into every save.
- **Challenge state machine:** `pending → activated → started → completed`, with delay and timeout timers, `reset()` for retry after failure, blessings and punishments carrying their own timeouts, and the game paused while any blocking challenge modal is up. Check that every path unpauses exactly once and that a failed challenge can still be retried.
- **Research** requires academy level ≥ 1, must not start when active or completed, and its bonuses aggregate additively through `completedBonuses`. Durations derive from `Cost.toSeconds` — a cost edit silently changes build and research time.
- **Formatting is domain-visible:** `formatTime` rounds with `Math.ceil` (a timer must never display `00:00` while still running) and `formatNumber` abbreviates to K/M/B/T. A rate shown per minute must be derived from the per-second value, not stored separately.
- **Balancing changes** are judged against `docs/specs.md`: costs, multipliers, rates and thresholds must stay internally consistent, and a change to one tier of a progression curve is suspect unless the neighbouring tiers were considered.

**Report shape:** a reachable in-game scenario, the rule or invariant it violates, and what the player observes.

## Security

A static client-side game deployed to Firebase hosting — no server, no accounts, no secrets worth stealing. Weight findings by whether they crash the game, corrupt a save, or turn content into executable markup, not by conventional web-app severity.

- **`v-html` is the only markup sink and it is currently safe by construction.** `changelog_modal.vue` imports `changelog.md` as a build-time `?raw` asset, strips inline HTML with a regex, then renders `marked()` output through `v-html` behind an `eslint-disable` for `vue/no-v-html`. That safety rests on both halves: the source being a bundled static asset and the strip running first. Report any change that feeds `marked` something not bundled at build time, removes or weakens the strip, adds a second `v-html`, or silences `vue/no-v-html` somewhere new.
- **The saved game is user-editable input.** `storage.savedGame` does `JSON.parse` on `localStorage` content and `State.fromJSON` builds live models from it. A hand-edited or truncated save must not crash the app, must not produce `NaN` or negative resources that propagate through the tick, and must not bypass caps in a way that wedges the game. This is single-player, so cheating is the player's business — an unrecoverable game state is not.
- **Every preference read back from storage must be validated on read**, not only clamped on write: autosave interval, trade amount, and the audio toggles all come back as untrusted strings.
- **Everything shipped is public.** A key, token or endpoint added to `src/js/engine/` or to the Firebase config is published on deploy. Firebase hosting configuration changes deserve a read for what they expose.
- **No level-, save- or locale-derived value may become a URL, asset path or dynamic import.** Asset paths come from the generated `assets.js`; keep it that way.

**Report shape:** the attacker capability (an edited save, a crafted changelog entry, a hostile link), the path from that input to the sink, the asset or behaviour affected, and the smallest fix.

## Resource parity

Several sets must move together, and every one of them fails silently.

- **Five locales, one key set.** `ca.js`, `en.js`, `es.js`, `fr.js`, `it.js` each currently hold exactly 443 keys against `en.js` as the reference. A key added to one file and not the other four renders the raw key string to players of those languages; a key removed from `en.js` while others keep it leaves dead entries. Keys are flat dot-notation with lowerCamelCase segments. Any new user-facing string goes through `t(key)` — no literal display text in templates or in JS.
- **Positional parameters must match across locales.** A string using `{0}`/`{1}` must take the same parameters in every language, and the call site must pass them in the same order.
- **`assets.js` is generated, not written.** Adding or removing anything under `public/img/`, `public/audio/sound/` or `public/audio/music/` requires `npm run generate-assets`. A new file without a regenerated `assets.js` has no constant to reference; a deleted file leaves a constant pointing at a 404.
- **Audio files carry a bitrate contract:** music 96 kbps, sound effects 56 kbps (`docs/audio.md`).
- **Constants live in three places by rule** (`docs/javascript.md`): numeric balancing in `balancing.js`, structural constants — class maps, enums, sets, factories — in `constants.js`, pure string enums in `enums.js` re-exported by `constants.js`. A value in the wrong file, or duplicated across two of them, drifts the moment one copy is edited.
- **A new building or resource touches many parallel tables at once** — see the registration list in Architecture. Check every one, plus its locale keys and its image constant.
- **Shared CSS lives in `src/assets/styles.css`.** Repeated rules across `.vue` files belong there; a scoped block that re-declares a shared class silently forks it.
- **Docs are part of the change.** `CLAUDE.md` requires `docs/architecture.md` and `docs/specs.md` to be updated when the behaviour they describe changes, and `docs/testing.md` to track the test suite.

**Report shape:** the two sides that drifted, and the user-visible consequence of the drift.

## Style

Written conventions ESLint does not enforce. Everything here is a **Nit**; if it has a behavioural consequence it belongs to Architecture or Domain. Do not report formatting — `@stylistic` already owns semicolons, quotes, indentation, spacing, trailing commas and line breaks, and `lint:fix` ran before this review.

- **Naming:** files `snake_case`, classes `PascalCase`, functions `camelCase`.
- **No abbreviations.** Full descriptive variable names; only `i`, `j`, `x`, `y`, `dx`, `dy` and `ctx` are allowed short. Unused parameters are `_`, `__`, `___` in order.
- **One class per file.**
- **Constant placement** as described under Resource parity — a hardcoded number, string enum or class map outside `balancing.js`, `constants.js` or `enums.js` is a finding, and so is a new constant duplicating an existing one under a different name.
- **Imports always use the `@` alias.** A relative `./` or `../` import is a finding even when it resolves.
- **Prefer a getter** over a parameterless method that only reads instance state and returns a computed value with no side effects.
- **Comment shape is fixed** (`docs/javascript.md`): a JSDoc block on every class describing its role, a JSDoc block on every function with `@param` and `@returns`, an inline end-of-line comment on each field's first declaration, plain comments above non-obvious blocks.
- **CSS rules** (`docs/ui.md`): colours always `rgba()` and never hex, with alpha `1` for opaque; `rem` for every `border-radius` and no `px` except `50%` for circles; section dividers as `===` block comments with single-line comments above individual rules, describing visual purpose rather than implementation.
- **Dead code introduced by the change**, including an unused locale key, constant, asset entry or exported helper.

**Report shape:** `file:line`, the rule as written above, and the conforming form.
