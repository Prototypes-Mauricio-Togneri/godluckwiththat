import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/images.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MapWidget extends StatelessWidget {
  final GameState state;

  const MapWidget(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: Center(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(0),
            minScale: 0.1,
            maxScale: 5,
            child: GestureDetector(
              onTapDown: state.onTapDown,
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: CustomPaint(
                  painter: MapPainter(
                    canvasWidth: constraints.maxWidth.toInt(),
                    canvasHeight: constraints.maxHeight.toInt(),
                    state: state,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final GameState state;

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
    mapSize = sqrt(state.colony.zones.length).toInt();
    CANVAS_WIDTH = canvasWidth;
    CANVAS_HEIGHT = canvasHeight;
    TILE_WIDTH = CANVAS_WIDTH / (mapSize + 1);
    TILE_HEIGHT = TILE_WIDTH / 2;
    TOP_GAP = CANVAS_HEIGHT - (TILE_HEIGHT * mapSize) - TILE_HEIGHT;
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
              tileWidth: TILE_WIDTH,
              tileHeight: TILE_HEIGHT,
              topGap: TOP_GAP,
            );
          }
        }
      }
    }

    /*if (state.selectedZone != null) {
      state.selectedZone!.renderer.renderSelected(
        canvas: canvas,
        canvasWidth: CANVAS_WIDTH,
        tileWidth: TILE_WIDTH,
        tileHeight: TILE_HEIGHT,
        topGap: TOP_GAP,
      );
    }*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ZonePainter extends CustomPainter {
  final Colony colony;
  final Zone zone;
  final bool mouseOver;
  final bool selected;
  final Paint borderHoverColor = Paint();
  final Paint borderSelectedColor = Paint();
  final Paint borderOwnedColor = Paint();
  static final Paint imagePaint = Paint();

  ZonePainter({
    required this.colony,
    required this.zone,
    required this.mouseOver,
    required this.selected,
  }) {
    borderHoverColor.color = Palette.white;
    borderHoverColor.style = PaintingStyle.stroke;
    borderHoverColor.strokeWidth = 4;

    borderSelectedColor.color = Palette.white;
    borderSelectedColor.style = PaintingStyle.stroke;
    borderSelectedColor.strokeWidth = 4;

    borderOwnedColor.color = Constants.PLAYER_COLOR;
    borderOwnedColor.style = PaintingStyle.stroke;
    borderOwnedColor.strokeWidth = 4;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (zone.status.isExplored) {
      for (final Tile tile in zone.tiles) {
        _drawImageFull(canvas, size, Images.image(tile.tileType.sprite));

        if (tile.patchType != null) {
          _drawImageHalf(canvas, size, Images.image(tile.patchType!.sprite));
        }
      }
    }

    /*if (zone.isOwned) {
      final Zone? zoneTop = colony.getNeighborTop(zone);

      if ((zoneTop == null) || (!zoneTop.isOwned)) {
        canvas.drawLine(
          const Offset(0, 2),
          Offset(size.width, 2),
          borderOwnedColor,
        );
      }

      final Zone? zoneBottom = colony.getNeighborBottom(zone);

      if ((zoneBottom == null) || (!zoneBottom.isOwned)) {
        canvas.drawLine(
          Offset(0, size.height - 2),
          Offset(size.width, size.height - 2),
          borderOwnedColor,
        );
      }

      final Zone? zoneLeft = colony.getNeighborLeft(zone);

      if ((zoneLeft == null) || (!zoneLeft.isOwned)) {
        canvas.drawLine(
          const Offset(2, 0),
          Offset(2, size.height),
          borderOwnedColor,
        );
      }

      final Zone? zoneRight = colony.getNeighborRight(zone);

      if ((zoneRight == null) || (!zoneRight.isOwned)) {
        canvas.drawLine(
          Offset(size.width - 2, 0),
          Offset(size.width - 2, size.height),
          borderOwnedColor,
        );
      }
    }*/

    if (selected) {
      canvas.drawRect(
        Rect.fromLTWH(
          2,
          2,
          size.width - 4,
          size.height - 4,
        ),
        borderSelectedColor,
      );
    } else if (mouseOver) {
      canvas.drawRect(
        Rect.fromLTWH(
          2,
          2,
          size.width - 4,
          size.height - 4,
        ),
        borderHoverColor,
      );
    }

    if (zone.building != null) {
      final TextStyle textStyle = TextStyle(
        color: Colors.white,
        fontSize: size.width / 10,
      );
      final TextSpan textSpan = TextSpan(
        text: zone.building!.buildingLabel,
        style: textStyle,
      );
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final double xCenter = size.width - textPainter.width - size.width / 15;
      final double yCenter = size.width / 15;
      final Offset offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawImageFull(Canvas canvas, Size size, ui.Image image) {
    final double imageSize =
        max(image.width.toDouble(), image.height.toDouble());
    final double scale = size.width / imageSize;
    canvas.save();
    canvas.scale(scale);
    canvas.drawImage(image, const Offset(0, 0), imagePaint);
    canvas.restore();
  }

  void _drawImageHalf(Canvas canvas, Size size, ui.Image image) {
    final double imageSize =
        max(image.width.toDouble(), image.height.toDouble());
    const double ratio = 0.5;
    final double scale = (size.width / imageSize) * ratio;
    canvas.save();
    canvas.scale(scale);
    canvas.drawImage(
        image,
        Offset(
          size.width / 2,
          size.height / 2,
        ),
        imagePaint);
    canvas.restore();
  }
}
