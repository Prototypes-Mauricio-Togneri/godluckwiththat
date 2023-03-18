import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/utils/palette.dart';

class ConnectionPainter {
  static final Paint _paint = Paint()
    ..color = Palette.white
    ..strokeWidth = 3 / Constants.NODE_SIZE
    ..style = PaintingStyle.stroke;

  static void render({
    required Canvas canvas,
    required Vector2 start,
    required Vector2 end,
  }) {
    canvas.drawLine(
      start.toOffset(),
      end.toOffset(),
      _paint,
    );
  }
}
