import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/sawmill.dart';
import 'package:tensionnode/components/game/woodcutter.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/json/json_sawmill.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/models/connections.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/models/roads.dart';
import 'package:tensionnode/types/node_type.dart';

mixin NodeHandler on BaseGameComponent {
  void loadNodes() {
    final Map<Node, Connections> nodeConnections = {};

    final JsonHeadquarters json = state.jsonMatch.headquarters;
    final Connections connections = json.connections.connections;

    final Node node = addHeadquarters(
      location: json.location.location,
      inventory: json.inventory.inventory,
    );
    state.graph.addNode(node);

    if (connections.isNotEmpty) {
      nodeConnections[node] = connections;
    }

    for (final JsonWoodcutter json in state.jsonMatch.woodcutters) {
      final Connections locations = json.connections.connections;

      final Node node = addWoodcutter(
        location: json.location.location,
      );
      state.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonSawmill json in state.jsonMatch.sawmills) {
      final Connections locations = json.connections.connections;

      final Node node = addSawmill(
        location: json.location.location,
      );
      state.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonFlag json in state.jsonMatch.flags) {
      final Connections locations = json.connections.connections;

      final Node node = addFlag(
        location: json.location.location,
      );
      state.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final MapEntry<Node, Connections> entry in nodeConnections.entries) {
      final Road? roadNorth = _roadTo(entry.key, entry.value.north);
      final Road? roadEast = _roadTo(entry.key, entry.value.east);
      final Road? roadSouth = _roadTo(entry.key, entry.value.south);
      final Road? roadWest = _roadTo(entry.key, entry.value.west);

      if (roadNorth != null) {
        state.graph.addConnection(roadNorth.origin, roadNorth.target);
      }

      if (roadEast != null) {
        state.graph.addConnection(roadEast.origin, roadEast.target);
      }

      if (roadSouth != null) {
        state.graph.addConnection(roadSouth.origin, roadSouth.target);
      }

      if (roadWest != null) {
        state.graph.addConnection(roadWest.origin, roadWest.target);
      }

      entry.key.connect(Roads(
        north: roadNorth,
        east: roadEast,
        south: roadSouth,
        west: roadWest,
      ));
    }

    print(state.graph);
  }

  Road? _roadTo(Node origin, Location? location) =>
      (location != null) ? Road(origin, state.nodeAt(location)!) : null;

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
