import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class WindTurbine extends Building {
  WindTurbine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.wind_turbine,
        );
}
