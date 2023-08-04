import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart' hide Image;
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/utils/images.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MapPainter extends CustomPainter {
  final GameState state;
  final Paint paintZone = Paint();
  final Paint paintZoneSelected = Paint();
  final Paint paintTileImage = Paint();
  final Paint paintTileUnexplored = Paint();

  final int canvasWidth;
  final int canvasHeight;
  late final double tileWidth;
  late final double tileHeight;
  late final double topGap;
  late final int mapSize;

  MapPainter({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.state,
  }) {
    state.setMapPainter(this);
    mapSize = sqrt(state.colony.zones.length).toInt();
    tileWidth = canvasWidth / (mapSize + 1);
    tileHeight = tileWidth / 2;
    topGap = canvasHeight - (tileHeight * mapSize) - tileHeight;

    paintZone.style = PaintingStyle.stroke;

    paintZoneSelected.color = Palette.white;
    paintZoneSelected.style = PaintingStyle.stroke;

    paintTileImage.color = Palette.grey;
    paintTileImage.style = PaintingStyle.fill;

    paintTileUnexplored.color = Palette.black.withAlpha(150);
    paintTileUnexplored.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final Zone zone in state.colony.zones) {
      if (!zone.status.isHidden) {
        for (final Tile tile in zone.tiles) {
          renderTile(
            tile: tile,
            canvas: canvas,
            zoneStatus: zone.status,
          );
        }
      }
    }

    for (final Zone zone in state.colony.zones) {
      if (zone.isOwned) {
        renderZone(
          zone: zone,
          canvas: canvas,
        );
      }
    }

    if (state.selectedZone != null) {
      renderZoneSelected(
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
    paintZone.color = Constants.PLAYER_COLOR;
    paintZone.strokeWidth = canvasWidth / 500;

    final double i = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    final double j = topGap + ((tile.x + tile.y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintZone);

    if (zone.status.isExplored) {
      /*if (zone.building != null) {
        _drawImageHalf(
          canvas: canvas,
          offset: Offset(i, j),
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          image: Images.image(zone.building!.buildingType.sprite),
        );
      }*/
    }
  }

  void renderZoneSelected({
    required Zone zone,
    required Canvas canvas,
  }) {
    final Tile tile = zone.tiles.first;
    paintZoneSelected.strokeWidth = canvasWidth / 500;

    final double i = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    final double j = topGap + ((tile.x + tile.y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintZoneSelected);
  }

  void renderTile({
    required Tile tile,
    required Canvas canvas,
    required ZoneStatus zoneStatus,
  }) {
    final double i = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    final double j = topGap + ((tile.x + tile.y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintTileImage);

    _drawImageFull(
      canvas: canvas,
      offset: Offset(
        i - (tileWidth / 2),
        j - (tileHeight / 2),
      ),
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      image: Images.image(tile.tileType.sprite),
    );

    if (zoneStatus.isExplored) {
      if (tile.patchType != null) {
        _drawImageFull(
          canvas: canvas,
          offset: Offset(
            i - (tileWidth / 2),
            j - (tileHeight / 2),
          ),
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          image: Images.image(tile.patchType!.sprite),
        );
      }
    } else if (zoneStatus.isUnexplored) {
      canvas.drawPath(path, paintTileUnexplored);
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

  void _drawImageHalf({
    required Canvas canvas,
    required Offset offset,
    required double tileWidth,
    required double tileHeight,
    required Image image,
  }) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(
        offset.dx - (tileHeight / 3),
        offset.dy - (tileHeight / 3),
        tileHeight / 1.5,
        tileHeight / 1.5,
      ),
      paintTileImage,
    );
  }

  bool isInsideZone({
    required Zone zone,
    required Offset offset,
  }) =>
      zone.tiles.any((tile) => _isInsideTile(
            tile: tile,
            offset: offset,
          ));

  // https://math.stackexchange.com/questions/312403/how-do-i-determine-if-a-point-is-within-a-rhombus
  bool _isInsideTile({
    required Tile tile,
    required Offset offset,
  }) {
    final double qx = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    final double qy = topGap + ((tile.x + tile.y) * (tileHeight / 2));
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

    return distance <= (tileHeight / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
