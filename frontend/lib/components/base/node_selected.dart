import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';

class NodeSelected extends SpriteComponent with HasGameRef<GameComponent> {
  final Node node;
  final Paint _paintConnections = Paint();
  final Paint _paintProducing = Paint();

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

    _paintProducing.color = Palette.error;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final Connection connection in node.connections) {
      final Vector2 start = size / 2;
      final Vector2 position =
          connection.to.location.position - node.location.position + start;

      canvas.drawLine(
        start.toOffset(),
        position.toOffset(),
        _paintConnections,
      );
    }

    if (node is Building) {
      final Building building = node as Building;

      if (building.state.isWorking) {
        canvas.drawArc(
          Rect.fromCenter(
            center: (getSize() / 2).toOffset(),
            width: size.x / 2,
            height: size.x / 2,
          ),
          0,
          (2 * pi) * building.producingProcess,
          true,
          _paintProducing,
        );
      }
    }
  }
}
