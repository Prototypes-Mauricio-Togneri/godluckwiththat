import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/patches.dart';
import 'package:tensionnode/models/research.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/utils/map_list.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  Headquarters? headquarters;
  final List<Construction> constructions = [];
  final MapList<NodeType, Building> buildings = MapList();
  final List<Node> allNodes = [];
  final Research research = Research();
  late final Patches patches;
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;
    patches = jsonMatch.patches.patches;
  }

  void setLoaded() {
    loaded = true;
    notify();
  }

  void update(double dt) {
    _totalTimeElapsed += dt;
  }

  Node nodeAt(Location location) {
    for (final Node node in allNodes) {
      if (node.isAt(location)) {
        return node;
      }
    }

    throw Exception('Node at $location cannot be found');
  }

  /*bool _hasNodeAt(Location location) {
    for (final Node node in allNodes) {
      if (node.isAt(location)) {
        return true;
      }
    }

    return false;
  }*/

  void addNode(Node node) {
    if (node is Headquarters) {
      headquarters = node;
    } else if (node is Construction) {
      constructions.add(node);
    } else if (node is Building) {
      buildings.add(node.type, node);
    }

    allNodes.add(node);
  }

  void removeNode(Node node) {
    if (node is Construction) {
      constructions.remove(node);
    } else if (node is Building) {
      buildings.remove(node.type, node);
    }

    allNodes.remove(node);
  }

  JsonMatch getMatch(Camera camera) {
    final Map<NodeType, List<JsonBuilding>> jsonBuildings = {};

    for (final NodeType type in buildings.keys) {
      jsonBuildings[type] = buildings.get(type).map((e) => e.json).toList();
    }

    return JsonMatch(
      version: jsonMatch.version,
      id: jsonMatch.id,
      totalTimeElapsed: _totalTimeElapsed.decimal(),
      map: jsonMatch.map.withCamera(camera),
      patches: patches.json,
      headquarters: headquarters!.json,
      buildings: jsonBuildings,
    );
  }
}
