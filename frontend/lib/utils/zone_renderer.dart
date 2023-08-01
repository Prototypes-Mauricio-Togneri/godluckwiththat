import 'dart:ui';

import 'package:gatewayguardians/utils/palette.dart';

class ZoneRenderer {
  final int x;
  final int y;
  final Paint paintTest = Paint();

  ZoneRenderer({
    required this.x,
    required this.y,
  }) {
    paintTest.color = Palette.white;
    paintTest.style = PaintingStyle.stroke;
  }

  void render({
    required Canvas canvas,
    required int canvasWidth,
    required double tileWidth,
    required double tileHeight,
    required double topGap,
  }) {
    paintTest.strokeWidth = canvasWidth / 700;

    final double i = (canvasWidth / 2) + ((x - y) * (tileWidth / 2));
    final double j = topGap + ((x + y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintTest);
  }
}
