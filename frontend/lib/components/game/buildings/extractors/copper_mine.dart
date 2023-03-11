import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class CopperMine extends Building {
  CopperMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.copper_mine,
          resourcesRequired: [ResourceType.energy],
          resourcesProduced: ResourceType.copper_ore,
        );
}
