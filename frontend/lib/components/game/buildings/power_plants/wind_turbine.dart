import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class WindTurbine extends Building {
  WindTurbine({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.wind_turbine,
          resourceProduced: ResourceType.energy,
          drones: [],
          droneConnections: [],
          droneTransfers: [],
        );

  @override
  int get outputGeneration => 5;
}
