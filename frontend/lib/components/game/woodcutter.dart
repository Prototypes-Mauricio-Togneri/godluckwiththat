import 'package:tensionnode/components/base/producer_node.dart';
import 'package:tensionnode/json/json_woodcutter.dart';
import 'package:tensionnode/types/resource_type.dart';

class Woodcutter extends ProducerNode {
  Woodcutter({
    required super.type,
    required super.location,
  }) : super(resourceType: ResourceType.timber);

  JsonWoodcutter get json => JsonWoodcutter(
        location: location.json,
        connections: roads.json,
      );
}
