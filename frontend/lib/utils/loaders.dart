import 'package:flutter/material.dart';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/island.dart';

class Loaders {
  static Colony colony(JsonColony jsonColony) => Colony(
        owner: jsonColony.owner,
        color: Colors.blue,
        inventory: Inventory.fromJson(jsonColony.inventory),
        freeVillagers: jsonColony.freeVillagers,
      );

  static Island island(JsonZone jsonZone, Colony? colony) {
    final Island island = Island(
      id: '',
      tiles: [],
      actions: [],
      owner: '',
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
