import 'package:flutter/rendering.dart';
import 'package:tensionnode/extensions/path_extension.dart';

class Renderer {
  final Size mapSize;
  final num blockSize;
  final Canvas canvas;

  const Renderer({
    required this.mapSize,
    required this.blockSize,
    required this.canvas,
  });

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
      position: position.translate(
        (mapSize.width / blockSize) / 2,
        (mapSize.height / blockSize) / 2,
      ),
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
      position: position.translate(
        (mapSize.width / blockSize) / 2,
        (mapSize.height / blockSize) / 2,
      ),
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
      blockSize: blockSize,
      size: size,
    );

    canvas.drawPath(path, paint);
  }
}
