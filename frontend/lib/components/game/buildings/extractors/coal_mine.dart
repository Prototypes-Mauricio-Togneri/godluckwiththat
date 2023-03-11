import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CoalMine extends Building {
  CoalMine({
    required super.location,
    required super.inventory,
    required super.connections,
  }) : super(
          type: NodeType.coal_mine,
          resourcesRequired: [ResourceType.energy],
          resourcesProduced: ResourceType.coal_ore,
        );
}
