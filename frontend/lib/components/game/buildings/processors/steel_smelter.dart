import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class SteelSmelter extends Building {
  SteelSmelter({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.steel_smelter,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.iron_block,
            ResourceType.coal_ore,
          ],
          resourcesProduced: ResourceType.steel,
        );
}
