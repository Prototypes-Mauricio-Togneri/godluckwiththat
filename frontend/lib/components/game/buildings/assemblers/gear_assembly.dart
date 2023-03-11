import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GearAssembly extends Building {
  GearAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.gear_assembly,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.steel,
          ],
          resourcesProduced: ResourceType.gear,
        );
}
