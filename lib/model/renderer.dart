import 'package:flutter/rendering.dart';
import 'package:tensionnode/extensions/path_extension.dart';
import 'package:tensionnode/model/game_map.dart';

class Renderer {
  final GameMap map;
  late Canvas canvas;

  Renderer({required this.map});

  void setCanvas(Canvas newCanvas) => canvas = newCanvas;

  void diamondHollow({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;
    paint.strokeWidth = 0.5;

    _diamondFilled(
      position: _translate(position),
      paint: paint,
      size: size,
    );
  }

  void diamondFilled({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;

    _diamondFilled(
      position: _translate(position),
      paint: paint,
      size: size,
    );
  }

  void _diamondFilled({
    required Offset position,
    required Paint paint,
    required num size,
  }) {
    final Path path = Path();
    path.diamond(
      position: position,
      blockSize: map.blockSize,
      size: size,
    );

    canvas.drawPath(path, paint);
  }

  void line({
    required Offset from,
    required Offset to,
    required Color color,
  }) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;
    paint.strokeWidth = 0.5;

    final Path path = Path();
    path.line(
      from: _translate(from),
      to: _translate(to),
      blockSize: map.blockSize,
    );

    canvas.drawPath(path, paint);
  }

  Offset _translate(Offset position) => position.translate(
        (map.size.width / map.blockSize) / 2,
        (map.size.height / map.blockSize) / 2,
      );
}
