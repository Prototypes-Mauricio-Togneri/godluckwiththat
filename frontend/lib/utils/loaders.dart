import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/island.dart';
import 'package:gatewayguardians/models/player.dart';

class Loaders {
  static Colony colony(JsonColony jsonColony) => Colony(
        owner: Player.you(),
        inventory: Inventory.fromJson(jsonColony.inventory),
        freeVillagers: jsonColony.freeVillagers,
      );

  static Island island(JsonZone jsonZone, Colony? colony) {
    final Island island = Island(
      id: '',
      tiles: [],
      actions: [],
      owner: null,
      buildings: [],
      patches: [],
    );

    /*for (final JsonPatch jsonPatch in jsonZone.patches) {
      island.patches.add(Patch(
        patchType: jsonPatch.patchType,
        building: building(jsonPatch),
      ));
    }*/

    return island;
  }

  static Building? building(JsonPatch jsonPatch) {
    if (jsonPatch.building != null) {
      return Building.create(
        buildingType: jsonPatch.building!.buildingType,
        level: jsonPatch.building!.level,
        villagers: jsonPatch.building!.workers,
      );
    } else {
      return null;
    }
  }
}
