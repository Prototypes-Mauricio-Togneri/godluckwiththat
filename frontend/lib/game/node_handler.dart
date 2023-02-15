import 'package:flame/components.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/woodcutter.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/types/node_type.dart';

mixin NodeHandler on BaseGameComponent {
  void addHeadquarters({
    required Location location,
    required Resources resources,
  }) {
    addNode(Headquarters(
      location: location,
      resources: resources,
    ));
  }

  void addWoodcutter({
    required Location location,
    required Resources resources,
  }) {
    addNode(Woodcutter(
      location: location,
      resources: resources,
    ));
  }

  void addNode(Component node) {
    addToNodesLayer(node);
    state.addNode(node);
  }

  void removeNode(Component node) {
    try {
      removeFromNodesLayer(node);
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
        resources: Resources(),
      );
    }
  }
}
