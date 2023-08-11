import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';

class Loaders {
  static Colony colony(JsonColony jsonColony) => Colony(
        inventory: Inventory.fromJson(jsonColony.inventory),
        buildings: [],
        freeVillagers: jsonColony.freeVillagers,
      );

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
