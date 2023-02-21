import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Fisher extends ProducerNode {
  Fisher({
    required super.location,
  }) : super(
          type: NodeType.fisher,
          resourceType: ResourceType.fish,
        );
}
