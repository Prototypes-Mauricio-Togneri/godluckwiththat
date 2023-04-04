import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class NuclearPowerPlant extends Building {
  NuclearPowerPlant({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.nuclear_power_plant,
        );
}
