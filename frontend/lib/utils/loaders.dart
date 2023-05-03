import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/zone.dart';

class Loaders {
  static Colony colony(JsonColony jsonColony) => Colony(
        owner: jsonColony.owner,
        inventory: Inventory.fromJson(jsonColony.inventory),
        zones: [],
        freeVillagers: jsonColony.freeVillagers,
      );

  static Zone zone(JsonZone jsonZone) {
    final Zone zone = Zone(
      id: jsonZone.id,
      x: jsonZone.x,
      y: jsonZone.y,
      owner: jsonZone.owner,
      patches: [],
      constructions: [],
      status: jsonZone.status,
    );

    for (final JsonPatch jsonPatch in jsonZone.patches) {
      zone.patches.add(Patch(
        patchType: jsonPatch.patchType,
        location: jsonPatch.location,
        building: building(jsonPatch),
      ));
    }

    return zone;
  }

  static Building? building(JsonPatch jsonPatch) {
    if (jsonPatch.building != null) {
      return Building.create(
        buildingType: jsonPatch.building!.buildingType,
        level: jsonPatch.building!.level,
        workers: jsonPatch.building!.workers,
      );
    } else {
      return null;
    }
  }
}
