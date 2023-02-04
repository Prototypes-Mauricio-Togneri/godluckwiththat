import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class FixedNodeSpec extends NodeSpec {
  final Resources cost;
  final int heat;

  static FixedNodeSpec kernel = FixedNodeSpec(
    type: NodeType.kernel,
    armor: 50,
    cost: Resources.empty(),
    heat: 5,
  );

  const FixedNodeSpec({
    required super.type,
    required super.armor,
    required this.cost,
    required this.heat,
  });
}
