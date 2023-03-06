import 'package:flutter/services.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/menu_handler.dart';
import 'package:tensionnode/game/node_handler.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/types/node_type.dart';

class GameComponent extends BaseGameComponent with MenuHandler, NodeHandler {
  GameComponent(super.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    loadNodes(state.jsonMatch);

    return super.onLoad();
  }

  @override
  void onKeyPressed(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      if (isCancellable) {
        onCancelOperation();
      } else {
        openMainMenu();
      }
    } else if (key == LogicalKeyboardKey.space) {
      onShowDetails();
    }
  }

  void onShowDetails() {
    // TODO(momo): implement
  }

  @override
  void onMapClicked(Location location) {
    if (hasNodeSelected) {
      removeMenuComponents();
      disableMode();
    }

    if (isBuildingMode) {
      final BuildingIndicator buildingIndicator =
          layerNodes.getComponent(BuildingIndicator);
      final Node? node = layerNodes.getNode(location);
      final MapTile tile = getTile(location);
      final NodeType type = buildingIndicator.type;
      final Patch? patch = state.patches.patchAt(location);

      if (node == null) {
        final bool built = buildConstructionNode(
          type: type,
          location: location,
          tile: tile,
          patch: patch,
        );

        if (built && !isControlPressed) {
          onCancelOperation();
        }
      }
    }
  }
}
