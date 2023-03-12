import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/types/node_type.dart';

class DroneFactory extends Building {
  DroneFactory({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.drone_factory,
        );
}
