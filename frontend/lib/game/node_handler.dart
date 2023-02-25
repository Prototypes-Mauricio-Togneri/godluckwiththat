import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/sprite_group.dart';
import 'package:tensionnode/components/game/producers/coal_mine.dart';
import 'package:tensionnode/components/game/producers/cooper_mine.dart';
import 'package:tensionnode/components/game/transformers/cooper_furnace.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_producer.dart';
import 'package:tensionnode/json/json_transformer.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

  void loadNodes() {
    for (final JsonProducer json in state.jsonMatch.coalMines) {
      addCoalMine(
        location: json.location.location,
      );
    }

    for (final JsonProducer json in state.jsonMatch.cooperMines) {
      addCooperMine(
        location: json.location.location,
      );
    }

    for (final JsonTransformer json in state.jsonMatch.cooperFurnaces) {
      addCooperFurnace(
        location: json.location.location,
      );
    }
  }

  /*void _addSpriteGroup(String sprite) {
    final SpriteGroup spriteGroup = SpriteGroup(sprite);
    spriteGroups[sprite] = spriteGroup;
    addToPathsLayer(spriteGroup);
  }*/

  Node addCoalMine({
    required Location location,
  }) =>
      addNode(CoalMine(
        location: location,
      ));

  Node addCooperMine({
    required Location location,
  }) =>
      addNode(CooperMine(
        location: location,
      ));

  Node addCooperFurnace({
    required Location location,
  }) =>
      addNode(CooperFurnace(
        location: location,
        resourcesRequired: [
          ResourceType.coal_ore,
          ResourceType.cooper_ore,
        ],
      ));

  Node addNode(Node node) {
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
