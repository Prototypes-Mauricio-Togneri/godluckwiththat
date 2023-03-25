# Tension Planet

* Overlay with active constructions, building problems, etc
* Fix construction drones. Make a connection only when it moves resources. Destroy the connection when the drone is back
* Pending connections to constructions
* Save/load game state

## Future
* Make buildings request specific resources from the headquarters
* Link different devices. Create FirebaseAuth account under the hood
* Make mines never exhaust (always give a minimum)

## ################################################################################################################ ##

## New buildings
* Oil refinery (solid fuel)
* Nuclear power plant (uranium)
* Oil power plant (crude oil)

## Resources
* iron
* copper
* coal
* crude oil
* stone
* uranium

## Materials
* iron block: iron
* copper block: copper
* steel: iron + coal
* plastic: crude oil + coal
* concrete: stone
* solid fuel: crude oil

## Components
* gear: iron
* wire: copper
* electronics: iron + copper
* solar cell: electronics + copper
* chips: electronics + plastic
* motor: wire + gear
* battery: wire + plastic
* circuit: chips + plastic

## Machines
* drone: electronics + solar cell + motor
* explorer: chips + motor + battery
* rocket: circuit + battery + solid fuel


New elements, explosives and lasers
Make building, resources and research graphs

### New resources
* water
* titanium
* silicon

    distilled water: water
graphene: coal
    refined oil: crude oil
    light oil: refined oil + water
    heavy oil: light oil + water
solid fuel: heavy oil + water

### New materials
* sulfur: crude oil + water
* glass: silicon + stone

### New components
* pipe: iron
* magnet: iron
* spring: iron
* fiber optic cable: glass + plastic
* solar cell: silicon + wire + iron
* carbon fiber: coal + plastic + crude oil
* explosives: coal + sulfur + water
* battery: iron + copper + sulfur

### Military
* shells: iron + copper
* piercing shells: steel + copper
* cannon shells: steel + plastic + explosives
* rocket shell: iron + chip + explosives

* gun turret: iron + copper + gear
* laser turret: steel + chip + battery

## ################################################################################################################ ##

## Goals
* Extract a special resource (crystals)
* Launch crystals back to home planet with rockets

## Core destabilization
* Buildings generate pollution
* The more pollution, the more the planet core gets destabilized
* Each resource extracted (iron, coal, etc) increases the core destabilization
* Dropping crystals into the core stabilizes it

## Buildings
* Buildings can be scrapped and get back half of the cost
* Buildings can be stopped and resumed

## Drones
* Research can upgrade existing drones to the next level
* The cost of the research is proportional to the existing drones

## Resources
* Have 3 different patch densities
* Upgrade mines to dig deeper and get more resources
* Always put similar patches far away from each other. For example, one patch of iron on the south-west and another in the north-east

## Start
* The player chooses the landing site

## Story
* Plot twist. The last planet is Earth
* That opens a portal to the past (Settlers version)