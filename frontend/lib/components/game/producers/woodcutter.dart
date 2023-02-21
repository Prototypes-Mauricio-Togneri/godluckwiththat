import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends ProducerNode {
  Woodcutter({
    required super.location,
  }) : super(
          type: NodeType.woodcutter,
          resourceType: ResourceType.timber,
        );
}
