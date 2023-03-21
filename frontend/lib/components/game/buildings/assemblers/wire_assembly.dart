import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class WireAssembly extends Building {
  WireAssembly({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.wire_assembly,
        );
}
