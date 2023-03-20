import 'dart:async';
import 'package:flutter/services.dart';
import 'package:tensionplanet/components/base/building_indicator.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/component_extension.dart';
import 'package:tensionplanet/game/base_game_component.dart';
import 'package:tensionplanet/game/menu_handler.dart';
import 'package:tensionplanet/game/node_handler.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/models/map_tile.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/overlay/construct_overlay.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

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
      openBuildMenu();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final int constructions = state.constructions.length;

    if (constructions > 0) {
      constructionsCounter.text = 'Constructions: $constructions'.toUpperCase();
    } else {
      constructionsCounter.text = '';
    }
  }

  @override
  void onMapClicked(Location location) {
    closeMenu(name: ConstructOverlay.NAME);

    if (hasNodeSelected) {
      removeMenuComponents();
      disableMode();
    }

    if (isBuildingMode) {
      final BuildingIndicator buildingIndicator =
          layerNodes.getComponent(BuildingIndicator);
      final Node? node = layerNodes.getNode(location);
      final MapTile tile = getTile(location);
      final NodeType nodeType = buildingIndicator.nodeType;
      final ResourceType? resourceType = buildingIndicator.resourceType;
      final Patch? patch = state.patches.patchAt(location);

      if (node == null) {
        final bool built = buildConstructionNode(
          nodeType: nodeType,
          resourceType: resourceType,
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
