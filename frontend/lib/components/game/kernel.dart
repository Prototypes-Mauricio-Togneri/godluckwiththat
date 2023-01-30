import 'package:flame/events.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/spec/node_spec.dart';

class Kernel extends FixedNode {
  Kernel({
    required super.i,
    required super.j,
    required super.shield,
  }) : super(
          image: NodeSpec.kernel.type.image,
          armor: NodeSpec.kernel.armor,
        );

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
