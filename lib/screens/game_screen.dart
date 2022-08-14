import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/extensions/path_extension.dart';
import 'package:tensionnode/model/resource.dart';
import 'package:tensionnode/services/palette.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance() => GameScreen(GameState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      body: Map(state),
    );
  }
}

class Map extends StatelessWidget {
  final GameState state;

  const Map(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<GameState>(
      state: state,
      builder: (context, state) => Stack(
        children: [
          InteractiveViewer(
            transformationController: state.transformationController,
            minScale: 1,
            maxScale: 20,
            constrained: false,
            child: Listener(
              onPointerHover: state.onPointerHover,
              child: GestureDetector(
                onTapUp: state.onTapUp,
                child: CustomPaint(
                  size: state.mapSize,
                  painter: MapBackgroundPainter(state),
                  foregroundPainter: MapForegroundPainter(state),
                ),
              ),
            ),
          ),
          Hud(state),
        ],
      ),
    );
  }
}

class Hud extends StatelessWidget {
  final GameState state;

  const Hud(this.state);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        color: Palette.hudBackground,
        child: Row(
          children: [
            ResourceIndicator(state.resource1),
            const HBox(10),
            ResourceIndicator(state.resource2),
            const HBox(10),
            ResourceIndicator(state.resource3),
          ],
        ),
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final Resource resource;

  const ResourceIndicator(this.resource);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Palette.hudResourceIndicator,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          resource.value.toString(),
          style: const TextStyle(
            color: Palette.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  final GameState state;

  const MapBackgroundPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    paint.color = Palette.gridBackground;
    paint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    paint.color = Palette.gridLine;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.1;

    for (int i = 1; i < state.numberOfNodesHorizontal; i++) {
      final double x = (i * state.blockSize).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 1; i < state.numberOfNodesVertical; i++) {
      final double y = (i * state.blockSize).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    if (state.hasHighlightedNode) {
      final Paint paint = Paint();
      paint.color = Palette.highlightNode;
      paint.style = PaintingStyle.fill;

      final Path path = Path();
      path.diamond(
        position: state.highlightedNode,
        blockSize: state.blockSize,
        size: 1,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MapForegroundPainter extends CustomPainter {
  final GameState state;

  const MapForegroundPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Palette.hq;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;
    paint.strokeWidth = 0.5;

    final Path path = Path();
    path.diamond(
      position: state.hqPosition,
      blockSize: state.blockSize,
      size: state.blockSize,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameState extends BaseState {
  final _transformationController = TransformationController();
  final int _blockSize = 10;
  final int _numberOfNodesHorizontal = 100;
  final int _numberOfNodesVertical = 100;

  final Offset hqPosition = const Offset(50, 40);
  Offset? _highlightedNode;

  final Resource resource1 = const Resource(name: 'Copper', value: 300);
  final Resource resource2 = const Resource(name: 'Iron', value: 200);
  final Resource resource3 = const Resource(name: 'Titanium', value: 100);

  GameState() {
    const double zoom = 5;
    final Size size = WidgetsBinding.instance.window.physicalSize;
    final double xTranslate = (hqPosition.dx * _blockSize * zoom) - (size.width / 2);
    final double yTranslate = (hqPosition.dy * _blockSize * zoom) - (size.height / 2);

    _transformationController.value.setEntry(0, 0, zoom);
    _transformationController.value.setEntry(1, 1, zoom);
    _transformationController.value.setEntry(2, 2, zoom);
    _transformationController.value.setEntry(0, 3, -xTranslate);
    _transformationController.value.setEntry(1, 3, -yTranslate);
  }

  Size get mapSize => Size(
        (_blockSize * _numberOfNodesHorizontal).toDouble(),
        (_blockSize * _numberOfNodesVertical).toDouble(),
      );

  int get blockSize => _blockSize;

  int get numberOfNodesHorizontal => _numberOfNodesHorizontal;

  int get numberOfNodesVertical => _numberOfNodesVertical;

  bool get hasHighlightedNode => _highlightedNode != null;

  Offset get highlightedNode => _highlightedNode ?? Offset.zero;

  TransformationController get transformationController => _transformationController;

  void onPointerHover(PointerHoverEvent event) {
    _highlightedNode = event.localPosition.nodePosition(blockSize);
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset localPosition = details.localPosition.nodePosition(blockSize);
    print('TAP: (${localPosition.dx}, ${localPosition.dy})');
    //path.contains(Offset(x, y));
  }
}
