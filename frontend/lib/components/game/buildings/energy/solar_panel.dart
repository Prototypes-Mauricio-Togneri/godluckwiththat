import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class SolarPanel extends Building {
  SolarPanel({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.solar_panel,
          resourceProduced: ResourceType.energy,
        );
}
