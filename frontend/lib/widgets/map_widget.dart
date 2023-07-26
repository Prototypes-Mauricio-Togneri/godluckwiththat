import 'dart:math';

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
            for (int i = 0; i < state.mapHeight; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < state.mapWidth; j++)
                    MapTile(
                      state: state,
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
          ),
        ),
      ),
    );
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
    borderHoverColor.strokeWidth = 3;

    borderSelectedColor.color = Palette.white;
    borderSelectedColor.style = PaintingStyle.stroke;
    borderSelectedColor.strokeWidth = 5;

    borderOwnedColor.color = Constants.PLAYER_COLOR;
    borderOwnedColor.style = PaintingStyle.stroke;
    borderOwnedColor.strokeWidth = 5;
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
          0,
          0,
          size.width,
          size.height,
        ),
        borderOwnedColor,
      );
    }

    if (selected) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        borderSelectedColor,
      );
    } else if (mouseOver) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        borderHoverColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
