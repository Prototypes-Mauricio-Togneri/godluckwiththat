import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/buildings/coal_mine.dart';
import 'package:tensionnode/components/game/buildings/copper_mine.dart';
import 'package:tensionnode/components/game/buildings/copper_smelter.dart';
import 'package:tensionnode/components/game/buildings/iron_mine.dart';
import 'package:tensionnode/components/game/buildings/solar_panel.dart';
import 'package:tensionnode/components/game/buildings/stone_mine.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
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

  Headquarters? headquarters;
  final List<Construction> constructions = [];
  final List<SolarPanel> solarPanels = [];
  final List<IronMine> ironMines = [];
  final List<CopperMine> copperMines = [];
  final List<CoalMine> coalMines = [];
  final List<StoneMine> stoneMines = [];
  final List<CopperSmelter> copperSmelters = [];
  final List<Node> allNodes = [];
  final Map<ResourceType, List<Patch>> patches = {};
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;

    patches[ResourceType.coal_ore] = [];
    patches[ResourceType.copper_ore] = [];
  }

  List<Location> patchLocations(ResourceType type) =>
      patches[type]!.map((e) => e.location).toList();

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
      patches: JsonPatches(
        iron: patches[ResourceType.iron_ore]!.map((e) => e.json).toList(),
        copper: patches[ResourceType.copper_ore]!.map((e) => e.json).toList(),
        coal: patches[ResourceType.coal_ore]!.map((e) => e.json).toList(),
        stone: patches[ResourceType.stone_ore]!.map((e) => e.json).toList(),
      ),
      headquarters: headquarters!.json,
      buildings: JsonBuildings(
        solarPanels: solarPanels.map((e) => e.json).toList(),
        ironMines: ironMines.map((e) => e.json).toList(),
        copperMines: copperMines.map((e) => e.json).toList(),
        coalMines: coalMines.map((e) => e.json).toList(),
        stoneMines: stoneMines.map((e) => e.json).toList(),
        copperSmelters: copperSmelters.map((e) => e.json).toList(),
      ),
    );
  }
}
