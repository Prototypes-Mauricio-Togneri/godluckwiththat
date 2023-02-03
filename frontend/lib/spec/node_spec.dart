import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/types/node_type.dart';

class NodeSpec {
  final NodeType type;
  final Resources cost;
  final double armor;
  final int heat;

  static NodeSpec kernel = NodeSpec(
    type: NodeType.kernel,
    cost: Resources.empty(),
    armor: 50,
    heat: 5,
  );

  const NodeSpec({
    required this.type,
    required this.cost,
    required this.armor,
    required this.heat,
  });
}
