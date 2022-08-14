import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
      builder: (context, state) => InteractiveViewer(
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
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;
    paint.strokeWidth = 0.5;

    final Path path = Path();
    path.moveTo(state.hqPosition.dx * state.blockSize, (state.hqPosition.dy * state.blockSize) - (state.blockSize / 2));
    path.lineTo((state.hqPosition.dx * state.blockSize) + (state.blockSize / 2), state.hqPosition.dy * state.blockSize);
    path.lineTo(state.hqPosition.dx * state.blockSize, (state.hqPosition.dy * state.blockSize) + (state.blockSize / 2));
    path.lineTo((state.hqPosition.dx * state.blockSize) - (state.blockSize / 2), state.hqPosition.dy * state.blockSize);
    path.close();

    canvas.drawPath(path, paint);

    if (state.hasHighlightedNode) {
      final Paint paint = Paint();
      paint.color = Palette.highlightNode;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(state.highlightedNode, 0.5, paint);
    }
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
    final int x = (event.localPosition.dx / blockSize).round();
    final int y = (event.localPosition.dy / blockSize).round();

    _highlightedNode = Offset(x.toDouble() * _blockSize, y.toDouble() * _blockSize);
    notify();
  }

  void onTapUp(TapUpDetails details) {
    print('TAP: (${details.localPosition.dx.toInt()}, ${details.localPosition.dy.toInt()})');
    //path.contains(Offset(x, y));
  }
}
