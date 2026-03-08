# Specs

This document contains the specifications of the game, divided into sections.

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
    - Recover relic (send military away)

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
  - Military
  - Challenges

## Years & Seasons

The game tracks time in years. A year consists of one warm season followed by one cold season. Years start at 1 and increment each time a cold season ends and a new warm season begins.

The game cycles over two seasons: warm and cold. Each season has different characteristics that affect the colony in different ways. The season changes every certain amount of time.

- Warm
  - Food production is increased by 20%
  - Wood consumption is decreased by 20%
- Cold
  - Food production is decreased by 20%
  - Wood consumption is increased by 20%

## Resources

There are two types of resources

### Regular

- Food
  - Produced in
    - Farms
  - Consumed to
    - Create workers
    - Create military units
    - Maintain population alive
    - Perform research
- Wood
  - Produced in
    - Woodcutters
  - Consumed to
    - Construct buildings
    - Create basic military units
    - Maintain population alive
    - Perform research
- Stone
  - Produced in
    - Quarries
  - Consumed to
    - Construct buildings
    - Perform research
- Copper
  - Produced in
    - Copper mines
  - Consumed to
    - Create intermediary military units
    - Perform research
- Iron
  - Produced in
    - Iron mines
  - Consumed to
    - Create advanced military units
    - Perform research
- Gold
  - Produced in
    - Gold mines
  - Consumed to
    - Create advanced military units
    - Perform research
    - Trade in market

### Special

- Territory
  - Each building level occupies one territory slot (e.g. a level 3 building occupies 3 slots total)
  - Produced in
    - Headquarters
  - Consumed to
    - Construct and upgrade buildings
- Workers
  - Recruited by spending food
  - The maximum population is determined by the house level
  - All workers (idle and assigned) consume food and wood each tick
    - If resources are insufficient, they are clamped to 0
    - Shortage penalty: when food or wood has negative net production, all production rates are reduced proportionally to the deficit ratio (uncovered consumption / total consumption), up to 100%. If both are negative, only the worst penalty applies
  - Consumed to
    - Assigned to buildings to produce resources
  - A worker that is not assigned to any building is considered idle
    - Idle workers don't produce anything, making them detrimental
  - Idle workers can be permanently dismissed (removed from the colony) to reduce consumption
- Knowledge
  - Produced in
    - Academies
  - Consumed to
    - Perform research
- Faith
  - Produced in
    - Altars
    - Temples
  - Granted as a one-time boost by
    - Monuments (per level upgrade)
  - Consumed to
    - Complete challenges

## Buildings

Each building has a level that can be increased by spending resources. Building and upgrading takes time — resources are deducted immediately when construction starts, but the level increments only after a construction timer expires. Build time is derived from the upgrade cost via `Cost.toSeconds`, which sums each resource amount multiplied by its time weight (defined in `RESOURCE_TIME_WEIGHTS`). During construction, buildings continue producing at their current level. Territory is reserved immediately for buildings under construction.

- Headquarters
  - Each type upgrade unlocks new buildings (see Colony types above)
  - Increases the maximum amount of territory slots
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
  - Workers cannot be assigned to this building
  - The higher the level, the more resources it can store
- Market
  - Allows trading Food, Wood, Stone, Copper, and Iron for Gold (buy or sell in lots of 100)
  - Base gold prices per 100: Food=100, Wood=110, Stone=120, Copper=130, Iron=140
  - Default 30% trade fee: buy costs `price × 1.30`, sell returns `price × 0.70`
  - Buying raises the resource price by 3 gold; selling lowers it by 3 gold (AoE2-style)
  - Price floor: minimum 20 gold (sell floor ~14 gold at max fee). Price cap: 9999
  - Workers cannot be assigned to this building
  - The higher the level, the cheaper the trades (-1% fee per level)
  - Minimum fee: 5%
- Altar
  - Produces a fixed amount of faith per second
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
- Barracks
  - Produces infantry units
  - The higher the level
    - The more infantry can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Archery
  - Produces archer units
  - The higher the level
    - The more archers can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Stable
  - Produces cavalry units
  - The higher the level
    - The more cavalry can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Workshop
  - Produces siege units
  - The higher the level
    - The more siege units can be queued
    - The faster it produces them
  - Workers cannot be assigned to this building
- Wall
  - The higher the level, the more defense it provides to the colony
  - Workers cannot be assigned to this building
- Tower
  - The higher the level, the more attack it provides to the colony
  - Workers cannot be assigned to this building

## Research

The research system allows the player to unlock permanent bonuses by spending knowledge and other resources at the Academy. Research is accessed via the Research modal in the game UI.

- Research is organized into 5 categories: General, Resources, Disasters, Religion, Military
  - General (5 subcategories × 5 tiers = 25 researches): Transportation, Construction, Expansion, Storage, Habitation
  - Resources (6 subcategories × 5 tiers = 30 researches): Food Production, Food Consumption, Wood Production, Wood Consumption, Mining, Knowledge Production
  - Disasters (3 subcategories × 5 tiers = 15 researches): Floods, Health, Earthquakes
  - Religion (1 subcategory × 5 tiers = 5 researches): Faith
  - Military (3 subcategories × 5 tiers = 15 researches): Defense, Attack, Warning
- Within a subcategory, researches form a linear chain of 5 tiers. Tier N requires tier N-1 to be completed first
- Each research has a resource cost (knowledge plus other resources). Duration is derived from the cost via `Cost.toSeconds`. Starting any research requires academy level ≥ 1 (flat check, not per-research). Bonuses are defined per subcategory (type and value), granted once per completed tier
- Multiple researches can be active simultaneously across different subcategories, but within a subcategory only one can be active (the linear chain prevents starting the next tier before the current one completes)
- Completed bonuses accumulate additively across all completed researches

