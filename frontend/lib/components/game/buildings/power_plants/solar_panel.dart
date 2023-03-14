import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class SolarPanel extends Building {
  SolarPanel({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          nodeType: NodeType.solar_panel,
        );
}
