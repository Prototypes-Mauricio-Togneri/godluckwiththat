import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Hunter extends ProducerNode {
  Hunter({
    required super.location,
  }) : super(
          type: NodeType.hunter,
          resourceType: ResourceType.meat,
        );
}
