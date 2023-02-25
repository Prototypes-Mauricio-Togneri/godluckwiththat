import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CoalMine extends ProducerNode {
  CoalMine({
    required super.location,
  }) : super(
          type: NodeType.coal_mine,
          resourceProduced: ResourceType.coal_ore,
        );
}
