import 'package:flutter/rendering.dart';
import 'package:tensionnode/extensions/path_extension.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/services/palette.dart';

class Renderer {
  bool showHP = false;
  final GameMap map;
  final Path _path = Path();
  late Canvas canvas;

  Renderer(this.map);

  void toggleHP() => showHP = !showHP;

  void setCanvas(Canvas newCanvas) => canvas = newCanvas;

  void diamondHollow({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.diamondHollowPaint;
    paint.color = color;

    _diamond(
      position: map.gameToReal(position),
      paint: paint,
      size: size,
    );
  }

  void diamondFilled({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.diamondFilledPaint;
    paint.color = color;

    _diamond(
      position: map.gameToReal(position),
      paint: paint,
      size: size,
    );
  }

  void _diamond({
    required Offset position,
    required Paint paint,
    required num size,
  }) {
    final Path path = newPath;
    path.diamond(
      position: position,
      size: size,
    );

    canvas.drawPath(path, paint);
  }

  void squareHollow({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.squareHollowPaint;
    paint.color = color;

    _square(
      position: map.gameToReal(position),
      paint: paint,
      size: size,
    );
  }

  void squareFilled({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.squareFilledPaint;
    paint.color = color;

    _square(
      position: map.gameToReal(position),
      paint: paint,
      size: size,
    );
  }

  void _square({
    required Offset position,
    required Paint paint,
    required num size,
  }) {
    final Path path = newPath;
    path.square(
      position: position,
      size: size,
    );

    canvas.drawPath(path, paint);
  }

  void circleHollow({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.circleHollowPaint;
    paint.color = color;

    _circle(
      position: map.gameToReal(position),
      paint: paint,
      size: size,
    );
  }

  void circleFilled({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.circleFilledPaint;
    paint.color = color;

    _circle(
      position: map.gameToReal(position),
      paint: paint,
      size: size,
    );
  }

  void _circle({
    required Offset position,
    required Paint paint,
    required num size,
  }) =>
      canvas.drawCircle(position, size.toDouble(), paint);

  void lane({
    required Offset from,
    required Offset to,
    required Color color,
  }) {
    final Paint paint = Palette.lanePaint;
    paint.color = color;

    final Path path = newPath;
    path.line(
      from: map.gameToReal(from),
      to: map.gameToReal(to),
    );

    canvas.drawPath(path, paint);
  }

  void hp({
    required Offset position,
    required num value,
    required num max,
  }) {
    _hpLine(
      position: position,
      value: 1,
      color: Palette.red,
    );
    _hpLine(
      position: position,
      value: value / max,
      color: Palette.green,
    );

    _hpContainer(position);
  }

  void _hpLine({
    required Offset position,
    required num value,
    required Color color,
  }) {
    final Paint paint = Palette.hpPaint;
    paint.color = color;

    final double y = -(map.blockSize / 2) - Palette.hpPaint.strokeWidth;
    final double width = map.blockSize.toDouble();

    final Offset positionLeft = map.gameToReal(position).translate(-width / 2, y);

    final Path path = newPath;
    path.line(
      from: positionLeft,
      to: positionLeft.translate(width * value, 0),
    );

    canvas.drawPath(path, paint);
  }

  void _hpContainer(Offset position) {
    final double y = -(map.blockSize / 2) - (Palette.hpPaint.strokeWidth * 3 / 2);
    final double width = map.blockSize.toDouble() + Palette.hpPaint.strokeWidth;

    final Offset topLeft = map.gameToReal(position).translate(-width / 2, y);
    final Offset bottomRight = topLeft.translate(map.blockSize + Palette.hpPaint.strokeWidth, Palette.hpPaint.strokeWidth);

    final Paint paint = Paint();
    paint.color = Palette.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.1;
    final Rect rect = Rect.fromPoints(topLeft, bottomRight);

    canvas.drawRect(rect, paint);
  }

  Path get newPath {
    _path.reset();

    return _path;
  }
}
