import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';

class Patch {
  final PatchType patchType;
  final ZoneLocation location;

  const Patch({
    required this.patchType,
    required this.location,
  });
}
