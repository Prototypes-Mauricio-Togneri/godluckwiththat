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
  final Paint _paint = Paint();
  double _range = 0;

  NodeRange({
    required FixedNode node,
  }) : super(position: Position.fromGrid(node.i, node.j)) {
    if (node is Turret) {
      _range = node.range;
    }
  }

  @override
  FutureOr<void> onLoad() {
    _paint.color = Palette.rangeIndicator;
    _paint.strokeWidth = 3 / Constants.NODE_SIZE;
    _paint.style = PaintingStyle.stroke;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(Offset.zero, _range, _paint);
  }
}
