import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';

class Patch {
  final PatchType patchType;
  final ZoneLocation location;
  final Building? building;

  const Patch({
    required this.patchType,
    required this.location,
    required this.building,
  });

  bool get hasBuilding => building != null;

  void update(double dt) {
    building?.update(dt);
  }

  bool has<T>(T type) => building?.buildingType is T;
}
