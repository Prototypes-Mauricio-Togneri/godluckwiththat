import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CopperFurnace extends Building {
  CopperFurnace({
    required super.location,
    required super.resourcesRequired,
  }) : super(
          type: NodeType.copper_furnace,
          resourceProduced: ResourceType.copper_block,
        );
}
