import 'package:flutter/material.dart';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/zone_type.dart';

class Loaders {
  static Colony colony(JsonColony jsonColony) => Colony(
        owner: jsonColony.owner,
        color: Colors.blue,
        inventory: Inventory.fromJson(jsonColony.inventory),
        zones: [],
        freeVillagers: jsonColony.freeVillagers,
      );

  static Zone zone(JsonZone jsonZone, Colony? colony) {
    final Zone zone = Zone(
      x: 0,
      y: 0,
      zoneType: ZoneType.grass,
      patch: null,
      actions: [],
      owner: '',
      building: null,
      status: jsonZone.status,
    );

    /*for (final JsonPatch jsonPatch in jsonZone.patches) {
      zone.patches.add(Patch(
        patchType: jsonPatch.patchType,
        building: building(jsonPatch),
      ));
    }*/

    return zone;
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
