import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/resource_type.dart';

class Quarry extends ProducerNode {
  Quarry({
    required super.type,
    required super.location,
  }) : super(resourceType: ResourceType.stone);
}
