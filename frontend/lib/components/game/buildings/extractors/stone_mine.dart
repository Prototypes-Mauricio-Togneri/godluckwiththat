import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class StoneMine extends Building {
  StoneMine({
    required super.location,
    required super.inventory,
  }) : super(
          type: NodeType.stone_mine,
          resourcesRequired: [ResourceType.energy],
          resourcesProduced: ResourceType.stone_ore,
          droneConnections: [],
          droneTransfers: [],
        );
}
