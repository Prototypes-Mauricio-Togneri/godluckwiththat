import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class StoneMine extends Building {
  StoneMine({
    required super.location,
  }) : super(
          type: NodeType.stone_mine,
          resourceProduced: ResourceType.stone_ore,
          resourcesRequired: {
            ResourceType.energy: 0,
          },
        );
}
