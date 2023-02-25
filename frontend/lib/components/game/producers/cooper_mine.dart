import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CooperMine extends ProducerNode {
  CooperMine({
    required super.location,
  }) : super(
          type: NodeType.cooper_mine,
          resourceProduced: ResourceType.cooper_ore,
        );
}
