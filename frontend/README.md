# Tension Planet

* Allow buildings to consume more than 1 resource to generate 1 output

------------

Move
resourcesRequired: [ResourceType.coal_ore],
resourcesProduced: ResourceType.energy,

to NodeType

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

* Save/load game state
* Setup tensionplanet.com
* Transport specific resources (e.g. move surplus resources out of the node)

Building problems:
* Not connected
* Idle
* Output queue full
* No drones