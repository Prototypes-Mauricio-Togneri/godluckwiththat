import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart' hide Image;
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/island.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/images.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MapPainter extends CustomPainter {
  final GameState state;
  final Paint paintIsland = Paint();
  final Paint paintIslandSelected = Paint();
  final Paint paintTileImage = Paint();
  final Paint paintTileUnexplored = Paint();

  final int canvasWidth;
  final int canvasHeight;
  late final double tileWidth;
  late final double tileHeight;
  late final double topGap;
  late final int mapSize;

  static const double FOG_RATIO = 1.4;

  MapPainter({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.state,
  }) {
    state.setMapPainter(this);
    mapSize = state.mapSize();
    tileWidth = canvasWidth / mapSize;
    tileHeight = tileWidth / 2;
    topGap = canvasHeight - (tileHeight * mapSize) - tileHeight;

    paintIsland.style = PaintingStyle.stroke;

    paintIslandSelected.color = Palette.white;
    paintIslandSelected.style = PaintingStyle.stroke;

    paintTileImage.color = Palette.grey;
    paintTileImage.style = PaintingStyle.fill;

    paintTileUnexplored.color = Palette.black.withAlpha(150);
    paintTileUnexplored.style = PaintingStyle.fill;
  }

  Offset _tileCenter(Tile tile) {
    final double gap = canvasHeight - (canvasWidth.toDouble() / 2);
    final double i = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    final double j =
        (tile.x + tile.y) * (tileHeight / 2) + (gap / 2) + (tileHeight / 2);

    return Offset(i, j);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawImage(
      canvas: canvas,
      center: Offset(canvasWidth / 2, canvasHeight / 2),
      width: canvasWidth.toDouble(),
      height: canvasWidth.toDouble() / 2,
      image: Images.image(Assets.IMAGES_MAPS_MAP1),
    );

    for (final Tile tile in state.tiles) {
      if (tile.isHidden) {
        _drawImage(
          canvas: canvas,
          center: _tileCenter(tile),
          width: tileWidth * FOG_RATIO,
          height: tileHeight * FOG_RATIO,
          image: Images.image(Assets.IMAGES_TILES_FOG),
        );
      }
    }

    for (final Island island in state.islands) {
      if ((!island.isNeutral) && (island.isRevealed)) {
        renderIsland(
          state: state,
          island: island,
          canvas: canvas,
          paint: paintIsland,
          color: island.color,
        );
      }
    }

    if (state.selectedIsland != null) {
      renderIsland(
        state: state,
        island: state.selectedIsland!,
        canvas: canvas,
        paint: paintIslandSelected,
        color: Palette.white,
      );
    }
  }

  void renderIsland({
    required GameState state,
    required Island island,
    required Canvas canvas,
    required Paint paint,
    required Color color,
  }) {
    paint.color = color;
    paint.strokeWidth = canvasWidth / 500;

    renderIslandBorder(
      state: state,
      island: island,
      canvas: canvas,
      paint: paintIsland,
    );
  }

  void renderIslandBorder({
    required GameState state,
    required Island island,
    required Canvas canvas,
    required Paint paint,
  }) {
    /*for (final Tile tile in island.tiles) {
      final double i =
          (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
      final double j = topGap + ((tile.x + tile.y) * (tileHeight / 2));

      // top
      final Island? topNeighbor = state.topNeighbor(tile);

      if (_shouldRenderIsland(island, topNeighbor, singleIsland)) {
        canvas.drawLine(
          Offset(i, j - (tileHeight / 2)),
          Offset(i + (tileWidth / 2), j),
          paint,
        );
      }

      // right
      final Island? rightNeighbor = state.rightNeighbor(tile);

      if (_shouldRenderIsland(island, rightNeighbor, singleIsland)) {
        canvas.drawLine(
          Offset(i + (tileWidth / 2), j),
          Offset(i, j + (tileHeight / 2)),
          paint,
        );
      }

      // bottom
      final Island? bottomNeighbor = state.bottomNeighbor(tile);

      if (_shouldRenderIsland(island, bottomNeighbor, singleIsland)) {
        canvas.drawLine(
          Offset(i, j + (tileHeight / 2)),
          Offset(i - (tileWidth / 2), j),
          paint,
        );
      }

      // left
      final Island? leftNeighbor = state.leftNeighbor(tile);

      if (_shouldRenderIsland(island, leftNeighbor, singleIsland)) {
        canvas.drawLine(
          Offset(i - (tileWidth / 2), j),
          Offset(i, j - (tileHeight / 2)),
          paint,
        );
      }
    }*/
  }

  bool _shouldRenderIsland(Island island, Island? neighbor, bool singleIsland) {
    if (neighbor?.id != island.id) {
      if (singleIsland) {
        return (neighbor != island);
      } else {
        return (neighbor?.owner != island.owner) || (island.owner == null);
      }
    } else {
      return false;
    }
  }

  void renderTile({
    required Tile tile,
    required Canvas canvas,
  }) {
    //final double i = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    //final double j = topGap + ((tile.x + tile.y) * (tileHeight / 2));

    /*_drawImageFull(
      canvas: canvas,
      offset: Offset(
        i - (tileWidth / 2),
        j - (tileHeight / 2),
      ),
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      image: Images.image(tile.tileType.sprite),
    );*/

    /*if (islandStatus.isExplored) {
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

      if (tile.building != null) {
        _drawImageHalf(
          canvas: canvas,
          offset: Offset(i, j),
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          image: Images.image(tile.building!.buildingType.sprite),
        );
      }
    } else if (islandStatus.isUnexplored) {
      final Path path = Path();
      path.moveTo(i, j - (tileHeight / 2));
      path.lineTo(i + (tileWidth / 2), j);
      path.lineTo(i, j + (tileHeight / 2));
      path.lineTo(i - (tileWidth / 2), j);
      path.close();

      canvas.drawPath(path, paintTileUnexplored);
    }*/
  }

  void _drawImage({
    required Canvas canvas,
    required Offset center,
    required double width,
    required double height,
    required Image image,
  }) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCenter(center: center, width: width, height: height),
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

  bool isInsideIsland({
    required Island island,
    required Offset offset,
  }) =>
      island.tiles.any((tile) => _isInsideTile(
            tile: tile,
            offset: offset,
          ));

  // https://math.stackexchange.com/questions/312403/how-do-i-determine-if-a-point-is-within-a-rhombus
  bool _isInsideTile({
    required Tile tile,
    required Offset offset,
  }) {
    //final double qx = (canvasWidth / 2) + ((tile.x - tile.y) * (tileWidth / 2));
    //final double qy = topGap + ((tile.x + tile.y) * (tileHeight / 2));
    final Offset center = _tileCenter(tile);
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
        sqrt(pow(offset.dx - center.dx, 2) + pow(offset.dy - center.dy, 2));

    return distance <= (tileHeight / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
