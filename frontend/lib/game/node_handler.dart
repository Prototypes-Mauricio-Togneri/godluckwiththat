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
import 'package:tensionnode/models/new_path.dart';
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

      final Node node = addCropFarm(
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

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH1A,
      north: false,
      south: true,
      east: false,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH1B,
      north: false,
      south: false,
      east: false,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH1C,
      north: true,
      south: false,
      east: false,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH1D,
      north: false,
      south: false,
      east: true,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH2A,
      north: true,
      south: true,
      east: false,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH2B,
      north: false,
      south: false,
      east: true,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH3A,
      north: false,
      south: true,
      east: false,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH3B,
      north: true,
      south: false,
      east: false,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH3C,
      north: true,
      south: false,
      east: true,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH3D,
      north: false,
      south: true,
      east: true,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH4A,
      north: true,
      south: false,
      east: true,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH4B,
      north: true,
      south: true,
      east: true,
      west: false,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH4C,
      north: false,
      south: true,
      east: true,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH4D,
      north: true,
      south: true,
      east: false,
      west: true,
    );

    _fillPaths(
      locations: locations,
      sprite: Assets.IMAGES_PATHS_PATH5A,
      north: true,
      south: true,
      east: true,
      west: true,
    );
  }

  void _fillPaths({
    required Set<Location> locations,
    required String sprite,
    required bool north,
    required bool south,
    required bool east,
    required bool west,
  }) {
    final Set<Location> list = _pathMatches(
      locations: locations,
      north: north,
      south: south,
      east: east,
      west: west,
    );

    spriteGroups[sprite]!.load(list.toList());
  }

  Set<Location> _pathMatches({
    required Set<Location> locations,
    required bool north,
    required bool south,
    required bool east,
    required bool west,
  }) {
    final Set<Location> result = {};

    for (final Location location in locations) {
      final bool hasNorth =
          locations.contains(Location(location.i, location.j - 1));
      final bool hasSouth =
          locations.contains(Location(location.i, location.j + 1));
      final bool hasEast =
          locations.contains(Location(location.i + 1, location.j));
      final bool hasWest =
          locations.contains(Location(location.i - 1, location.j));

      if ((hasNorth == north) &&
          (hasSouth == south) &&
          (hasEast == east) &&
          (hasWest == west)) {
        result.add(location);
      }
    }

    return result;
  }

  Set<Location> _pathLocations(Roads roads) {
    final Set<Location> result = {};

    if (roads.north != null) {
      final Location origin = roads.north!.origin.location;
      final Location target = roads.north!.target.location;
      final NewPath newPath = NewPath(origin, target);
      result.addAll(newPath.intermediateLocations);
    }

    if (roads.south != null) {
      final Location origin = roads.south!.origin.location;
      final Location target = roads.south!.target.location;
      final NewPath newPath = NewPath(origin, target);
      result.addAll(newPath.intermediateLocations);
    }

    if (roads.east != null) {
      final Location origin = roads.east!.origin.location;
      final Location target = roads.east!.target.location;
      final NewPath newPath = NewPath(origin, target);
      result.addAll(newPath.intermediateLocations);
    }

    if (roads.west != null) {
      final Location origin = roads.west!.origin.location;
      final Location target = roads.west!.target.location;
      final NewPath newPath = NewPath(origin, target);
      result.addAll(newPath.intermediateLocations);
    }

    return result;
  }

  Road? _roadTo(Node origin, Location? location) {
    if (location != null) {
      final Node? node = state.nodeAt(location);

      if (node != null) {
        return Road(origin, node);
      } else {
        throw Exception('Node at $location cannot be found');
      }
    } else {
      return null;
    }
  }

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

  Node addCropFarm({
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
    switch (type) {
      case NodeType.flag:
        addFlag(location: location);
        // TODO(momo): create connections and re-render
        break;
      case NodeType.headquarters:
        break;
      case NodeType.woodcutter:
        if (tile.isForest) {
          addWoodcutter(location: location);
        }
        break;
      case NodeType.quarry:
        if (tile.isStone) {
          addQuarry(location: location);
        }
        break;
      case NodeType.well:
        if (tile.isGrass) {
          addWell(location: location);
        }
        break;
      case NodeType.fisher:
        if (tile.isGrass) {
          addFisher(location: location);
        }
        break;
      case NodeType.hunter:
        if (tile.isForest) {
          addHunter(location: location);
        }
        break;
      case NodeType.crop_farm:
        if (tile.isGrass) {
          addCropFarm(location: location);
        }
        break;
      case NodeType.mill:
        if (tile.isGrass) {
          addMill(location: location);
        }
        break;
      case NodeType.bakery:
        if (tile.isGrass) {
          addBakery(location: location);
        }
        break;
      case NodeType.sawery:
        if (tile.isGrass) {
          addSawery(location: location);
        }
        break;
    }
  }
}
