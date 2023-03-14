import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class CopperMine extends Building {
  CopperMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.copper_mine,
        );
}
