import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MapPainter extends CustomPainter {
  final GameState state;
  final Paint paintZoneSelected = Paint();

  static int CANVAS_WIDTH = 0;
  static int CANVAS_HEIGHT = 0;
  static double TILE_WIDTH = 0;
  static double TILE_HEIGHT = 0;
  static double TOP_GAP = 0;
  int mapSize = 0;

  MapPainter({
    required int canvasWidth,
    required int canvasHeight,
    required this.state,
  }) {
    state.setMapPainter(this);
    mapSize = sqrt(state.colony.zones.length).toInt();
    CANVAS_WIDTH = canvasWidth;
    CANVAS_HEIGHT = canvasHeight;
    TILE_WIDTH = CANVAS_WIDTH / (mapSize + 1);
    TILE_HEIGHT = TILE_WIDTH / 2;
    TOP_GAP = CANVAS_HEIGHT - (TILE_HEIGHT * mapSize) - TILE_HEIGHT;

    paintZoneSelected.color = Palette.white;
    paintZoneSelected.style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int y = 0; y < mapSize; y++) {
      for (int x = 0; x < mapSize; x++) {
        final Zone? zone = state.colony.zoneById('$x,$y');

        if (zone != null) {
          for (final Tile tile in zone.tiles) {
            tile.renderer.render(
              tile: tile,
              canvas: canvas,
              size: size,
              topGap: TOP_GAP,
            );
          }
        }
      }
    }

    if (state.selectedZone != null) {
      renderZone(
        zone: state.selectedZone!,
        canvas: canvas,
      );
    }
  }

  void renderZone({
    required Zone zone,
    required Canvas canvas,
  }) {
    final Tile tile = zone.tiles.first;
    paintZoneSelected.strokeWidth = CANVAS_WIDTH / 700;

    final double i =
        (CANVAS_WIDTH / 2) + ((tile.x - tile.y) * (TILE_WIDTH / 2));
    final double j = TOP_GAP + ((tile.x + tile.y) * (TILE_HEIGHT / 2));

    final Path path = Path();
    path.moveTo(i, j - (TILE_HEIGHT / 2));
    path.lineTo(i + (TILE_WIDTH / 2), j);
    path.lineTo(i, j + (TILE_HEIGHT / 2));
    path.lineTo(i - (TILE_WIDTH / 2), j);
    path.close();
    canvas.drawPath(path, paintZoneSelected);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
