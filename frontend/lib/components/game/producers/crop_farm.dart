import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CropFarm extends ProducerNode {
  CropFarm({
    required super.location,
  }) : super(
          type: NodeType.crop_farm,
          resourceType: ResourceType.grain,
        );
}
