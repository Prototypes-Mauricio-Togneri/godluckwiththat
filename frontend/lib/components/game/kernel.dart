import 'package:flame/events.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';

class Kernel extends FixedNode {
  Kernel({
    required super.i,
    required super.j,
    required super.shield,
  }) : super(
          type: FixedNodeSpec.kernel.type,
          armor: FixedNodeSpec.kernel.armor,
          heat: FixedNodeSpec.kernel.heat,
        );

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }

  JsonNode get json => JsonNode(
        type: type,
        position: [i, j],
        shield: shield.toInt(),
      );
}
