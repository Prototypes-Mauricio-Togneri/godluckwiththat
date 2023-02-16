import 'package:flutter/services.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/menu_handler.dart';
import 'package:tensionnode/game/node_handler.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/types/node_type.dart';

class GameComponent extends BaseGameComponent with MenuHandler, NodeHandler {
  GameComponent(super.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    final JsonHeadquarters json = state.jsonMatch.headquarters;

    addHeadquarters(
      location: json.location.location,
      inventory: json.inventory.inventory,
    );

    for (final JsonWoodcutter json in state.jsonMatch.woodcutters) {
      final Road? roadNorth = roadTo(json.roadNorth);
      final Road? roadEast = roadTo(json.roadEast);
      final Road? roadSouth = roadTo(json.roadSouth);
      final Road? roadWest = roadTo(json.roadWest);

      addWoodcutter(
        location: json.location.location,
        roadNorth: roadNorth,
        roadEast: roadEast,
        roadSouth: roadSouth,
        roadWest: roadWest,
      );
    }

    for (final JsonFlag json in state.jsonMatch.flags) {
      addFlag(
        location: json.location.location,
        inventory: json.inventory.inventory,
      );
    }

    return super.onLoad();
  }

  Road? roadTo(JsonLocation? location) =>
      (location != null) ? Road(state.nodeAt(location.location)!) : null;

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
  void onMapClicked(Location location) {
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
        build(
          location: location,
          type: type,
          tile: tile,
        );
      }
    }
  }
}
