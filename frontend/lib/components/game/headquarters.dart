import 'package:flame/events.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends FixedNode {
  Headquarters({
    required super.i,
    required super.j,
    required super.shield,
  }) : super(
          path: Assets.IMAGES_HQ,
          armor: NodeType.headquarters.armor,
        );

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
