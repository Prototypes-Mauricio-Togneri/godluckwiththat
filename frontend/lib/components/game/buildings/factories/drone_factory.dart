import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class DroneFactory extends Building {
  DroneFactory({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.drone_factory,
          resourceProduced: ResourceType.drone,
          drones: [],
          droneConnections: [],
          droneTransfers: [],
        );

  @override
  Drone? getAvailableDrone() {
    if (output > 0) {
      output--;

      return Drone();
    } else {
      return super.getAvailableDrone();
    }
  }
}
