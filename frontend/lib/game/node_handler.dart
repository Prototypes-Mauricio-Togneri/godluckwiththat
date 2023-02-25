import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/sprite_group.dart';
import 'package:tensionnode/components/game/producers/coal_mine.dart';
import 'package:tensionnode/components/game/producers/cooper_mine.dart';
import 'package:tensionnode/components/game/transformers/cooper_furnace.dart';
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
    for (final JsonBuilding json in state.jsonMatch.buildings.coalMines) {
      addCoalMine(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.cooperMines) {
      addCooperMine(
        location: json.location.location,
      );
    }

    for (final JsonBuilding json in state.jsonMatch.buildings.cooperFurnaces) {
      addCooperFurnace(
        location: json.location.location,
      );
    }

    state.patches[ResourceType.coal_ore] = _patches(
      ResourceType.coal_ore,
      state.jsonMatch.patches.coal,
    );

    state.patches[ResourceType.cooper_ore] = _patches(
      ResourceType.cooper_ore,
      state.jsonMatch.patches.cooper,
    );

    _addSpriteGroup(Assets.IMAGES_RESOURCES_COAL_ORE);
    _addSpriteGroup(Assets.IMAGES_RESOURCES_COOPER_ORE);

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
    _reloadPatch(ResourceType.coal_ore);
    _reloadPatch(ResourceType.cooper_ore);
  }

  void _reloadPatch(ResourceType resourceType) {
    spriteGroups[resourceType.sprite]!.load(state.patchLocations(resourceType));
  }

  Node addCoalMine({
    required Location location,
  }) =>
      _addNode(CoalMine(
        location: location,
      ));

  Node addCooperMine({
    required Location location,
  }) =>
      _addNode(CooperMine(
        location: location,
      ));

  Node addCooperFurnace({
    required Location location,
  }) =>
      _addNode(CooperFurnace(
        location: location,
        resourcesRequired: [
          ResourceType.coal_ore,
          ResourceType.cooper_ore,
        ],
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
      case NodeType.coal_mine:
        if (tile.isCoal) {
          addCoalMine(location: location);
        }
        break;
      case NodeType.cooper_mine:
        if (tile.isCooper) {
          addCoalMine(location: location);
        }
        break;
      case NodeType.cooper_furnace:
        if (tile.isSoil) {
          addCooperFurnace(location: location);
        }
        break;
    }
  }
}
