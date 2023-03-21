import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class MotorAssembly extends Building {
  MotorAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.motor_assembly,
        );
}
