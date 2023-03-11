import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class OilRig extends Building {
  OilRig({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.oil_rig,
          resourcesRequired: [ResourceType.energy],
          resourcesProduced: ResourceType.oil,
        );
}
