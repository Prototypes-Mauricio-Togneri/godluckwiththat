import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class TransistorAssembly extends Building {
  TransistorAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.transistor_assembly,
        );
}
