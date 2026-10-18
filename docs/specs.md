# Specs

This document contains the specifications of the game, divided into sections.

Items marked *(planned)* are designed but not implemented yet. Their design lives in [todo/military.md](../todo/military.md) and [todo/disasters.md](../todo/disasters.md).

## History

- After a shipwreck, you and your tribe find yourselves in an unknown island
- You discover an ancient portal that, upon touch, summons the gods
- They tell you that this portal is the only way to get back home
- And the gods are the only ones that can activate it
- But in order for the gods to do that, you have to prove your faith
- They will send you a series of challenges
  - If you complete a challenge, you will be blessed
  - If you fail a challenge, you will be punished
  - Only when you complete all challenges you will prove your faith
- Type of challenges
  - Build altars
  - Build temples
  - Build monuments
  - Accumulate faith
  - Offer tributes
    - Rituals (resources and people)
    - Recover relic (send military away) *(planned — see [military](../todo/military.md))*

## Colony

The colony is where the game takes place. It is where you will build your buildings, produce resources, assign workers, and perform research.

- The colony type is a separate upgrade from the HQ level
  - It changes the visual representation of the colony
  - Each colony upgrade also unlocks buildings that previously couldn't be built
  - Colony types, in order:
    - Camp → unlocks: House, Altar, Farm, Woodcutter
    - Settlement → unlocks: Storehouse, Temple, Quarry, Barracks
    - Village → unlocks: Academy, Copper Mine, Archery
    - Town → unlocks: Monument, Iron Mine, Stable, Wall
    - City → unlocks: Market, Gold Mine, Workshop, Tower
  - Each colony upgrade also unlocks resources visible in the header bar:
    - Camp: Food, Wood, Faith
    - Settlement: Stone
    - Village: Knowledge, Copper
    - Town: Iron
    - City: Gold

- The colony can be improved by spending resources on
  - Buildings
  - Researches
  - Military *(planned — see [military](../todo/military.md))*
  - Challenges

## Starting State

A new game starts with:

- Headquarters: Camp, level 1
- All other buildings at level 0
- 250 food, 100 wood, everything else at 0 (including workers)
- Warm season, year 1
- Game speed 1x

With 0 workers nothing is produced, so the first step is to recruit workers and assign them.

## Years & Seasons

The game tracks time in years. A year consists of one warm season followed by one cold season. Years start at 1 and increment each time a cold season ends and a new warm season begins.

The game cycles over two seasons: warm and cold. Each season has different characteristics that affect the colony in different ways. The season changes every certain amount of time.

- Warm
  - Food production is increased by 20%
  - Wood consumption is decreased by 20%
- Cold
  - Food production is decreased by 20%
  - Wood consumption is increased by 20%

Seasonal modifiers are added to the research, blessing and punishment modifiers, not multiplied with them. For example, in the warm season with +10% Food Production research, food production is `base × (1 + 0.1 + 0.2)` = +30%.

## Resources

There are two types of resources

### Regular

Regular resources are capped by the storage capacity (see Storehouse). Any of them can be required as an offering by a challenge.

- Food
  - Produced in
    - Farms
  - Consumed to
    - Create workers
    - Expand HQ territory
    - Maintain population alive
    - Perform research
    - Sell at the market
    - Create military units *(planned — see [military](../todo/military.md))*
- Wood
  - Produced in
    - Woodcutters
  - Consumed to
    - Construct buildings (including HQ territory expansion and type upgrades)
    - Maintain population alive
    - Perform research
    - Sell at the market
    - Create basic military units *(planned — see [military](../todo/military.md))*
- Stone
  - Produced in
    - Quarries
  - Consumed to
    - Construct buildings (including HQ type upgrades)
    - Perform research
    - Sell at the market
- Copper
  - Produced in
    - Copper mines
  - Consumed to
    - Upgrade the HQ type
    - Perform research
    - Sell at the market
    - Create intermediary military units *(planned — see [military](../todo/military.md))*
- Iron
  - Produced in
    - Iron mines
  - Consumed to
    - Upgrade the HQ type
    - Perform research
    - Sell at the market
    - Create advanced military units *(planned — see [military](../todo/military.md))*
- Gold
  - Produced in
    - Gold mines
    - Market (selling resources)
  - Consumed to
    - Perform research
    - Buy resources at the market
    - Create advanced military units *(planned — see [military](../todo/military.md))*

