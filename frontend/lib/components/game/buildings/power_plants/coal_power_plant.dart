import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class CoalPowerPlant extends Building {
  CoalPowerPlant({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.coal_power_plant,
        );
}
