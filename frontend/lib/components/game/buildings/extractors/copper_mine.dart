import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CopperMine extends Building {
  CopperMine({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.copper_mine,
          resourceProduced: ResourceType.copper_ore,
          drones: [],
          droneConnections: [],
          droneTransfers: [],
        );
}
