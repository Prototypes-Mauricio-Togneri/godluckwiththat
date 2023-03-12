# Tension Planet

* Allow buildings to consume more than 1 resource to generate 1 output

------------

Simplify the inventory. Make it from the resourcesRequired in the NodeType

_addCoalPowerPlant(
    location: json.location.location,
    inventory: Inventory({
        ResourceType.energy: 0,
        ResourceType.coal_ore: 0,
    }),
    connections: [],
    );

------------

* Show building recipe (input -> output) in building details
* Add oil patches in map
* Save/load game state
* Transport specific resources (e.g. move surplus resources out of the node)

Building problems:
* Not connected
* Idle
* Output queue full
* No drones