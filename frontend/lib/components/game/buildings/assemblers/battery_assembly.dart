import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class BatteryAssembly extends Building {
  BatteryAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.battery_assembly,
        );
}
