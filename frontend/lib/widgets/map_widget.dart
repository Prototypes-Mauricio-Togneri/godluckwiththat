import 'dart:math';
import 'dart:ui' as ui;
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/colony.dart';
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
                    colony: state.colony,
                    zones: state.colony.zones,
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
  final int canvasWidth;
  final int canvasHeight;
  final Colony colony;
  final List<Zone> zones;
  int mapSize = 0;
  double tileWidth = 0;
  double tileHeight = 0;
  double topGap = 0;

  MapPainter({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.zones,
    required this.colony,
  }) {
    mapSize = sqrt(zones.length).toInt();
    tileWidth = canvasWidth / (mapSize + 1);
    tileHeight = tileWidth / 2;
    topGap = canvasHeight - (tileHeight * mapSize) - tileHeight;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int y = 0; y < mapSize; y++) {
      for (int x = 0; x < mapSize; x++) {
        final Zone? zone = colony.zoneById('$x,$y');

        if (zone != null) {
          zone.renderer.render(
            canvas: canvas,
            canvasWidth: canvasWidth,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            topGap: topGap,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MapTile extends StatefulWidget {
  final GameState state;
  final Zone zone;
  final double size;

  const MapTile({
    required this.state,
    required this.zone,
    required this.size,
  });

  @override
  State<MapTile> createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> {
  bool mouseOver = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.state.onZoneClicked(widget.zone),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() {
          mouseOver = true;
        }),
        onExit: (event) => setState(() {
          mouseOver = false;
        }),
        child: Container(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: ZonePainter(
              colony: widget.state.colony,
              zone: widget.zone,
              mouseOver: mouseOver,
              selected: widget.state.selectedZone == widget.zone,
            ),
            child: ZoneImage(
              zone: widget.zone,
              size: widget.size,
            ),
          ),
        ),
      ),
    );
  }
}

class ZoneImage extends StatelessWidget {
  final Zone zone;
  final double size;

  const ZoneImage({
    required this.zone,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (zone.status.isExplored &&
        ((zone.building != null) || (zone.patchType != null))) {
      return Stack(
        alignment: Alignment.center,
        children: [
          /*if (zone.patch != null)
            Image.asset(
              zone.patch!.sprite,
              width: size,
              height: size,
              scale: 0.5,
            ),*/
          if (zone.building != null)
            Image.asset(
              zone.building!.buildingType.sprite,
              width: size * 0.5,
              height: size * 0.5,
            ),
        ],
      );
    } else {
      return const Empty();
    }
  }
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
      _drawImageFull(canvas, size, Images.image(zone.zoneType.sprite));

      if (zone.patchType != null) {
        _drawImageHalf(canvas, size, Images.image(zone.patchType!.sprite));
      }
    }

    if (zone.isOwned) {
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
    }

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
