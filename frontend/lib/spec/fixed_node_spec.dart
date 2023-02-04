import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class FixedNodeSpec extends NodeSpec {
  final int heat;

  static FixedNodeSpec kernel = FixedNodeSpec(
    type: NodeType.kernel,
    cost: Resources.empty(),
    armor: 50,
    heat: 5,
  );

  const FixedNodeSpec({
    required super.type,
    required super.cost,
    required super.armor,
    required this.heat,
  });
}
