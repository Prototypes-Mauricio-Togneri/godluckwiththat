# Specs

This document contains the specifications of the game, divided into sections.

## History

- After a shipwreck, you and your tribe find yourselves in an unknown island
- There you find a portal. When touching it, you summon the Gods
- They tell you that this portal is the only way to get back home
- And the Gods are the only ones that can activate it
- But in order for the Gods to do that, you have to prove your faith
- They will send you a series of challenges
  - If you complete a challenge, you will be blessed
  - If you fail a challenge, you will be punished
  - Only when you complete all challenges you will prove your faith
- Type of challenges
  - Build altars
  - Build shrines
  - Build temples
  - Build monuments
  - Accumulate certain amount of faith
  - Offer tributes
    - Goods (various resources)
    - Human sacrifices (workers)
    - Rituals (consume resources and people)
    - Recover relic (send military away)

## Colony

- The game state is held by the so called "Colony"
- The colony can be improved by spending resources on:
  - Buildings
  - Researches

## Seasons

The game progress over two seasons: warm and cold. Each season has different characteristics that affect the colony in different ways. The season changes every certain amount of time.
  - Warm
  - Cold

## Resources

- Territory: Maximum amount of slots a colony has to create buildings
- Workers
  - Units of labor that can be assigned to specific buildings to produce resources
  - A worker that is not assigned to any building is considered idle and doesn't produce anything
- Food: Produced in farms. Used to:
  - Create workers
  - Create military units
  - Maintain population alive
  - Perform research
- Wood: Produced in woodcutters. Used to:
  - Construct buildings
  - Create basic military units
  - Maintain population alive
  - Perform research
- Stone: Produced in quaries. Used to:
  - Construct buildings
  - Perform research
- Copper: Produced in copper mines. Used to:
  - Create intermediary military units
  - Perform research
- Iron: Produced in iron mines. Used to:
  - Create advance military units
  - Perform research
- Gold: Produced in gold mines. Used to:
  - Create advance military units
  - Perform research
  - Trade in market
- Knowledge: Produced in academies. Used to:
  - Perform research
- Faith: Produced in altars, shrines, temples and monuments. Used to:
  - Accomplish challenges

## Buildings

Each building has a level that can be increased by spending resources. 

- Headquarters
  - Each level unlocks new buildings and researches
  - The higher the level, the more resources it produces.
- House
- Academy
- Storehouse
- Market
- Altar
  - Give a fixed amount of faith per second
  - It doesn’t need workers to produce faith
  - Produce low amounts of faith
- Shrine
  - Workers can be assigned/unassigned to pray
  - Produce medium amounts of faith
- Temple
  - Workers need to commit for certain time to stay and pray
  - The higher the level of the temple, the more they stay
  - They cannot be removed until they finish
  - Produce high amounts of faith
- Monument
  - They don't give faith
  - Some challenges will require to increase their level
- Farm
  - The higher the level, the more resources it produces and the more workers it can have assigned
- Woodcutter
- Quarry
- Copper Mine
- Iron Mine
- Gold Mine
- Barracks
- Archery
- Cavalry
- Workshop
- Wall
- Tower
