import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class SolarPanel extends Building {
  SolarPanel({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.solar_panel,
          resourcesRequired: [],
          resourcesProduced: ResourceType.energy,
        );
}
