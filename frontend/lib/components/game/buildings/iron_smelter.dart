import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class IronSmelter extends Building {
  IronSmelter({
    required super.location,
    required super.resourcesRequired,
  }) : super(
          type: NodeType.iron_smelter,
          resourceProduced: ResourceType.iron_block,
        );
}
