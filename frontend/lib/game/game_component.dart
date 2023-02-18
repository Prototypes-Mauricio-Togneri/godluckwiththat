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
import 'package:tensionnode/json/json_sawmill.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/models/connections.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/models/roads.dart';
import 'package:tensionnode/types/node_type.dart';

class GameComponent extends BaseGameComponent with MenuHandler, NodeHandler {
  GameComponent(super.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    final Map<Node, Connections> nodeConnections = {};

    final JsonHeadquarters json = state.jsonMatch.headquarters;
    final Connections connections = json.connections.connections;

    final Node node = addHeadquarters(
      location: json.location.location,
      inventory: json.inventory.inventory,
    );

    if (connections.isNotEmpty) {
      nodeConnections[node] = connections;
    }

    for (final JsonWoodcutter json in state.jsonMatch.woodcutters) {
      final Connections locations = json.connections.connections;

      final Node node = addWoodcutter(
        location: json.location.location,
      );

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonSawmill json in state.jsonMatch.sawmills) {
      final Connections locations = json.connections.connections;

      final Node node = addSawmill(
        location: json.location.location,
      );

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonFlag json in state.jsonMatch.flags) {
      final Connections locations = json.connections.connections;

      final Node node = addFlag(
        location: json.location.location,
      );

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final MapEntry<Node, Connections> entry in nodeConnections.entries) {
      final Road? roadNorth = _roadTo(entry.key, entry.value.north);
      final Road? roadEast = _roadTo(entry.key, entry.value.east);
      final Road? roadSouth = _roadTo(entry.key, entry.value.south);
      final Road? roadWest = _roadTo(entry.key, entry.value.west);

      entry.key.connect(Roads(
        north: roadNorth,
        east: roadEast,
        south: roadSouth,
        west: roadWest,
      ));
    }

    return super.onLoad();
  }

  Road? _roadTo(Node origin, Location? location) =>
      (location != null) ? Road(origin, state.nodeAt(location)!) : null;

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
