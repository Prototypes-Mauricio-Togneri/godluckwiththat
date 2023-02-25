import 'package:flutter/services.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/menu_handler.dart';
import 'package:tensionnode/game/node_handler.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/types/node_type.dart';

class GameComponent extends BaseGameComponent with MenuHandler, NodeHandler {
  GameComponent(super.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    loadNodes();

    return super.onLoad();
  }

  @override
  void onKeyPressed(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      openMainMenu();
    } else if (key == LogicalKeyboardKey.space) {
      onShowDetails();
    }
  }

  void onShowDetails() {
    // TODO(momo): implement
  }

  @override
  void onMapClicked(Location location, bool controlPressed) {
    if (isDetailsMode) {
      removeMenuComponents();
      disableMode();
    }

    if (buildingMode) {
      final BuildingIndicator buildingIndicator =
          layerNodes.getComponent(BuildingIndicator);
      final Node? node = layerNodes.getNode(location);
      final MapTile tile = getTile(location);
      final NodeType type = buildingIndicator.type;

      if (node == null) {
        buildNode(
          location: location,
          type: type,
          tile: tile,
        );
      }
    }
  }
}
