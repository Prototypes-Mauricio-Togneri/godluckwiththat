import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class IronMine extends Building {
  IronMine({
    required super.location,
    required super.inventory,
  }) : super(
          type: NodeType.iron_mine,
          resourcesRequired: [ResourceType.energy],
          resourcesProduced: ResourceType.iron_ore,
          droneConnections: [],
          droneTransfers: [],
        );
}
