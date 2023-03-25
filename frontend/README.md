# Tension Planet

* Make building, resources and research graphs
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
* Nuclear power plant (uranium + water)
* Oil power plant (crude oil)

## Resources
* iron (mine)
* copper (mine)
* coal (mine)
* crude oil (oil rig)
* stone (mine)
* water (pump)
* titanium (mine)
* silicon (mine)
* uranium (mine)

## Materials
* Basic
    * iron plate: iron (smelter)
    * copper plate: copper (smelter)
    * solid fuel: crude oil (oil refinery)
* Medium
    * steel: iron + coal (smelter)
    * glass: stone + silicon (smelter)
    * concrete: stone + water (smelter)
    * plastic: crude oil + coal (polymer plant)
    * sulfur: crude oil + water (chemical plant)

## Components
* Basic
    * gear: iron (assembly)
    * wire: copper (assembly)
    * pipe: iron (assembly)
    * magnet: iron (assembly)
    * spring: iron (assembly)
* Medium
    * solar cell: silicon + iron
    * electronics: iron + copper
    * chips: electronics + silicon
    * motor: wire + gear
    * battery: wire + plastic
    * circuit: chips + plastic
    * fiber optic cable: glass + plastic
* Advanced
    * carbon fiber: coal + plastic + crude oil
    * explosives: coal + sulfur + water
    * battery: iron + copper + sulfur

## Machines
* drone: electronics + solar cell + motor
* explorer: chips + motor + battery
* rocket: circuit + battery + solid fuel

## Ammo
* shells: iron + copper
* piercing shells: steel + copper
* cannon shells: steel + plastic + explosives
* rocket shell: iron + chip + explosives

## Turrets
* gun turret: iron + copper + gear
* laser turret: steel + chip + battery

## Combat drones
* light drone
* heavy drone
* etc...

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
* Buildings cannot be placed next to each other
* Solar power plants can be placed next to each other
* Wind turbines need to be separated by 3 fields

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