### Special

- Territory
  - Each building level occupies one territory slot (e.g. a level 3 building occupies 3 slots total)
  - Produced in
    - Headquarters
  - Consumed to
    - Construct and upgrade buildings
  - When territory is full and expanding is impossible (the largest single resource in the expansion cost exceeds storage capacity), certain buildings (farm, woodcutter, quarry, mines, academy, temple, market, altar) can be downgraded by 1 level to free a slot. Downgrading is free, instant, and returns excess workers to idle
- Workers
  - Recruited by spending 50 food each
    - There is no separate recruit action: assigning a worker to a building when no worker is idle recruits one automatically, as long as there is enough food and the population cap allows it
  - The maximum population is determined by the house level
  - With 0 workers, nothing is produced (including the Altar's passive faith)
  - All workers (idle and assigned) consume food and wood each tick
    - If resources are insufficient, they are clamped to 0
    - Shortage penalty: when food or wood has negative net production, all production rates are reduced proportionally to the deficit ratio (uncovered consumption / total consumption), up to 100%. If both are negative, only the worst penalty applies. The penalty starts on the tick after the net production first turns negative
  - Consumed to
    - Assigned to buildings to produce resources
  - A worker that is not assigned to any building is considered idle
    - Idle workers don't produce anything, making them detrimental
  - Idle workers can be permanently dismissed (removed from the colony) to reduce consumption
- Knowledge
  - Not limited by storage capacity
  - Produced in
    - Academies
  - Consumed to
    - Perform research
- Faith
  - Not limited by storage capacity
  - Produced in
    - Altars
    - Temples
  - Granted as a one-time boost by
    - Monuments (per level upgrade)
  - Consumed to
    - Complete challenges

## Buildings

Each building has a level that can be increased by spending resources. Building and upgrading takes time — resources are deducted immediately when construction starts, but the level increments only after a construction timer expires. Build time is derived from the upgrade cost via `Cost.toSeconds`, which sums each resource amount multiplied by its time weight (defined in `RESOURCE_TIME_WEIGHTS`), then raises the total to a sub-linear exponent (`RESOURCE_TIME_EXPONENT`). During construction, buildings continue producing at their current level. Territory is reserved immediately for buildings under construction.

- Headquarters
  - Each type upgrade unlocks new buildings (see Colony types above)
    - Type upgrades cost wood, stone, copper and iron (`HQ_UPGRADE_COSTS`)
  - Increases the maximum amount of territory slots
    - Territory expansion (level up) costs food and wood
    - Expansion research lowers the expansion cost and, since build time is derived from the cost, also shortens it
  - Territory expansion and type upgrade cannot run at the same time
  - Construction research and the Rapid Construction blessing shorten both territory expansion and type upgrades
  - Workers cannot be assigned to this building
  - The higher the level, the more territory it provides
- House
  - Determines the maximum population (workers) the colony can have
  - Workers are recruited by spending food, up to the population limit
  - Idle workers can be dismissed to permanently reduce population
  - Workers cannot be assigned to this building
  - The higher the level, the higher the population cap
- Academy
  - Produces knowledge
  - The higher the level
    - The more workers it can have assigned
    - The more knowledge it produces
- Storehouse
  - Increases the maximum amount of resources that can be stored
    - Applies to food, wood, stone, copper, iron and gold. Knowledge and faith are uncapped
  - Workers cannot be assigned to this building
  - The higher the level, the more resources it can store
- Market
  - Allows trading Food, Wood, Stone, Copper, and Iron for Gold (buy or sell in lots of 100)
  - Trading requires the Market at level ≥ 1. Each trade must be a multiple of 100
  - The trade-size selector offers 100, 1000, 10000… up to the storage cap. The chosen size is remembered between sessions
  - A buy is refused if it would push the resource over the storage cap. A sell is refused if the gold received would push gold over the storage cap
  - Base gold prices per 100: Food=100, Wood=110, Stone=120, Copper=130, Iron=140
  - Default 30% trade fee, applied once to the summed lot prices: buy costs `lot prices × 1.30`, sell returns `lot prices × 0.70` (rounded down). Buying 100 food at price 100 costs 133; selling it returns 67
  - Each lot of 100 bought raises the resource price by 3 gold; each lot sold lowers it by 3 gold (AoE2-style)
  - Each lot trades at its shifted price: buying 100 food at price 100 costs 103 (before fee), selling at 100 returns 97. Bulk trades are priced lot by lot (buying 1000 food at 100 costs 103 + 106 + … + 130 = 1165 before fee), so buy/sell round trips and split trades always lose gold, even at 0% fee
  - Price floor: minimum 20 gold (sell floor ~14 gold at max fee). Price cap: 9999
  - Workers cannot be assigned to this building
  - The higher the level, the cheaper the trades (-1% fee per level above 1: 30% at level 1, 29% at level 2…)
  - Minimum fee: 5% (reached at level 26)
- Altar
  - Produces a fixed amount of faith per second per level, without workers assigned (but only while the colony has at least 1 worker)
  - Workers cannot be assigned to this building
  - Produces low amounts of faith
- Temple
  - Workers can be assigned/unassigned to pray
  - Produces medium amounts of faith
- Monument
  - Each level grants a one-time fixed amount of faith (not produced per second)
  - Workers cannot be assigned to this building
  - Some challenges require increasing its level
- Farm
  - Produces food
  - The higher the level
    - The more workers it can have assigned
    - The more resources it produces
- Woodcutter
  - Produces wood
  - The higher the level
    - The more workers it can have assigned
    - The more resources it produces
- Quarry
  - Produces stone
  - The higher the level
    - The more workers it can have assigned
    - The more resources it produces
- Copper Mine
  - Produces copper
  - The higher the level
    - The more workers it can have assigned
    - The more resources it produces
- Iron Mine
  - Produces iron
  - The higher the level
    - The more workers it can have assigned
    - The more resources it produces
- Gold Mine
  - Produces gold
  - The higher the level
    - The more workers it can have assigned
    - The more resources it produces
- Barracks *(planned — see [military](../todo/military.md))*
  - Produces infantry units
  - The higher the level
    - The more infantry can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Archery *(planned — see [military](../todo/military.md))*
  - Produces archer units
  - The higher the level
    - The more archers can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Stable *(planned — see [military](../todo/military.md))*
  - Produces cavalry units
  - The higher the level
    - The more cavalry can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Workshop *(planned — see [military](../todo/military.md))*
  - Produces siege units
  - The higher the level
    - The more siege units can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Wall *(planned — see [military](../todo/military.md))*
  - The higher the level, the more defense it provides to the colony
  - Workers cannot be assigned to this building
- Tower *(planned — see [military](../todo/military.md))*
  - The higher the level, the more attack it provides to the colony
  - Workers cannot be assigned to this building

The six military buildings (Barracks, Archery, Stable, Workshop, Wall, Tower) can already be built and upgraded: they cost resources and take territory, but have no effect yet. They are not in the downgradable list, so the territory they take cannot be freed.

## Research

The research system allows the player to unlock permanent bonuses by spending knowledge and other resources at the Academy. Research is accessed via the Research modal in the game UI.

- Research is organized into 5 categories: Colony, Resources, Religion, Military, Disasters
  - Colony (5 subcategories × 5 tiers = 25 researches): Transportation, Construction, Expansion, Storage, Habitation
  - Resources (6 subcategories × 5 tiers = 30 researches): Food Production, Food Consumption, Wood Production, Wood Consumption, Mining, Knowledge Production
  - Religion (1 subcategory × 5 tiers = 5 researches): Faith
  - Military (3 subcategories × 5 tiers = 15 researches): Defense, Attack, Warning (advance notice of enemy raids)
  - Disasters (3 subcategories × 5 tiers = 15 researches): Floods, Health, Earthquakes
  - Military researches can already be bought, but their bonuses have no effect yet *(planned — see [military](../todo/military.md))*
  - The Disasters tab is hidden in the research modal until disasters are implemented, so its researches cannot be started *(planned — see [disasters](../todo/disasters.md))*
- Within a subcategory, researches form a linear chain of 5 tiers. Tier N requires tier N-1 to be completed first
- Each research has a resource cost (knowledge plus other resources). Duration is derived from the cost via `Cost.toSeconds`. Starting any research requires academy level ≥ 1 (flat check, not per-research). Bonuses are defined per subcategory (type and value), granted once per completed tier
- Multiple researches can be active simultaneously across different subcategories, but within a subcategory only one can be active (the linear chain prevents starting the next tier before the current one completes)
- Completed bonuses accumulate additively across all completed researches

### Bonuses by subcategory

- **Colony**
  - Transportation: +5% resource gathering productivity (bounded resources only)
  - Construction: -10% construction time
  - Expansion: -10% expansion cost
  - Storage: +5% storage capacity
  - Habitation: +1 population per house level
- **Resources**
  - Food Production: +5% food production
  - Food Consumption: -5% food consumption
  - Wood Production: +5% wood production
  - Wood Consumption: -5% wood consumption
  - Mining: +5% stone/copper/iron/gold production
  - Knowledge Production: +5% knowledge production
- **Disasters** *(planned — see [disasters](../todo/disasters.md))*
  - Floods: -10% flood impact
  - Health: -10% disease impact
  - Earthquakes: -10% earthquake impact
- **Religion**
  - Faith: +5% faith production
- **Military** *(planned — see [military](../todo/military.md))*
  - Defense: +10% unit defense
  - Attack: +10% unit attack
  - Warning: +10% raid warning time

## Events

The game displays an event log as a column alongside the building columns. Events inform the player of upcoming threats and past occurrences.

- **Future events** — warn about incoming events: construction, territory expansion, HQ type upgrade, research in progress and the active challenge countdown. Each shows a countdown timer that ticks down in real time. Enemy raids and disasters will also appear here *(planned — see [military](../todo/military.md) and [disasters](../todo/disasters.md))*.
- **Past events** — inform about things that have already happened (e.g. season changed, research completed, resource at storage cap, resource production went negative, idle workers, population or territory limit reached). Displayed in a muted style. Raid outcomes will also appear here *(planned — see [military](../todo/military.md))*.
- Past events can be dismissed by the player (close button), or all at once with a "Clear all" button (asks for confirmation). Future events cannot be dismissed.
- Warnings clear themselves when their condition ends: storage cap, negative production, idle workers, population limit and territory limit.
- The challenge countdown row is highlighted while its requirements are currently met. Clicking it opens the challenge detail modal.
- Active blessings and punishments are listed in their own sections of the column, each with its remaining time.
- Events are part of the colony data model and are persisted with save data.
- The events column is always visible in the game screen.

## Challenges

The core narrative driver. The gods test the colony's worthiness to pass through the portal by sending 10 sequential challenges. Completing all challenges is the win condition (portal activates, player goes home). The win modal lets the player continue playing the same colony or return to the home screen.

### Lifecycle

1. When the game starts, the first pending challenge is activated immediately
2. **Delay phase**: a hidden timer counts up (`delayElapsed`). When it reaches `delay`, the challenge transitions to `started`, a non-dismissable future event appears, and the player is notified. Clicking the event opens the challenge detail modal
3. **Timeout phase**: a visible timer counts up (`timeoutElapsed`). The player must meet all requirements before `timeoutElapsed` reaches `timeout`
4. **Resolution**: when the timeout expires, the game checks whether all requirements are met at that moment
   - **Success**: requirements are deducted from the colony (faith, resources, workers sacrificed). A reward modal pauses the game and offers two blessings to choose from. After choosing, the blessing is applied. If more challenges remain, the next one activates. If all 10 are completed, the win modal appears
   - **Failure**: a punishment modal pauses the game showing the penalty. After acknowledging, the punishment is applied: every punishment takes 50% of stored faith and a fraction of each stored regular resource, and some also sacrifice workers and destroy building levels (see Punishments). The challenge resets (timers back to 0) and the player can retry

### Requirements

Each challenge specifies a combination of (all optional per challenge):
- `faith` — consumed on completion
- `altar` / `temple` / `monument` — building level checked (not consumed)
- `resources` — resource amounts consumed on completion
- `workers` — sacrificed on completion: first from idle pool, then randomly unassigned from producer buildings (clamped to available workers)

### Blessings

Rewards earned by completing challenges. The player chooses one of two offered blessings. Each challenge offers distinct blessing types to avoid stacking conflicts.

#### Instant blessings (applied immediately, no ongoing effect)
- **Gift from the Heavens** — receive a fixed amount of resources (capped at storage)
- **Holy Expansion** — receive a fixed number of territory slots (added to `territoryBonus`)

#### Ongoing blessings (applied continuously for a duration)
- **Fertile Soil** — increases farm productivity
- **Forest Bloom** — increases wood productivity
- **Rich Mines** — increases mining productivity (quarry + all mines)
- **Wisdom of the Gods** — increases knowledge productivity
- **Celestial Prosperity** — increases general productivity (all producers)
- **Rapid Construction** — buildings constructed faster (only affects new constructions, not in-progress ones). Stacks multiplicatively with Construction research: `duration × (1 − research) × (1 − blessing)`, so 50% research + 50% blessing yields 25% of the base duration
- **Favorable Weather** — warm season becomes more productive, cold season becomes less harsh. Formula: the season bonus (`warm` in warm season, `cold` in cold season) is added to the food modifier and subtracted from the wood modifier. Examples with `warm = 0.1, cold = 0.1`: warm food modifier `0.2 + 0.1 = 0.3` (+30% instead of +20%), warm wood modifier `-0.2 - 0.1 = -0.3` (-30% instead of -20%), cold food modifier `-0.2 + 0.1 = -0.1` (-10% instead of -20%), cold wood modifier `0.2 - 0.1 = 0.1` (+10% instead of +20%)
- **Blessed Markets** — trade fee is 0%, overriding market level reduction

### Punishments

Penalties applied when a challenge fails. Every punishment instantly takes 50% of stored faith and a fraction of each stored regular resource. Depending on the challenge, it can also sacrifice workers, destroy building levels, and reduce productivity for a duration. Exact values per challenge are in `src/data/challenges.json`.

- **Crop Failure** — reduces farm productivity. In challenge 1 it also sacrifices workers and destroys building levels
- **Wildfires** — reduces woodcutter productivity
- **Landslide** — reduces mining productivity (quarry + all mines)
- **Plague** — sacrifices workers (instant only, no ongoing productivity reduction)
- **Volcano** — reduces general productivity, sacrifices workers and destroys building levels

Building level downgrades select random buildings from the downgradable list. A building is eligible if its level is > 1, or level == 1 and currently under construction (construction is cancelled and the building is destroyed). Excess workers above new capacity are returned to idle.

### Design Rules

- **Sequential**: one challenge active at a time
- **No stacking**: two blessings (or punishments) of the same type are never active simultaneously. This is not enforced by the code: it holds because every effect duration (at most 300 s for blessings, 180 s for punishments) is shorter than the time before the same type can be granted again (a retry takes at least 330 s: 30 s delay + 300 s timeout). Longer durations in `challenges.json` would break it
- **Ongoing effect timeouts**: only tick while the game is running (paused/modal states excluded)
- **Non-dismissable**: challenge countdown events cannot be dismissed by the player
- **All definitions**: stored in `src/data/challenges.json`

## Difficulties
Players have to choose between:
- Balance production chains
  - Overproducing one resource leads to shortages in others
- Grow population
  - More population enables economic growth but consumes more resources to sustain
- Grow military *(planned — see [military](../todo/military.md))*
  - Stronger defenses protect against raids but divert resources from economic growth
- Expand territory
  - More territory enables economic growth
  - It will also provoke more frequent enemy attacks *(planned — see [military](../todo/military.md))*
- Research new technologies
  - Unlocking upgrades costs resources and time, delaying other priorities
- Adapt to seasons
  - Seasonal changes affect production rates, requiring players to plan ahead and stockpile accordingly
- Prepare for disasters *(planned — see [disasters](../todo/disasters.md))*
  - Random catastrophic events can destroy buildings or resources, so players must keep reserves without over-hoarding
- Complete the challenges of the gods
  - Divine challenges require specific resources or milestones, forcing players to divert effort from other goals

## Balancing

Tunable numeric constants live in two places:

- `src/js/engine/balancing.js` — the colony economy (buildings, production, workers, seasons, market, storage, territory, research). It is consumed by building classes, `constants.js`, `state.js`, and UI components.
- `src/data/challenges.json` — the challenge economy: requirements, blessing strengths and durations, punishment fractions, workers and building levels lost, and the delay/timeout of each challenge.

When adjusting the game's difficulty or economy, only these two files should need to change.

**Game speed** (`GAME_SPEED_OPTIONS`, `GAME_SPEED_DEFAULT` in `constants.js`) — Available speed multipliers (`[1, 2, 3]`) and the default (1x). Stored in `Meta.gameSpeed`. The game loop multiplies delta time by the speed multiplier, uniformly affecting production, seasons, construction, research, events, challenge timers, and blessing/punishment durations. Audio playback is unaffected.

The file contains:

- **Building upgrades** (`BUILDING_UPGRADES`) — Per-building upgrade config with two sub-keys: `cost` (base resource cost) and `multiplier` (exponential scaling factor per level). Build time is derived from the level-up cost via `Cost.toSeconds`.
  - Standard formula (all buildings except HQ): `floor(cost × multiplier^level)` — a level-0 building pays `cost × 1` for its first upgrade.
  - HQ formula: `floor(cost × multiplier^(level-1))` — because HQ starts at level 1 (never level 0), the exponent is shifted by one so the first expansion (level 1 → 2) also pays the base cost (`cost × 1`).
- **HQ upgrade costs** (`HQ_UPGRADE_COSTS`) — Fixed resource costs to upgrade the colony type (Camp → Settlement → Village → Town → City).
- **Production rates** (`PRODUCTION_RATES`) — Base resource output per worker per second for each production building (farms, woodcutters, quarries, mines, academies, temples). Passive buildings (e.g. altar, flagged `passive: true`) produce per level instead of per worker.
- **Population & workers** — House population formula value (`HOUSE_POPULATION_PER_LEVEL`), worker slots per building level (`WORKERS_PER_LEVEL`), worker recruitment cost (`WORKER_RECRUIT_COST`), worker upkeep rates (`WORKER_FOOD_CONSUMPTION`, `WORKER_WOOD_CONSUMPTION`).
- **Resource time weights** (`RESOURCE_TIME_WEIGHTS`, `RESOURCE_TIME_EXPONENT`) — Per-resource time weight in seconds and a sub-linear exponent (0.7), used by `Cost.toSeconds` to derive build duration from resource costs: `floor(weightedSum ^ exponent)`.
- **Season constants** (`SEASON_DURATION`, `SEASON_WARM_FOOD_MODIFIER`, `SEASON_COLD_FOOD_MODIFIER`, `SEASON_WARM_WOOD_MODIFIER`, `SEASON_COLD_WOOD_MODIFIER`) — Season duration in seconds and fractional modifiers for food production and wood consumption per season.
- **Market trading** (`MARKET_TRADE_AMOUNT`, `MARKET_BASE_PRICES`, `MARKET_BASE_FEE`, `MARKET_MIN_FEE`, `MARKET_FEE_REDUCTION_PER_LEVEL`, `MARKET_PRICE_SHIFT`, `MARKET_MIN_CURRENT_PRICE`, `MARKET_MAX_CURRENT_PRICE`) — Trade lot size, base gold prices per resource, fee structure, and dynamic price bounds.
- **Monument faith** (`MONUMENT_FAITH_PER_LEVEL`) — One-time faith granted when a monument finishes construction: `value × newLevel`.
- **Storehouse capacity** (`STOREHOUSE_BASE_CAPACITY`, `STOREHOUSE_CAPACITY_MULTIPLIER`) — Storage cap formula: `floor(base × multiplier^level × (1 + storageBonus))`. Base capacity is 500, multiplier is 1.2.
- **Territory capacity** (`HQ_TERRITORY_PER_LEVEL`) — Territory slots per HQ level (10). Cap = `level × HQ_TERRITORY_PER_LEVEL + territoryBonus`.
- **Shortage penalty** (`SHORTAGE_MAX_PENALTY`) — Maximum productivity reduction factor (1 = 100%) when food or wood has negative net production. Penalty scales proportionally to the deficit ratio.
- **Bulk worker amount** (`BULK_WORKER_AMOUNT`) — Number of workers assigned/dismissed per Ctrl+click (10).
- **Research definitions** (`RESEARCH_SUBCATEGORY_BONUSES`, `RESEARCH_COSTS`) — `RESEARCH_SUBCATEGORY_BONUSES` maps each subcategory to `{ type: BONUS_*, value, [flat] }`. `RESEARCH_COSTS` maps each `RESEARCH_*` key to a `Cost` instance (duration derived via `Cost.toSeconds`). Currently active bonuses in the game loop: worker productivity (bounded resources only), construction time, expansion cost, food/wood production, food/wood consumption, mining, knowledge production, faith production, habitation, storage capacity. Defined but not yet wired: disaster impacts, military stats, raid warning time *(planned)*.
