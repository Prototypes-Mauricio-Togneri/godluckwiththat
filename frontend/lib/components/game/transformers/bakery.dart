import 'package:tensionnode/components/base/transformer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Bakery extends TransformerNode {
  Bakery({
    required super.location,
    required super.resourcesRequired,
  }) : super(
          type: NodeType.bakery,
          resourceProduced: ResourceType.bread,
        );
}
