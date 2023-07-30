import 'dart:math';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MapWidget extends StatelessWidget {
  final GameState state;

  const MapWidget(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int y = 0; y < state.mapHeight; y++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int x = 0; x < state.mapWidth; x++)
                    MapTile(
                      state: state,
                      zone: state.zoneById('$x,$y'),
                      size: constraints.maxHeight /
                          (max(state.mapHeight, state.mapWidth) + 1),
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
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
        ((zone.building != null) || (zone.patch != null))) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (zone.patch != null)
            Image.asset(
              zone.patch!.sprite,
              width: size,
              height: size,
              scale: 0.5,
            ),
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
  final Zone zone;
  final bool mouseOver;
  final bool selected;
  final Paint backgroundColor = Paint();
  final Paint borderHoverColor = Paint();
  final Paint borderSelectedColor = Paint();
  final Paint borderOwnedColor = Paint();

  ZonePainter({
    required this.zone,
    required this.mouseOver,
    required this.selected,
  }) {
    backgroundColor.color = zone.color;
    backgroundColor.style = PaintingStyle.fill;

    borderHoverColor.color = Palette.white;
    borderHoverColor.style = PaintingStyle.stroke;
    borderHoverColor.strokeWidth = 2;

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
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        backgroundColor,
      );
    }

    if (zone.isOwned) {
      canvas.drawRect(
        Rect.fromLTWH(
          2,
          2,
          size.width - 4,
          size.height - 4,
        ),
        borderOwnedColor,
      );
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
          1,
          1,
          size.width - 2,
          size.height - 2,
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
}
