import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/resource.dart';
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
          drones: [],
          droneConnections: [],
          droneTransfers: [],
        );

  @override
  Drone? getAvailableDrone() {
    final Resource resource = Resource.one(ResourceType.drone);

    if (inventory.hasResource(resource)) {
      inventory.removeResource(resource);

      return Drone();
    } else {
      return super.getAvailableDrone();
    }
  }
}
