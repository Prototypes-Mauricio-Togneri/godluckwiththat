import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/producers/coal_mine.dart';
import 'package:tensionnode/components/game/producers/cooper_mine.dart';
import 'package:tensionnode/components/game/transformers/cooper_furnace.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_buildings.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_patches.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  final List<CoalMine> coalMines = [];
  final List<CooperMine> cooperMines = [];
  final List<CooperFurnace> cooperFurnaces = [];
  final List<Node> allNodes = [];
  final Map<ResourceType, List<Patch>> patches = {};
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;
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
    if (node is CoalMine) {
      coalMines.add(node);
    } else if (node is CooperMine) {
      cooperMines.add(node);
    } else if (node is CooperFurnace) {
      cooperFurnaces.add(node);
    }

    allNodes.add(node);
  }

  void removeNode(Node node) {
    if (node is CoalMine) {
      coalMines.remove(node);
    } else if (node is CooperMine) {
      cooperMines.remove(node);
    } else if (node is CooperFurnace) {
      cooperFurnaces.remove(node);
    }

    allNodes.remove(node);
  }

  JsonMatch getMatch(Camera camera) {
    return JsonMatch(
      version: jsonMatch.version,
      id: jsonMatch.id,
      totalTimeElapsed: _totalTimeElapsed.decimal(),
      map: jsonMatch.map.withCamera(camera),
      buildings: JsonBuildings(
        coalMines: coalMines.map((e) => e.json).toList(),
        cooperMines: cooperMines.map((e) => e.json).toList(),
        cooperFurnaces: cooperFurnaces.map((e) => e.json).toList(),
      ),
      patches: JsonPatches(
        coal: patches[ResourceType.coal_ore]!.map((e) => e.json).toList(),
        cooper: patches[ResourceType.cooper_ore]!.map((e) => e.json).toList(),
      ),
    );
  }
}
