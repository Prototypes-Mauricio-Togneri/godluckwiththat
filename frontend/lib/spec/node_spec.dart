import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/types/node_type.dart';

class NodeSpec {
  final NodeType type;
  final Resources cost;
  final double armor;

  const NodeSpec({
    required this.type,
    required this.cost,
    required this.armor,
  });
}
