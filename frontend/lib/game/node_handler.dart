import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/sprite_group.dart';
import 'package:tensionnode/components/game/producers/solar_panel.dart';
import 'package:tensionnode/components/game/transformers/coal_mine.dart';
import 'package:tensionnode/components/game/transformers/copper_mine.dart';
import 'package:tensionnode/components/game/transformers/copper_smelter.dart';
import 'package:tensionnode/components/game/transformers/iron_mine.dart';
import 'package:tensionnode/components/game/transformers/stone_mine.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

  void loadNodes() {
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

  Node addSolarPanel({
    required Location location,
  }) =>
      _addNode(SolarPanel(
        location: location,
      ));

  Node addIronMine({
    required Location location,
  }) =>
      _addNode(IronMine(
        location: location,
      ));

  Node addCopperMine({
    required Location location,
  }) =>
      _addNode(CopperMine(
        location: location,
      ));

  Node addCoalMine({
    required Location location,
  }) =>
      _addNode(CoalMine(
        location: location,
      ));

  Node addStoneMine({
    required Location location,
  }) =>
      _addNode(StoneMine(
        location: location,
      ));

  Node addCopperSmelter({
    required Location location,
  }) =>
      _addNode(CopperSmelter(
        location: location,
        resourcesRequired: {
          ResourceType.energy: 0,
          ResourceType.copper_ore: 0,
        },
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

  void buildNode({
    required Location location,
    required NodeType type,
    required MapTile tile,
  }) {
    switch (type) {
      case NodeType.solar_panel:
        if (tile.isSoil) {
          addSolarPanel(location: location);
        }
        break;
      case NodeType.iron_mine:
        addIronMine(location: location);
        break;
      case NodeType.coal_mine:
        addCoalMine(location: location);
        break;
      case NodeType.copper_mine:
        addCopperMine(location: location);
        break;
      case NodeType.stone_mine:
        addStoneMine(location: location);
        break;
      case NodeType.copper_smelter:
        if (tile.isSoil) {
          addCopperSmelter(location: location);
        }
        break;
    }
  }
}
