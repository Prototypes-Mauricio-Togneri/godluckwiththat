import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Well extends ProducerNode {
  Well({
    required super.location,
  }) : super(
          type: NodeType.well,
          resourceType: ResourceType.water,
        );
}
