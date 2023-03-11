import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class DroneFactory extends Building {
  DroneFactory({
    required super.location,
    required super.inventory,
  }) : super(
          type: NodeType.drone_factory,
          resourcesRequired: [
            ResourceType.energy,
            ResourceType.iron_block,
            ResourceType.copper_block,
          ],
          resourcesProduced: ResourceType.drone,
          connections: [],
        );
}
