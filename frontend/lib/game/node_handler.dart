import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/sawmill.dart';
import 'package:tensionnode/components/game/woodcutter.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/types/node_type.dart';

mixin NodeHandler on BaseGameComponent {
  Node addHeadquarters({
    required Location location,
    required Inventory inventory,
  }) =>
      addNode(Headquarters(
        type: NodeType.headquarters,
        location: location,
        inventory: inventory,
      ));

  Node addWoodcutter({
    required Location location,
  }) =>
      addNode(Woodcutter(
        type: NodeType.woodcutter,
        location: location,
      ));

  Node addSawmill({
    required Location location,
  }) =>
      addNode(Sawmill(
        type: NodeType.sawmill,
        location: location,
      ));

  Node addFlag({
    required Location location,
  }) =>
      addNode(Flag(
        type: NodeType.flag,
        location: location,
      ));

  Node addNode(Node node) {
    addComponent(node);
    state.addNode(node);

    return node;
  }

  void removeNode(Component node) {
    try {
      removeComponent(node);
      state.removeNode(node);
    } catch (e) {
      // ignore
    }
  }

  void onGameOver() {}

  void build({
    required Location location,
    required NodeType type,
    required MapTile tile,
  }) {
    if (type == NodeType.woodcutter) {
      _buildWoodcutter(
        location: location,
        type: type,
        tile: tile,
      );
    }
  }

  void _buildWoodcutter({
    required Location location,
    required NodeType type,
    required MapTile tile,
  }) {
    if (tile.isForest) {
      addWoodcutter(
        location: location,
      );
    }
  }
}
