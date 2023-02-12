import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class FixedNodeSpec extends NodeSpec {
  final Resources cost;

  static FixedNodeSpec kernel = FixedNodeSpec(
    type: NodeType.kernel,
    health: 50,
    cost: Resources.empty(),
  );

  const FixedNodeSpec({
    required super.type,
    required super.health,
    required this.cost,
  });
}
