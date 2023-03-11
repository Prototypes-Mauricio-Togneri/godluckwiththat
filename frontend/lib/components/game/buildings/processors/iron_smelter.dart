import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class IronSmelter extends Building {
  IronSmelter({
    required super.location,
    required super.inventory,
  }) : super(
          type: NodeType.iron_smelter,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.iron_ore,
          ],
          resourcesProduced: ResourceType.iron_block,
          connections: [],
        );
}
