import 'package:tensionnode/components/base/transformer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Sawery extends TransformerNode {
  Sawery({
    required super.location,
    required super.resourcesRequired,
  }) : super(
          type: NodeType.sawery,
          resourceProduced: ResourceType.wood,
        );
}
