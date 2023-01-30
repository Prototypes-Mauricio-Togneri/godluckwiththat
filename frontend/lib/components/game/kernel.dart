import 'package:flame/events.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/types/node_type.dart';

class Kernel extends FixedNode {
  Kernel({
    required super.i,
    required super.j,
    required super.shield,
  }) : super(
          image: NodeType.kernel.image,
          armor: NodeType.kernel.armor,
        );

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
