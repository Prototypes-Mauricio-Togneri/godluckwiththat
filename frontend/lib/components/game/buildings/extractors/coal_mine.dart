import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CoalMine extends Building {
  CoalMine({
    required super.location,
    required super.input,
  }) : super(
          type: NodeType.coal_mine,
          resourceProduced: ResourceType.coal_ore,
        );
}
