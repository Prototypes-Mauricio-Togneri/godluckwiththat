import 'package:flutter/rendering.dart';
import 'package:tensionnode/debug/render_tracker.dart';
import 'package:tensionnode/extensions/path_extension.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/node_type.dart';

class Renderer {
  bool _debugMode = false;
  bool _advanceMode = false;
  final GameMap map;
  final Path _path = Path();
  late Canvas canvas;

  Renderer(this.map);

  bool get hasDebugMode => _debugMode;

  void toggleAdvanceMode() => _advanceMode = !_advanceMode;

  void toggleDebugMode() => _debugMode = !_debugMode;

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
    RenderTracker.pathsRendered++;
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
    RenderTracker.pathsRendered++;
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
  }) {
    canvas.drawCircle(position, size.toDouble(), paint);
    RenderTracker.circlesRendered++;
  }

  void drawLine({
    required Offset positionFrom,
    required Offset positionTo,
    required Color color,
  }) {
    final Paint paintLine = Palette.connectionBasicPaint;
    paintLine.color = color;

    final Path pathLine = newPath;
    pathLine.line(
      from: map.gameToReal(positionFrom),
      to: map.gameToReal(positionTo),
    );

    canvas.drawPath(pathLine, paintLine);
    RenderTracker.pathsRendered++;
  }

  void connection({
    required Direction direction,
    required Offset from,
    required Offset to,
    required Color lineColor,
    required Color arrowColor,
  }) {
    if (_advanceMode) {
      final Paint paintLine = Palette.connectionAdvancePaint;
      paintLine.color = lineColor;

      final Path pathLine = newPath;
      pathLine.line(
        from: map.gameToReal(from),
        to: map.gameToReal(to),
      );

      canvas.drawPath(pathLine, paintLine);
      RenderTracker.pathsRendered++;

      final Paint paintArrow = Palette.connectionArrowPaint;
      paintArrow.color = arrowColor;

      final Offset position = map.gameToReal(Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2));
      final num size = Palette.connectionAdvancePaint.strokeWidth / 3;

      final Path pathArrow = newPath;

      switch (direction) {
        case Direction.up:
          pathArrow.arrowUp(
            position: position,
            size: size,
          );
          break;
        case Direction.down:
          pathArrow.arrowDown(
            position: position,
            size: size,
          );
          break;
        case Direction.left:
          pathArrow.arrowLeft(
            position: position,
            size: size,
          );
          break;
        case Direction.right:
          pathArrow.arrowRight(
            position: position,
            size: size,
          );
          break;
      }

      canvas.drawPath(pathArrow, paintArrow);
      RenderTracker.pathsRendered++;
    } else {
      final Paint paintLine = Palette.connectionBasicPaint;
      paintLine.color = lineColor;

      final Path pathLine = newPath;
      pathLine.line(
        from: map.gameToReal(from),
        to: map.gameToReal(to),
      );

      canvas.drawPath(pathLine, paintLine);
      RenderTracker.pathsRendered++;
    }
  }

  void hp({
    required Offset position,
    required num value,
    required num max,
  }) {
    if (_advanceMode && (value < max)) {
      final Rect rect = Rect.fromCenter(
        center: map.gameToReal(position),
        width: map.blockSize.toDouble(),
        height: map.blockSize.toDouble(),
      );

      canvas.drawRect(rect, Palette.hpContainerPaint);
      RenderTracker.rectRendered++;

      final int percentage = value * 100 ~/ max;

      Color color = Palette.white;

      if (percentage >= 75) {
        color = Palette.hpHigh;
      } else if (percentage >= 50) {
        color = Palette.hpMedium;
      } else {
        color = Palette.hpLow;
      }

      renderText(
        text: '$percentage',
        color: color,
        size: 5,
        position: position,
        weight: FontWeight.bold,
      );
    }
  }

  void renderText({
    required String text,
    required Color color,
    required double size,
    required Offset position,
    FontWeight weight = FontWeight.normal,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      map.gameToReal(position).translate(
            -textPainter.size.width / 2,
            -textPainter.size.height / 2,
          ),
    );
  }

  Path get newPath {
    _path.reset();

    return _path;
  }

  void drawByType({
    required NodeType type,
    required Offset position,
    required Color color,
  }) {
    switch (type) {
      case NodeType.headquarters:
        drawHeadquarters(position: position, color: color);
        break;
      case NodeType.intersection:
        drawIntersection(position: position, color: color);
        break;
      case NodeType.mine:
        drawMine(position: position, color: color);
        break;
      case NodeType.power_plant:
        drawPowerPlant(position: position, color: color);
        break;
      case NodeType.wall:
        drawWall(position: position, color: color);
        break;
      case NodeType.light_turret:
        drawLightTurret(position: position, color: color);
        break;
      case NodeType.heavy_turret:
        drawHeavyTurret(position: position, color: color);
        break;
    }
  }

  void drawHeadquarters({
    required Offset position,
    required Color color,
  }) {
    diamondHollow(
      position: position,
      color: color,
      size: map.blockSize * 1.5,
    );

    diamondFilled(
      position: position,
      color: color,
      size: map.blockSize * 1.5 / 2,
    );
  }

  void drawIntersection({
    required Offset position,
    required Color color,
  }) {
    if (_advanceMode) {
      diamondFilled(
        position: position,
        color: color,
        size: map.blockSize / 5,
      );
    }
  }

  void drawMine({
    required Offset position,
    required Color color,
  }) {
    squareHollow(
      position: position,
      color: color,
      size: map.blockSize,
    );

    squareFilled(
      position: position,
      color: color,
      size: map.blockSize / 2,
    );
  }

  void drawPowerPlant({
    required Offset position,
    required Color color,
  }) {
    circleHollow(
      position: position,
      color: color,
      size: map.blockSize / 2.2,
    );

    circleFilled(
      position: position,
      color: color,
      size: map.blockSize / 2.2 / 2,
    );
  }

  // TODO(momo): update
  void drawWall({
    required Offset position,
    required Color color,
  }) {
    diamondHollow(
      position: position,
      color: color,
      size: map.blockSize,
    );

    diamondFilled(
      position: position,
      color: color,
      size: map.blockSize / 2,
    );
  }

  void drawLightTurret({
    required Offset position,
    required Color color,
  }) {
    diamondHollow(
      position: position,
      color: color,
      size: map.blockSize,
    );

    diamondFilled(
      position: position,
      color: color,
      size: map.blockSize / 2,
    );
  }

  // TODO(momo): update
  void drawHeavyTurret({
    required Offset position,
    required Color color,
  }) {
    diamondHollow(
      position: position,
      color: color,
      size: map.blockSize,
    );

    diamondFilled(
      position: position,
      color: color,
      size: map.blockSize / 2,
    );
  }
}
