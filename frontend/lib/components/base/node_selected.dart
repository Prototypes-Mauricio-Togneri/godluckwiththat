import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/utils/assets.dart';
import 'package:tensionnode/utils/palette.dart';

class NodeSelected extends SpriteComponent with HasGameRef<GameComponent> {
  final Node node;
  final Paint _paintConnections = Paint();
  final Paint _paintTransfers = Paint();

  NodeSelected(this.node);

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_NODE_SELECTED);
    size = getSize();
    anchor = Anchor.center;
    position = node.location.position;

    _paintConnections.color = Palette.white;
    _paintConnections.strokeWidth = 3 / Constants.NODE_SIZE;
    _paintConnections.style = PaintingStyle.stroke;

    _paintTransfers.color = Palette.error;
    _paintTransfers.strokeWidth = 5 / Constants.NODE_SIZE;
    _paintTransfers.style = PaintingStyle.stroke;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final Node connection in node.droneConnections) {
      final Vector2 start = size / 2;
      final Vector2 position =
          connection.location.position - node.location.position + start;

      canvas.drawLine(
        start.toOffset(),
        position.toOffset(),
        _paintConnections,
      );
    }

    if (node.hasDroneTransfers) {
      for (final Node to in node.droneTransfers) {
        final Vector2 start = size / 2;
        final Vector2 position =
            to.location.position - node.location.position + start;

        canvas.drawLine(
          start.toOffset(),
          position.toOffset(),
          _paintTransfers,
        );
      }
    }
  }
}
