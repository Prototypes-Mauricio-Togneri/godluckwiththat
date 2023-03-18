import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/painters/connection_painter.dart';
import 'package:tensionplanet/painters/drone_painter.dart';
import 'package:tensionplanet/utils/assets.dart';

class NodeSelected extends SpriteComponent with HasGameRef<GameComponent> {
  final Node node;

  NodeSelected(this.node);

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_NODE_SELECTED);
    size = getSize();
    anchor = Anchor.center;
    position = node.location.position;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final Connection connection in node.connections) {
      if (connection.isVisible) {
        final Vector2 start = size / 2;
        final Vector2 end =
            connection.to.location.position - node.location.position + start;

        ConnectionPainter.render(
          canvas: canvas,
          start: start,
          end: end,
        );

        if (!connection.isAvailable) {
          DronePainter.render(
            canvas: canvas,
            center: connection.position + (size / 2),
          );
        }
      }
    }
  }
}
