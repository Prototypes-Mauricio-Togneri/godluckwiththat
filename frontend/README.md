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
* Oil refinery
* Nuclear power plant
* Oil power plant

## Resources
* Uranium

## Materials
* Carbon fiber: hydrogen + plastic
* Solid fuel: crude oil

## Components
* Gear: iron
* Wire: copper
* Electronics: iron + wire
* Solar cell: electronics + copper
* Chips: electronics + plastic
* Motor: wire + gear
* Battery: wire + plastic
* Circuit: chips + plastic

## Machines
* Drone: electronics + solar cell + motor
* Explorer: chips + motor + battery
* Rocket: circuits + battery + hydrogen

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