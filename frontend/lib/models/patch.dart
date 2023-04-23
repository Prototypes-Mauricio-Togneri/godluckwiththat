import 'package:gatewayguardians/types/patch_location.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Patch {
  final ResourceType resourceType;
  final PatchLocation location;

  const Patch({
    required this.resourceType,
    required this.location,
  });
}
