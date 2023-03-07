import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/sprite_group.dart';
import 'package:tensionnode/components/game/buildings/extractors/coal_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/copper_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/iron_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/stone_mine.dart';
import 'package:tensionnode/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionnode/components/game/buildings/power_plants/solar_panel.dart';
import 'package:tensionnode/components/game/buildings/power_plants/wind_turbine.dart';
import 'package:tensionnode/components/game/buildings/processors/copper_smelter.dart';
import 'package:tensionnode/components/game/buildings/processors/iron_smelter.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/moving_drone.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/assets.dart';

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

  void loadNodes(JsonMatch json) {
    addHeadquarters(
      location: json.headquarters.location.location,
      inventory: Inventory.fromJson(json.headquarters.inventory),
    );

    for (final JsonBuilding json in json.getBuildings(NodeType.solar_panel)) {
      addSolarPanel(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.wind_turbine)) {
      addWindTurbine(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.iron_mine)) {
      addIronMine(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.iron_ore: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.copper_mine)) {
      addCopperMine(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.copper_ore: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.coal_mine)) {
      addCoalMine(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.coal_ore: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.stone_mine)) {
      addStoneMine(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.stone_ore: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.iron_smelter)) {
      addIronSmelter(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.iron_ore: 0,
          ResourceType.iron_block: 0,
        }),
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.copper_smelter)) {
      addCopperSmelter(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.copper_ore: 0,
          ResourceType.copper_block: 0,
        }),
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.drone_factory)) {
      addDroneFactory(
        location: json.location.location,
        inventory: Inventory({
          ResourceType.energy: 0,
          ResourceType.iron_block: 0,
          ResourceType.copper_block: 0,
          ResourceType.drone: 0,
        }),
      );
    }

    _addSpriteGroup(Assets.IMAGES_RESOURCES_IRON_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_COPPER_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_COAL_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_STONE_ORE);

    reloadPatches();
  }

  void _addSpriteGroup(String sprite) {
    final SpriteGroup spriteGroup = SpriteGroup(sprite);
    spriteGroups[sprite] = spriteGroup;
    addToPatchesLayer(spriteGroup);
  }

  void reloadPatches() {
    _reloadPatch(ResourceType.iron_ore);
    _reloadPatch(ResourceType.copper_ore);
    _reloadPatch(ResourceType.coal_ore);
    _reloadPatch(ResourceType.stone_ore);
  }

  void _reloadPatch(ResourceType resourceType) {
    spriteGroups[resourceType.sprite]!
        .load(state.patches.locations(resourceType));
  }

  Node addHeadquarters({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(Headquarters(
        location: location,
        inventory: inventory,
      ));

  Node addConstruction({
    required Location location,
    required NodeType type,
  }) =>
      _addNode(Construction(
        location: location,
        type: type,
      ));

  Node addSolarPanel({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(SolarPanel(
        location: location,
        inventory: inventory,
      ));

  Node addWindTurbine({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(WindTurbine(
        location: location,
        inventory: inventory,
      ));

  Node addIronMine({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(IronMine(
        location: location,
        inventory: inventory,
      ));

  Node addCopperMine({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(CopperMine(
        location: location,
        inventory: inventory,
      ));

  Node addCoalMine({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(CoalMine(
        location: location,
        inventory: inventory,
      ));

  Node addStoneMine({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(StoneMine(
        location: location,
        inventory: inventory,
      ));

  Node addIronSmelter({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(IronSmelter(
        location: location,
        inventory: inventory,
      ));

  Node addCopperSmelter({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(CopperSmelter(
        location: location,
        inventory: inventory,
      ));

  Node addDroneFactory({
    required Location location,
    required Inventory inventory,
  }) =>
      _addNode(DroneFactory(
        location: location,
        inventory: inventory,
      ));

  Node _addNode(Node node) {
    addComponent(node);
    state.addNode(node);

    return node;
  }

  void removeNode({
    required Node node,
    required bool sendDronesBack,
  }) {
    try {
      if (sendDronesBack) {
        final Headquarters headquarters = state.headquarters!;

        node.evacuateDrones(headquarters);

        for (final MovingDrone movingDrone in getMovingDrones()) {
          movingDrone.sendBack(
            nodeDeleted: node,
            headquarters: headquarters,
          );
        }
      }

      removeComponent(node);
      state.removeNode(node);
    } catch (e) {
      // ignore
    }
  }

  bool buildConstructionNode({
    required NodeType type,
    required Location location,
    required MapTile tile,
    required Patch? patch,
  }) {
    final canBeBuilt = _canBeBuilt(
      type: type,
      tile: tile,
      patch: patch,
    );

    if (canBeBuilt) {
      addConstruction(
        location: location,
        type: type,
      );

      return true;
    } else {
      return false;
    }
  }

  bool _canBeBuilt({
    required NodeType type,
    required MapTile tile,
    required Patch? patch,
  }) {
    switch (type) {
      case NodeType.solar_panel:
      case NodeType.wind_turbine:
      case NodeType.iron_smelter:
      case NodeType.copper_smelter:
      case NodeType.drone_factory:
        return tile.isSoil && (patch == null);
      case NodeType.iron_mine:
        return patch?.isIron ?? false;
      case NodeType.copper_mine:
        return patch?.isCopper ?? false;
      case NodeType.coal_mine:
        return patch?.isCoal ?? false;
      case NodeType.stone_mine:
        return patch?.isStone ?? false;
      case NodeType.headquarters:
        return false;
    }
  }

  Node buildNode({
    required Location location,
    required NodeType type,
  }) {
    switch (type) {
      case NodeType.solar_panel:
        return addSolarPanel(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
          }),
        );
      case NodeType.wind_turbine:
        return addWindTurbine(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
          }),
        );
      case NodeType.iron_mine:
        return addIronMine(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.iron_ore: 0,
          }),
        );
      case NodeType.copper_mine:
        return addCopperMine(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.copper_ore: 0,
          }),
        );
      case NodeType.coal_mine:
        return addCoalMine(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.coal_ore: 0,
          }),
        );
      case NodeType.stone_mine:
        return addStoneMine(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.stone_ore: 0,
          }),
        );
      case NodeType.iron_smelter:
        return addIronSmelter(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.iron_ore: 0,
            ResourceType.iron_block: 0,
          }),
        );
      case NodeType.copper_smelter:
        return addCopperSmelter(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.copper_ore: 0,
            ResourceType.copper_block: 0,
          }),
        );
      case NodeType.drone_factory:
        return addDroneFactory(
          location: location,
          inventory: Inventory({
            ResourceType.energy: 0,
            ResourceType.iron_block: 0,
            ResourceType.copper_block: 0,
            ResourceType.drone: 0,
          }),
        );
      case NodeType.headquarters:
        throw Exception('Headquarters cannot be built');
    }
  }
}
