import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CopperSmelter extends Building {
  CopperSmelter({
    required super.location,
    required super.inventory,
  }) : super(
          type: NodeType.copper_smelter,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.copper_ore,
          ],
          resourcesProduced: ResourceType.copper_block,
          droneConnections: [],
          droneTransfers: [],
        );
}
