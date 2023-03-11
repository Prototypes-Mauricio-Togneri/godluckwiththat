import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class WindTurbine extends Building {
  WindTurbine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.wind_turbine,
          resourcesRequired: [],
          resourcesProduced: ResourceType.energy,
        );

  @override
  int get outputGeneration => 5;
}
