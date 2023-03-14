import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class GearAssembly extends Building {
  GearAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.gear_assembly,
        );
}
