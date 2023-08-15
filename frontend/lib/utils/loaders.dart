import 'package:godluckwiththat/json/json_colony.dart';
import 'package:godluckwiththat/json/json_patch.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory.dart';

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
