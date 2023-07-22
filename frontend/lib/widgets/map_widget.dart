import 'dart:math';

import 'package:flutter/material.dart';
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
            for (int i = 0; i < state.mapHeight; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < state.mapWidth; j++)
                    MapTile(
                      zone: state.zoneById('$i,$j'),
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
  final Zone zone;
  final double size;

  const MapTile({
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
    return MouseRegion(
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
          painter: ZonePainter(widget.zone, mouseOver),
        ),
      ),
    );
  }
}

class ZonePainter extends CustomPainter {
  final Zone zone;
  final bool mouseOver;
  final Paint backgroundColor = Paint();
  final Paint borderColor = Paint();

  ZonePainter(this.zone, this.mouseOver) {
    backgroundColor.color = zone.color;
    backgroundColor.style = PaintingStyle.fill;

    borderColor.color = Palette.white;
    borderColor.style = PaintingStyle.stroke;
    borderColor.strokeWidth = 3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      backgroundColor,
    );

    if (mouseOver) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        borderColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
