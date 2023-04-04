import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class OilPowerPlant extends Building {
  OilPowerPlant({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.oil_power_plant,
        );
}
