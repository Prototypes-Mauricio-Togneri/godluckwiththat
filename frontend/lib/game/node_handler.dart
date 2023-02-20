import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/producers/crop_farm.dart';
import 'package:tensionnode/components/game/producers/fisher.dart';
import 'package:tensionnode/components/game/producers/hunter.dart';
import 'package:tensionnode/components/game/producers/quarry.dart';
import 'package:tensionnode/components/game/producers/well.dart';
import 'package:tensionnode/components/game/producers/woodcutter.dart';
import 'package:tensionnode/components/game/transformers/mill.dart';
import 'package:tensionnode/components/game/transformers/sawmill.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/json/json_mill.dart';
import 'package:tensionnode/json/json_producer.dart';
import 'package:tensionnode/json/json_sawmill.dart';
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
    state.resourceManager.graph.addNode(node);

    if (connections.isNotEmpty) {
      nodeConnections[node] = connections;
    }

    for (final JsonProducer json in state.jsonMatch.woodcutters) {
      final Connections locations = json.connections.connections;

      final Node node = addWoodcutter(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonProducer json in state.jsonMatch.quarries) {
      final Connections locations = json.connections.connections;

      final Node node = addQuarry(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonProducer json in state.jsonMatch.wells) {
      final Connections locations = json.connections.connections;

      final Node node = addWell(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonProducer json in state.jsonMatch.fishers) {
      final Connections locations = json.connections.connections;

      final Node node = addFisher(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonProducer json in state.jsonMatch.hunters) {
      final Connections locations = json.connections.connections;

      final Node node = addHunter(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonProducer json in state.jsonMatch.cropFarms) {
      final Connections locations = json.connections.connections;

      final Node node = addCropFarms(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonSawmill json in state.jsonMatch.sawmills) {
      final Connections locations = json.connections.connections;

      final Node node = addSawmill(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonMill json in state.jsonMatch.mills) {
      final Connections locations = json.connections.connections;

      final Node node = addMill(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonFlag json in state.jsonMatch.flags) {
      final Connections locations = json.connections.connections;

      final Node node = addFlag(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

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
        state.resourceManager.graph
            .addConnection(roadNorth.origin, roadNorth.target);
      }

      if (roadEast != null) {
        state.resourceManager.graph
            .addConnection(roadEast.origin, roadEast.target);
      }

      if (roadSouth != null) {
        state.resourceManager.graph
            .addConnection(roadSouth.origin, roadSouth.target);
      }

      if (roadWest != null) {
        state.resourceManager.graph
            .addConnection(roadWest.origin, roadWest.target);
      }

      entry.key.connect(Roads(
        north: roadNorth,
        east: roadEast,
        south: roadSouth,
        west: roadWest,
      ));
    }
  }

  Road? _roadTo(Node origin, Location? location) =>
      (location != null) ? Road(origin, state.nodeAt(location)) : null;

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

  Node addQuarry({
    required Location location,
  }) =>
      addNode(Quarry(
        type: NodeType.quarry,
        location: location,
      ));

  Node addWell({
    required Location location,
  }) =>
      addNode(Well(
        type: NodeType.well,
        location: location,
      ));

  Node addFisher({
    required Location location,
  }) =>
      addNode(Fisher(
        type: NodeType.fisher,
        location: location,
      ));

  Node addHunter({
    required Location location,
  }) =>
      addNode(Hunter(
        type: NodeType.hunter,
        location: location,
      ));

  Node addCropFarms({
    required Location location,
  }) =>
      addNode(CropFarm(
        type: NodeType.crop_farm,
        location: location,
      ));

  Node addSawmill({
    required Location location,
  }) =>
      addNode(Sawmill(
        type: NodeType.sawmill,
        location: location,
      ));

  Node addMill({
    required Location location,
  }) =>
      addNode(Mill(
        type: NodeType.mill,
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
