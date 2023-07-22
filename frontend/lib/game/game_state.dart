import 'package:dafluta/dafluta.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/types/zone_type.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;

  final int mapSize = 7;

  final JsonMatch jsonMatch;
  final List<Zone> zones = [];
  late final Colony colony;

  Zone? selectedZone;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    zones.add(Zone(
      x: 0,
      y: 0,
      zoneType: ZoneType.grass,
      patches: [],
      owner: null,
      building: null,
      status: ZoneStatus.unexplored,
    ));

    colony = Colony(
      owner: Constants.PLAYER_OWNER,
      color: Constants.PLAYER_COLOR,
      inventory: Inventory.empty(),
      zones: zones,
      freeVillagers: 5,
    );
  }

  Zone? zoneById(String id) {
    for (final Zone zone in zones) {
      if (zone.id == id) {
        return zone;
      }
    }

    return null;
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
