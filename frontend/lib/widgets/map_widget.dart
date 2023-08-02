import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/ui/map_painter.dart';

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
