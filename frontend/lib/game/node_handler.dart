import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/sprite_group.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/producers/crop_farm.dart';
import 'package:tensionnode/components/game/producers/fisher.dart';
import 'package:tensionnode/components/game/producers/hunter.dart';
import 'package:tensionnode/components/game/producers/quarry.dart';
import 'package:tensionnode/components/game/producers/well.dart';
import 'package:tensionnode/components/game/producers/woodcutter.dart';
import 'package:tensionnode/components/game/transformers/bakery.dart';
import 'package:tensionnode/components/game/transformers/mill.dart';
import 'package:tensionnode/components/game/transformers/sawery.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/json/json_producer.dart';
import 'package:tensionnode/json/json_transformer.dart';
import 'package:tensionnode/models/connections.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/models/roads.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

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

    for (final JsonTransformer json in state.jsonMatch.saweries) {
      final Connections locations = json.connections.connections;

      final Node node = addSawery(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonTransformer json in state.jsonMatch.mills) {
      final Connections locations = json.connections.connections;

      final Node node = addMill(
        location: json.location.location,
      );
      state.resourceManager.graph.addNode(node);

      if (locations.isNotEmpty) {
        nodeConnections[node] = locations;
      }
    }

    for (final JsonTransformer json in state.jsonMatch.bakeries) {
      final Connections locations = json.connections.connections;

      final Node node = addBakery(
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

    _addSpriteGroup(Assets.IMAGES_PATHS_PATH1A);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH1B);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH1C);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH1D);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH2A);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH2B);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH3A);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH3B);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH3C);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH3D);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH4A);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH4B);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH4C);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH4D);
    _addSpriteGroup(Assets.IMAGES_PATHS_PATH5A);

    reloadPaths();
  }

  void _addSpriteGroup(String sprite) {
    final SpriteGroup spriteGroup = SpriteGroup(sprite);
    spriteGroups[sprite] = spriteGroup;
    addToPathsLayer(spriteGroup);
  }

  void reloadPaths() {
    final Set<Location> locations = {};

    for (final Node node in state.allNodes) {
      locations.addAll(_pathLocations(node.roads));
    }

    spriteGroups[Assets.IMAGES_PATHS_PATH5A]!.load(locations.toList());
  }

  Set<Location> _pathLocations(Roads roads) {
    final Set<Location> result = {};

    if (roads.north != null) {
      final Location origin = roads.north!.origin.location;
      final Location target = roads.north!.target.location;
      result.addAll(_intermediateLocations(origin, target));
    }

    if (roads.south != null) {
      final Location origin = roads.south!.origin.location;
      final Location target = roads.south!.target.location;
      result.addAll(_intermediateLocations(origin, target));
    }

    if (roads.east != null) {
      final Location origin = roads.east!.origin.location;
      final Location target = roads.east!.target.location;
      result.addAll(_intermediateLocations(origin, target));
    }

    if (roads.west != null) {
      final Location origin = roads.west!.origin.location;
      final Location target = roads.west!.target.location;
      result.addAll(_intermediateLocations(origin, target));
    }

    return result;
  }

  Set<Location> _intermediateLocations(Location origin, Location target) {
    final Set<Location> result = {};

    if (origin.i == target.i) {
      if (origin.j > target.j) {
        for (int j = target.j; j <= origin.j; j++) {
          result.add(Location(origin.i, j));
        }
      } else {
        for (int j = origin.j; j <= target.j; j++) {
          result.add(Location(origin.i, j));
        }
      }
    } else if (origin.j == target.j) {
      if (origin.i > target.i) {
        for (int i = target.i; i <= origin.i; i++) {
          result.add(Location(i, origin.j));
        }
      } else {
        for (int i = origin.i; i <= target.i; i++) {
          result.add(Location(i, origin.j));
        }
      }
    } else {
      throw Exception(
          'Path extremes are not aligned. Origin: $origin. Target: $target');
    }

    return result;
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
        location: location,
      ));

  Node addQuarry({
    required Location location,
  }) =>
      addNode(Quarry(
        location: location,
      ));

  Node addWell({
    required Location location,
  }) =>
      addNode(Well(
        location: location,
      ));

  Node addFisher({
    required Location location,
  }) =>
      addNode(Fisher(
        location: location,
      ));

  Node addHunter({
    required Location location,
  }) =>
      addNode(Hunter(
        location: location,
      ));

  Node addCropFarms({
    required Location location,
  }) =>
      addNode(CropFarm(
        location: location,
      ));

  Node addSawery({
    required Location location,
  }) =>
      addNode(Sawery(
        location: location,
        resourcesRequired: [
          ResourceType.timber,
        ],
      ));

  Node addMill({
    required Location location,
  }) =>
      addNode(Mill(
        location: location,
        resourcesRequired: [
          ResourceType.grain,
        ],
      ));

  Node addBakery({
    required Location location,
  }) =>
      addNode(Bakery(
        location: location,
        resourcesRequired: [
          ResourceType.flour,
          ResourceType.water,
        ],
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

  void removeNode(Node node) {
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
