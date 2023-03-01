import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/producers/solar_panel.dart';
import 'package:tensionnode/components/game/transformers/coal_mine.dart';
import 'package:tensionnode/components/game/transformers/copper_mine.dart';
import 'package:tensionnode/components/game/transformers/copper_smelter.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_buildings.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_patches.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  final List<SolarPanel> solarPanels = [];
  final List<CoalMine> coalMines = [];
  final List<CopperMine> copperMines = [];
  final List<CopperSmelter> copperSmelters = [];
  final List<Node> allNodes = [];
  final Map<ResourceType, List<Patch>> patches = {};
  final Inventory inventory = Inventory();
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;

    patches[ResourceType.coal_ore] = [];
    patches[ResourceType.copper_ore] = [];
  }

  void addToInventory({
    required ResourceType resourceType,
    required int amount,
  }) {
    inventory.add(
      type: resourceType,
      amount: amount,
    );

    print(inventory);
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
    if (node is SolarPanel) {
      solarPanels.add(node);
    } else if (node is CoalMine) {
      coalMines.add(node);
    } else if (node is CopperMine) {
      copperMines.add(node);
    } else if (node is CopperSmelter) {
      copperSmelters.add(node);
    }

    allNodes.add(node);
  }

  void removeNode(Node node) {
    if (node is SolarPanel) {
      solarPanels.remove(node);
    } else if (node is CoalMine) {
      coalMines.remove(node);
    } else if (node is CopperMine) {
      copperMines.remove(node);
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
      buildings: JsonBuildings(
        solarPanels: solarPanels.map((e) => e.json).toList(),
        coalMines: coalMines.map((e) => e.json).toList(),
        copperMines: copperMines.map((e) => e.json).toList(),
        copperSmelters: copperSmelters.map((e) => e.json).toList(),
      ),
      patches: JsonPatches(
        coal: patches[ResourceType.coal_ore]!.map((e) => e.json).toList(),
        copper: patches[ResourceType.copper_ore]!.map((e) => e.json).toList(),
      ),
    );
  }
}
