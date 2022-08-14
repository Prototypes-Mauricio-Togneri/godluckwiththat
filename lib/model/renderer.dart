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
      blockSize: blockSize,
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
      blockSize: blockSize,
    );

    canvas.drawPath(path, paint);
  }

  Offset _translate(Offset position) => position.translate(
        (mapSize.width / blockSize) / 2,
        (mapSize.height / blockSize) / 2,
      );
}
