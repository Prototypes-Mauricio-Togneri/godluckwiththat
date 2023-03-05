import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/buildings/energy/solar_panel.dart';
import 'package:tensionnode/components/game/buildings/extractors/coal_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/copper_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/iron_mine.dart';
import 'package:tensionnode/components/game/buildings/extractors/stone_mine.dart';
import 'package:tensionnode/components/game/buildings/transformers/copper_smelter.dart';
import 'package:tensionnode/components/game/buildings/transformers/iron_smelter.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_buildings.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/patches.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  Headquarters? headquarters;
  final List<Construction> constructions = [];
  final List<SolarPanel> solarPanels = [];
  final List<IronMine> ironMines = [];
  final List<CopperMine> copperMines = [];
  final List<CoalMine> coalMines = [];
  final List<StoneMine> stoneMines = [];
  final List<IronSmelter> ironSmelters = [];
  final List<CopperSmelter> copperSmelters = [];
  final List<Node> allNodes = [];
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
    } else if (node is SolarPanel) {
      solarPanels.add(node);
    } else if (node is IronMine) {
      ironMines.add(node);
    } else if (node is CopperMine) {
      copperMines.add(node);
    } else if (node is CoalMine) {
      coalMines.add(node);
    } else if (node is StoneMine) {
      stoneMines.add(node);
    } else if (node is IronSmelter) {
      ironSmelters.add(node);
    } else if (node is CopperSmelter) {
      copperSmelters.add(node);
    }

    allNodes.add(node);
  }

  void removeNode(Node node) {
    if (node is Construction) {
      constructions.remove(node);
    } else if (node is SolarPanel) {
      solarPanels.remove(node);
    } else if (node is IronMine) {
      ironMines.remove(node);
    } else if (node is CopperMine) {
      copperMines.remove(node);
    } else if (node is CoalMine) {
      coalMines.remove(node);
    } else if (node is StoneMine) {
      stoneMines.remove(node);
    } else if (node is IronSmelter) {
      ironSmelters.remove(node);
    } else if (node is CopperSmelter) {
      copperSmelters.remove(node);
    }

    allNodes.remove(node);
  }

  JsonMatch getMatch(Camera camera) {
    return JsonMatch(
      version: jsonMatch.version,
      id: jsonMatch.id,
      totalTimeElapsed: _totalTimeElapsed.decimal(),
      map: jsonMatch.map.withCamera(camera),
      patches: patches.json,
      headquarters: headquarters!.json,
      buildings: JsonBuildings(
        solarPanels: solarPanels.map((e) => e.json).toList(),
        ironMines: ironMines.map((e) => e.json).toList(),
        copperMines: copperMines.map((e) => e.json).toList(),
        coalMines: coalMines.map((e) => e.json).toList(),
        stoneMines: stoneMines.map((e) => e.json).toList(),
        ironSmelters: ironSmelters.map((e) => e.json).toList(),
        copperSmelters: copperSmelters.map((e) => e.json).toList(),
      ),
    );
  }
}