### Bonuses by subcategory

| Category | Subcategory | Bonus per tier |
|---|---|---|
| General | Transportation | +5% worker productivity |
| General | Construction | -10% construction time |
| General | Expansion | -10% expansion cost |
| General | Storage | +10% storage capacity |
| General | Habitation | +1 population per house level |
| Resources | Food Production | +5% food production |
| Resources | Food Consumption | -5% food consumption |
| Resources | Wood Production | +5% wood production |
| Resources | Wood Consumption | -5% wood consumption |
| Resources | Mining | +5% stone/copper/iron/gold production |
| Resources | Knowledge Production | +5% knowledge production |
| Disasters | Floods | -10% flood impact |
| Disasters | Health | -10% disease impact |
| Disasters | Earthquakes | -10% earthquake impact |
| Religion | Faith | +5% faith production |
| Military | Defense | +10% unit defense |
| Military | Attack | +10% unit attack |
| Military | Warning | +10% warning time |

## Events

The game displays an event log as a column alongside the building columns. Events inform the player of upcoming threats and past occurrences.

- **Future events** — warn about incoming events (e.g. enemy raids, disasters). Each shows a countdown timer that ticks down in real time. When the countdown reaches zero, the trigger logic (not yet implemented) decides what happens.
- **Past events** — inform about things that have already happened (e.g. season changed, raid repelled, resource production went negative). Displayed in a muted style.
- All events can be dismissed by the player (close button).
- Events are part of the colony data model and are persisted with save data.
- The events column is always visible in the game screen.

## Difficulties
Players have to choose between:
- Balance production chains
  - Overproducing one resource leads to shortages in others
- Grow population
  - More population enables economic growth but consumes more resources to sustain
- Grow military
  - Stronger defenses protect against raids but divert resources from economic growth
- Expand territory
  - More territory enables economic growth but provokes more frequent enemy attacks
- Research new technologies
  - Unlocking upgrades costs resources and time, delaying other priorities
- Adapt to seasons
  - Seasonal changes affect production rates, requiring players to plan ahead and stockpile accordingly
- Prepare for disasters
  - Random catastrophic events can destroy buildings or resources, so players must keep reserves without over-hoarding
- Complete the challenges of the gods
  - Divine challenges require specific resources or milestones, forcing players to divert effort from other goals

## Balancing

All tunable numeric constants are centralized in `src/js/engine/balancing.js`. This file is the single source of truth for game economy values and is consumed by building classes, `constants.js`, `state.js`, and UI components. When adjusting the game's difficulty or economy, only this file should need to change.

The file contains:

- **Building upgrades** (`BUILDING_UPGRADES`) — Per-building upgrade config with two sub-keys: `cost` (base resource cost) and `multiplier` (exponential scaling factor per level; formula: `floor(cost × multiplier^level)`, HQ uses `multiplier^(level-1)` since it starts at level 1). Build time is derived from the level-up cost via `Cost.toSeconds`.
- **HQ upgrade costs** (`HQ_UPGRADE_COSTS`) — Fixed resource costs to upgrade the colony type (Camp → Settlement → Village → Town → City).
- **Production rates** (`PRODUCTION_RATES`) — Base resource output per worker per second for each production building (farms, woodcutters, quarries, mines, academies, temples). Passive buildings (e.g. altar, flagged `passive: true`) produce per level instead of per worker.
- **Production bonus map** (`PRODUCTION_BONUS_MAP`) — Maps each production building key to its corresponding `BONUS_*` research type (e.g. `BUILDING_FARM` → `BONUS_FOOD_PRODUCTION`). Used by `State.update()` to apply research multipliers to production rates.
- **Population & workers** — House population formula value (`HOUSE_POPULATION_PER_LEVEL`), worker slots per building level (`WORKERS_PER_LEVEL`), worker recruitment cost (`WORKER_RECRUIT_COST`), worker upkeep rates (`WORKER_FOOD_CONSUMPTION`, `WORKER_WOOD_CONSUMPTION`).
- **Resource time weights** (`RESOURCE_TIME_WEIGHTS`) — Per-resource time weight in seconds, used by `Cost.toSeconds` to derive build duration from resource costs.
- **Season constants** (`SEASON_DURATION`, `SEASON_WARM_FOOD_MODIFIER`, `SEASON_COLD_FOOD_MODIFIER`, `SEASON_WARM_WOOD_MODIFIER`, `SEASON_COLD_WOOD_MODIFIER`) — Season duration in seconds and fractional modifiers for food production and wood consumption per season.
- **Market trading** (`MARKET_TRADE_AMOUNT`, `MARKET_BASE_PRICES`, `MARKET_BASE_FEE`, `MARKET_MIN_FEE`, `MARKET_FEE_REDUCTION_PER_LEVEL`, `MARKET_PRICE_SHIFT`, `MARKET_MIN_CURRENT_PRICE`, `MARKET_MAX_CURRENT_PRICE`) — Trade lot size, base gold prices per resource, fee structure, and dynamic price bounds.
- **Monument faith** (`MONUMENT_FAITH_PER_LEVEL`) — One-time faith granted when a monument finishes construction: `value × newLevel`.
- **Research definitions** (`RESEARCH_SUBCATEGORY_BONUSES`, `RESEARCH_COSTS`) — `RESEARCH_SUBCATEGORY_BONUSES` maps each subcategory to `{ type: BONUS_*, value, [flat] }`. `RESEARCH_COSTS` maps each `RESEARCH_*` key to a `Cost` instance (duration derived via `Cost.toSeconds`). Currently active bonuses in the game loop: worker productivity, construction time, food/wood production, food/wood consumption, mining, knowledge production, faith production, habitation, storage capacity. Defined but not yet wired: expansion cost, disaster impacts, military stats, warning time.
