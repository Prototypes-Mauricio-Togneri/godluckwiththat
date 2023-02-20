import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/resource_type.dart';

class Fisher extends ProducerNode {
  Fisher({
    required super.type,
    required super.location,
  }) : super(resourceType: ResourceType.fish);
}
