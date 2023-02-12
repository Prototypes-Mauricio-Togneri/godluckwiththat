import 'package:tensionnode/types/node_type.dart';

class NodeSpec {
  final NodeType type;
  final double health;

  const NodeSpec({
    required this.type,
    required this.health,
  });
}
