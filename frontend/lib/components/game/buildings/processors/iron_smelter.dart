import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class IronSmelter extends Building {
  IronSmelter({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.iron_smelter,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.iron_ore,
          ],
          resourcesProduced: ResourceType.iron_block,
        );
}
