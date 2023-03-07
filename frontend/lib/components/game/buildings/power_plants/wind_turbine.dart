import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class WindTurbine extends Building {
  WindTurbine({
    required super.location,
    required super.inventory,
  }) : super(
          type: NodeType.wind_turbine,
          resourcesRequired: [],
          resourcesProduced: ResourceType.energy,
          drones: [],
          droneConnections: [],
          droneTransfers: [],
        );

  @override
  int get outputGeneration => 5;
}
