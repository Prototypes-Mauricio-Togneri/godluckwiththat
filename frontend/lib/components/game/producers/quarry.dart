import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Quarry extends ProducerNode {
  Quarry({
    required super.location,
  }) : super(
          type: NodeType.quarry,
          resourceType: ResourceType.stone,
        );
}
