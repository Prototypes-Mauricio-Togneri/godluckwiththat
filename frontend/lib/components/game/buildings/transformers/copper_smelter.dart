import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CopperSmelter extends Building {
  CopperSmelter({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.copper_smelter,
          resourceProduced: ResourceType.copper_block,
          constructionDrones: [],
          logisticDrones: [],
          droneConnections: [],
          droneTransfers: [],
        );
}
