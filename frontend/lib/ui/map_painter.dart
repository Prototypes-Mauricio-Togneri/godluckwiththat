import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart' hide Image;
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/images.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MapPainter extends CustomPainter {
  final GameState state;
  final Paint paintZoneSelected = Paint();
  final Paint paintTileImage = Paint();

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

    paintTileImage.color = Palette.grey;
    paintTileImage.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final Zone zone in state.colony.zones) {
      for (final Tile tile in zone.tiles) {
        renderTile(
          tile: tile,
          canvas: canvas,
        );
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

  void renderTile({
    required Tile tile,
    required Canvas canvas,
  }) {
    final double i =
        (CANVAS_WIDTH / 2) + ((tile.x - tile.y) * (MapPainter.TILE_WIDTH / 2));
    final double j =
        TOP_GAP + ((tile.x + tile.y) * (MapPainter.TILE_HEIGHT / 2));

    final Path path = Path();
    path.moveTo(i, j - (MapPainter.TILE_HEIGHT / 2));
    path.lineTo(i + (MapPainter.TILE_WIDTH / 2), j);
    path.lineTo(i, j + (MapPainter.TILE_HEIGHT / 2));
    path.lineTo(i - (MapPainter.TILE_WIDTH / 2), j);
    path.close();
    canvas.drawPath(path, paintTileImage);

    _drawImageFull(
      canvas: canvas,
      offset: Offset(
        i - (MapPainter.TILE_WIDTH / 2),
        j - (MapPainter.TILE_HEIGHT / 2),
      ),
      tileWidth: MapPainter.TILE_WIDTH,
      tileHeight: MapPainter.TILE_HEIGHT,
      image: Images.image(tile.tileType.sprite),
    );

    if (tile.patchType != null) {
      _drawImageFull(
        canvas: canvas,
        offset: Offset(
          i - (MapPainter.TILE_WIDTH / 2),
          j - (MapPainter.TILE_HEIGHT / 2),
        ),
        tileWidth: MapPainter.TILE_WIDTH,
        tileHeight: MapPainter.TILE_HEIGHT,
        image: Images.image(tile.patchType!.sprite),
      );
    }
  }

  void _drawImageFull({
    required Canvas canvas,
    required Offset offset,
    required double tileWidth,
    required double tileHeight,
    required Image image,
  }) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(offset.dx, offset.dy, tileWidth, tileHeight),
      paintTileImage,
    );
  }

  bool isInsideZone({
    required Zone zone,
    required Offset offset,
  }) =>
      zone.tiles.any((element) => _isInsideTile(
            tile: element,
            offset: offset,
          ));

  // https://math.stackexchange.com/questions/312403/how-do-i-determine-if-a-point-is-within-a-rhombus
  bool _isInsideTile({
    required Tile tile,
    required Offset offset,
  }) {
    final double qx = (MapPainter.CANVAS_WIDTH / 2) +
        ((tile.x - tile.y) * (MapPainter.TILE_WIDTH / 2));
    final double qy =
        MapPainter.TOP_GAP + ((tile.x + tile.y) * (MapPainter.TILE_HEIGHT / 2));
    // final double a = MapPainter.TILE_WIDTH / 2;
    // final double b = MapPainter.TILE_HEIGHT / 2;

    // Q = 0.5*(A + C);           // center point
    // a = 0.5*distance(A,C);     // half-width (in the x-direction)
    // b = 0.5*distance(B,D);     // half-height (y-direction)
    // U = (C - A)/(2*a);         // unit vector in x-direction
    // V = (D - B)/(2*b);         // unit vector in y-direction

    // W = P - Q;
    // xabs = abs(W*U);    // here W*U is the dot product of W and U
    // yabs = abs(W*V);    // here W*V is the dot product of W and V
    // if (xabs/a + yabs/b <= 1) then inside = true;

    final double distance =
        sqrt(pow(offset.dx - qx, 2) + pow(offset.dy - qy, 2));

    return distance <= (MapPainter.TILE_HEIGHT / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
