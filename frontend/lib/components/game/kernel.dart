import 'package:flame/events.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/spec/node_spec.dart';

class Kernel extends FixedNode {
  Kernel({
    required super.i,
    required super.j,
    required super.shield,
  }) : super(
          image: NodeSpec.kernel.type.sprite,
          armor: NodeSpec.kernel.armor,
        );

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
