# Tension Planet

* Always push (always or select list)
    - CTRL click makes an automatic connection
    - ALT click makes a specific connection

* FPS to bottom right corner
* Warehouses start with a limit of 100
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

## Materials
* Basic
    * iron plate: iron (smelter)
    * copper plate: copper (smelter)
    * solid fuel: crude oil (oil refinery)
* Medium
    * steel: iron plate + coal (smelter)
    * titanium plate: titanium + coal (smelter)
    * glass: stone + silicon (smelter)
    * concrete: stone + water (smelter)
* Advanced
    * plastic: crude oil + coal (polymer plant)
    * sulfur: crude oil + water (chemical plant)

## Components
* Basic
    * gear: iron plate (assembly)
    * wire: copper plate (assembly)
* Medium
    * solar cell: silicon + iron plate
    * electronics: iron plate + copper plate
    * chips: electronics + silicon
    * motor: wire + gear
    * battery: wire + plastic
    * circuit: chips + plastic
* Advanced
    * carbon fiber: coal + plastic + crude oil
    * explosives: coal + sulfur + water
    * battery: iron plate + copper plate + sulfur

## Machines
* drone: electronics + solar cell + motor
* explorer: chips + motor + battery
* rocket: circuit + battery + solid fuel

## Ammo
* shells: iron plate + copper plate
* piercing shells: steel + copper plate
* cannon shells: steel + plastic + explosives
* rocket shell: iron plate + chip + explosives

## Combat drones
* Gun Mecha: steel + copper plate + gear + solid fuel
* Rocket Mecha: ??? + solid fuel
* Laser Mecha: titanium plate + chip + battery + solid fuel
* etc...