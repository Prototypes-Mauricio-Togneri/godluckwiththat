import 'package:flutter/rendering.dart';
import 'package:tensionnode/extensions/path_extension.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/services/palette.dart';

class Renderer {
  final GameMap map;
  final Path _path = Path();
  late Canvas canvas;

  Renderer(this.map);

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

  void squaredFilled({
    required Offset position,
    required Color color,
    required num size,
  }) {
    final Paint paint = Palette.squareFilledPaint;
    paint.color = color;

    final Path path = newPath;
    path.square(
      position: map.gameToReal(position),
      size: size,
    );

    canvas.drawPath(path, paint);
  }

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

  Path get newPath {
    _path.reset();

    return _path;
  }
}
