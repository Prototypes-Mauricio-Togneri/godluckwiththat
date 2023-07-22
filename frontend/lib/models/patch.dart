import 'package:gatewayguardians/json/json_building.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';

class Patch {
  final PatchType patchType;
  Building? building;

  Patch({
    required this.patchType,
    required this.building,
  });

  bool get hasBuilding => building != null;

  Zone get zone {
    /*for (final Zone zone in GameState.instance.zones) {
      if (zone.patches.contains(this)) {
        return zone;
      }
    }*/
    throw Exception('Zone not found for patch a');
  }

  void update(double dt) {
    building?.update(dt);
  }

  bool has(BuildingType type) => building?.buildingType == type;

  void destroyBuilding() {
    //GameState.instance.colony.freeVillagers += building!.workers;
    building = null;
  }

  JsonPatch get json => JsonPatch(
        patchType: patchType,
        building: (building != null)
            ? JsonBuilding(
                buildingType: building!.buildingType,
                level: building!.level,
                workers: building!.workers,
              )
            : null,
      );
}
