import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends ProducerNode {
  Woodcutter({
    required super.type,
    required super.location,
  }) : super(resourceType: ResourceType.timber);
}
