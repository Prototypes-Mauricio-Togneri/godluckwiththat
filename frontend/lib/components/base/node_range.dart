import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/services/palette.dart';

class NodeRange extends PositionComponent with HasGameRef<GameComponent> {
  final Paint paint = Paint();
  double range = 0;

  NodeRange({
    required FixedNode node,
  }) : super(position: Position.fromGrid(node.i, node.j)) {
    if (node is Turret) {
      range = node.range;
    }
  }

  @override
  FutureOr<void> onLoad() {
    paint.color = Palette.rangeIndicator;
    paint.strokeWidth = 3 / Constants.NODE_SIZE;
    paint.style = PaintingStyle.stroke;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(Offset.zero, range, paint);
  }
}
