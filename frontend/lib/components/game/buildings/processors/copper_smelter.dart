import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class CopperSmelter extends Building {
  CopperSmelter({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.copper_smelter,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.copper_ore,
          ],
          resourcesProduced: ResourceType.copper_block,
        );
}
