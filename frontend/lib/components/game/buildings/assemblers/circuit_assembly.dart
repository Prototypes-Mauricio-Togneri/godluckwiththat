import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class CircuitAssembly extends Building {
  CircuitAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.circuit_assembly,
        );
}
