import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class FactoryBasic extends Building {
  FactoryBasic({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.factory_basic,
          resourceProduced: ResourceType.drone_basic,
          drones: [],
          droneConnections: [],
          droneTransfers: [],
        );
}
