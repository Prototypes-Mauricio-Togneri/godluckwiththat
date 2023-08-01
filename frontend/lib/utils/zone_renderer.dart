import 'dart:ui';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/utils/palette.dart';

class ZoneRenderer {
  final List<Tile> tiles;
  final Paint paintSelected = Paint();

  ZoneRenderer({
    required this.tiles,
  }) {
    paintSelected.color = Palette.white;
    paintSelected.style = PaintingStyle.stroke;
  }

  void render({
    required Canvas canvas,
    required int canvasWidth,
    required double tileWidth,
    required double tileHeight,
    required double topGap,
  }) {
    final Tile tile = tiles.first;
    paintSelected.strokeWidth = canvasWidth / 700;

    final double i = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    final double j = topGap + ((tile.x + tile.y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintSelected);
  }
}
