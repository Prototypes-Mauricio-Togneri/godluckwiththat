import 'package:flame/events.dart';
import 'package:tensionnode/components/fixed_node.dart';
import 'package:tensionnode/services/assets.dart';

class Headquarters extends FixedNode {
  Headquarters({
    required super.i,
    required super.j,
  }) : super(path: Assets.IMAGES_HQ);

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
