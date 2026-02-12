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
  - Build shrines
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
    - Settlement → unlocks: Academy, Shrine, Quarry, Barracks
    - Village → unlocks: Storehouse, Temple, Copper Mine, Archery
    - Town → unlocks: Monument, Iron Mine, Stable, Wall
    - City → unlocks: Market, Gold Mine, Workshop, Tower

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
  - All workers (idle and assigned) consume food and wood each tick to stay alive
    - If the colony cannot feed or shelter all workers, those it cannot sustain die (idle workers first, then from the most-staffed buildings)
    - Food and wood shortages are evaluated independently; the higher death count is applied
  - Consumed to
    - Assigned to buildings to produce resources
  - A worker that is not assigned to any building is considered idle
    - Idle workers don't produce anything, making them detrimental
- Knowledge
  - Produced in
    - Academies
  - Consumed to
    - Perform research
- Faith
  - Produced in
    - Altars
    - Shrines
    - Temples
  - Granted as a one-time boost by
    - Monuments (per level upgrade)
  - Consumed to
    - Complete challenges

## Buildings

Each building has a level that can be increased by spending resources.

- Headquarters
  - Each level unlocks new buildings and researches
  - Increases the maximum amount of territory slots
  - Workers cannot be assigned to this building
  - The higher the level, the more territory it provides
- House
  - Determines the maximum population (workers) the colony can have
  - Workers are recruited by spending food, up to the population limit
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
  - Allows trading resources
  - Workers cannot be assigned to this building
  - The higher the level, the cheaper the trades
- Altar
  - Produces a fixed amount of faith per second
  - Workers cannot be assigned to this building
  - Produces low amounts of faith
- Shrine
  - Workers can be assigned/unassigned to pray
  - Produces medium amounts of faith
- Temple
  - Workers commit for a certain time to stay and pray
  - Committed workers count as assigned (non-idle) and cannot produce anything else
  - They cannot be removed until they finish
  - Faith is only produced when a worker finishes their commitment
  - The higher the level, the longer they stay
  - Produces high amounts of faith
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

## Balancing

All tunable numeric constants are centralized in `src/js/balancing.js`. This file is the single source of truth for game economy values and is consumed by building classes, `constants.js`, `game_state.js`, and UI components. When adjusting the game's difficulty or economy, only this file should need to change.

The file contains:

- **Building base costs** (`BUILDING_BASE_COSTS`) — The base resource cost (wood, stone, etc.) for each building, used in level-up cost formulas.
- **Level-up multipliers** (`BUILDING_LEVEL_UP_MULTIPLIERS`) — Exponential multiplier per building that scales the base cost each level. Formula: `floor(base × multiplier ^ level)`. The headquarters uses `multiplier ^ (level - 1)` since it starts at level 1.
- **HQ upgrade costs** (`HQ_UPGRADE_COSTS`) — Fixed resource costs to upgrade the colony type (Camp → Settlement → Village → Town → City).
- **Production rates** (`PRODUCTION_RATES`) — Base resource output per worker per second for each production building (farms, woodcutters, quarries, mines, academies, shrines). Passive buildings (e.g. altar, flagged `passive: true`) produce per level instead of per worker.
- **Population & workers** — House population formula values (`HOUSE_BASE_POPULATION`, `HOUSE_POPULATION_PER_LEVEL`), worker slots per building level (`WORKERS_PER_LEVEL`), worker recruitment cost (`WORKER_RECRUIT_COST`), and worker upkeep rates (`WORKER_FOOD_CONSUMPTION`, `WORKER_WOOD_CONSUMPTION`).
