import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/sprite_group.dart';
import 'package:tensionnode/components/game/buildings/energy/solar_panel.dart';
import 'package:tensionnode/components/game/buildings/extractors/coal_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/copper_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/iron_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/stone_mine.dart';
import 'package:tensionnode/components/game/buildings/transformers/copper_smelter.dart';
import 'package:tensionnode/components/game/buildings/transformers/iron_smelter.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

  void loadNodes() {
    final Inventory inventory = Inventory({});
    inventory.load(state.jsonMatch.headquarters.inventory);

    addHeadquarters(
      location: const Location(0, 0),
      inventory: inventory,
    );

    for (final JsonBuilding json in state.jsonMatch.buildings.solarPanels) {
      addSolarPanel(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.ironMines) {
      addIronMine(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.copperMines) {
      addCopperMine(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.coalMines) {
      addCoalMine(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.stoneMines) {
      addStoneMine(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.ironSmelters) {
      addIronSmelter(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.copperSmelters) {
      addCopperSmelter(
        location: json.location.location,
      );
    }

    state.patches[ResourceType.iron_ore] = _patches(
      ResourceType.iron_ore,
      state.jsonMatch.patches.iron,
    );

    state.patches[ResourceType.copper_ore] = _patches(
      ResourceType.copper_ore,
      state.jsonMatch.patches.copper,
    );

    state.patches[ResourceType.coal_ore] = _patches(
      ResourceType.coal_ore,
      state.jsonMatch.patches.coal,
    );

    state.patches[ResourceType.stone_ore] = _patches(
      ResourceType.stone_ore,
      state.jsonMatch.patches.stone,
    );

    _addSpriteGroup(Assets.IMAGES_RESOURCES_IRON_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_COPPER_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_COAL_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_STONE_ORE);

    reloadPatches();
  }

  List<Patch> _patches(ResourceType resourceType, List<JsonPatch> list) {
    return list
        .map((e) => Patch(
              type: resourceType,
              location: e.location.location,
              amount: e.amount,
            ))
        .toList();
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
    spriteGroups[resourceType.sprite]!.load(state.patchLocations(resourceType));
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
  }) =>
      _addNode(SolarPanel(
        location: location,
        input: Inventory({}),
      ));

  Node addIronMine({
    required Location location,
  }) =>
      _addNode(IronMine(
        location: location,
        input: Inventory({
          ResourceType.energy: 0,
        }),
      ));

  Node addCopperMine({
    required Location location,
  }) =>
      _addNode(CopperMine(
        location: location,
        input: Inventory({
          ResourceType.energy: 0,
        }),
      ));

  Node addCoalMine({
    required Location location,
  }) =>
      _addNode(CoalMine(
        location: location,
        input: Inventory({
          ResourceType.energy: 0,
        }),
      ));

  Node addStoneMine({
    required Location location,
  }) =>
      _addNode(StoneMine(
        location: location,
        input: Inventory({
          ResourceType.energy: 0,
        }),
      ));

  Node addIronSmelter({
    required Location location,
  }) =>
      _addNode(IronSmelter(
        location: location,
        input: Inventory({
          ResourceType.energy: 0,
          ResourceType.iron_ore: 0,
        }),
      ));

  Node addCopperSmelter({
    required Location location,
  }) =>
      _addNode(CopperSmelter(
        location: location,
        input: Inventory({
          ResourceType.energy: 0,
          ResourceType.copper_ore: 0,
        }),
      ));

  Node _addNode(Node node) {
    addComponent(node);
    state.addNode(node);

    return node;
  }

  void removeNode(Node node) {
    try {
      removeComponent(node);
      state.removeNode(node);
    } catch (e) {
      // ignore
    }
  }

  // TODO(momo): check the tile is placed on
  void buildConstructionNode({
    required Location location,
    required NodeType type,
    required MapTile tile,
  }) {
    switch (type) {
      case NodeType.headquarters:
        break;
      case NodeType.solar_panel:
      case NodeType.iron_mine:
      case NodeType.copper_mine:
      case NodeType.coal_mine:
      case NodeType.stone_mine:
      case NodeType.iron_smelter:
      case NodeType.copper_smelter:
        addConstruction(
          location: location,
          type: type,
        );
        break;
    }
  }

  Node buildNode({
    required Location location,
    required NodeType type,
  }) {
    switch (type) {
      case NodeType.solar_panel:
        return addSolarPanel(location: location);
      case NodeType.iron_mine:
        return addIronMine(location: location);
      case NodeType.copper_mine:
        return addCoalMine(location: location);
      case NodeType.coal_mine:
        return addCoalMine(location: location);
      case NodeType.stone_mine:
        return addStoneMine(location: location);
      case NodeType.iron_smelter:
        return addIronSmelter(location: location);
      case NodeType.copper_smelter:
        return addCopperSmelter(location: location);
      case NodeType.headquarters:
        throw Exception('Headquarters cannot be built');
    }
  }
}
