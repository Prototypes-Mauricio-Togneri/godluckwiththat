import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:tensionplanet/utils/palette.dart';

class DronePainter {
  static final Paint _paint = Paint()
    ..color = Palette.error
    ..style = PaintingStyle.fill;

  static void render({
    required Canvas canvas,
    required Vector2 center,
  }) {
    canvas.drawCircle(
      center.toOffset(),
      0.5,
      _paint,
    );
  }
}
