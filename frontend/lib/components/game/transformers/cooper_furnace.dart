import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CooperFurnace extends Building {
  CooperFurnace({
    required super.location,
    required super.resourcesRequired,
  }) : super(
          type: NodeType.cooper_furnace,
          resourceProduced: ResourceType.cooper_block,
        );
}
