import 'package:tensionnode/components/base/transformer_node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class CooperFurnace extends TransformerNode {
  CooperFurnace({
    required super.location,
    required super.resourcesRequired,
  }) : super(
          type: NodeType.cooper_furnace,
          resourceProduced: ResourceType.bronze,
        );
}
