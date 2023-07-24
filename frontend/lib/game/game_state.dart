import 'package:dafluta/dafluta.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class GameState extends BaseState {
  int turn = 1;
  num totalTimeElapsed = 0;

  final int mapWidth = 4;
  final int mapHeight = 4;

  final JsonMatch jsonMatch;
  final List<Zone> zones = [];
  late final Colony colony;

  Zone? selectedZone;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    zones.addAll(Constants.zones());

    colony = Colony(
      owner: Constants.PLAYER_OWNER,
      color: Constants.PLAYER_COLOR,
      inventory: Inventory.fromResourceMap({
        ResourceType.villager: 5,
        ResourceType.food: 40,
        ResourceType.wood: 50,
      }),
      zones: zones,
      freeVillagers: 5,
    );
  }

  Zone zoneById(String id) {
    for (final Zone zone in zones) {
      if (zone.id == id) {
        return zone;
      }
    }

    throw Exception('Zone with id $id not found');
  }

  void onZoneClicked(Zone zone) {
    if (selectedZone != zone) {
      selectedZone = zone;
    } else {
      selectedZone = null;
    }

    notify();
  }

  void onPassTurn() {}

  void onOpenMainMenu() {}

  JsonMatch get json => JsonMatch(
        version: jsonMatch.version,
        id: jsonMatch.id,
        totalTimeElapsed: totalTimeElapsed,
        level: jsonMatch.level,
        map: jsonMatch.map,
        zones: zones.map((z) => z.json).toList(),
        colonies: [],
      );
}
