import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CooperMine extends Building {
  CooperMine({
    required super.location,
  }) : super(
          type: NodeType.cooper_mine,
          resourceProduced: ResourceType.cooper_ore,
          resourcesRequired: [],
        );
}
