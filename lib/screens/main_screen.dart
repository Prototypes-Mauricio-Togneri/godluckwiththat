import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';

class MainScreen extends StatelessWidget {
  final MainState state;

  const MainScreen(this.state);

  factory MainScreen.instance() => MainScreen(MainState());

  @override
  Widget build(BuildContext context) {
    return StateProvider<MainState>(
      state: state,
      builder: (context, state) => Content(state),
    );
  }
}

class Content extends StatelessWidget {
  final MainState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      body: Map(state),
    );
  }
}

class Map extends StatelessWidget {
  final MainState state;

  const Map(this.state);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: state.transformationController,
      minScale: 1,
      maxScale: 10,
      constrained: false,
      child: Listener(
        onPointerHover: _onPointerHover,
        child: GestureDetector(
          onTapUp: _onTapUp,
          child: CustomPaint(
            size: state.mapSize,
            painter: MapBackgroundPainter(
              numberOfNodesHorizontal: state.numberOfNodesHorizontal,
              numberOfNodesVertical: state.numberOfNodesVertical,
              blockSize: state.blockSize,
            ),
            foregroundPainter: MapForegroundPainter(
              state.hqPosition,
              state.blockSize,
            ),
          ),
        ),
      ),
    );
  }

  void _onPointerHover(PointerHoverEvent event) {
    //print(event.position);
  }

  void _onTapUp(TapUpDetails details) {
    print('TAP: (${details.localPosition.dx.toInt()}, ${details.localPosition.dy.toInt()})');
    //path.contains(Offset(x, y));
  }
}

class MapBackgroundPainter extends CustomPainter {
  final int numberOfNodesHorizontal;
  final int numberOfNodesVertical;
  final int blockSize;

  const MapBackgroundPainter({
    required this.numberOfNodesHorizontal,
    required this.numberOfNodesVertical,
    required this.blockSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    paint.color = Palette.gridBackground;
    paint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    paint.color = Palette.gridLine;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.3;

    for (int i = 1; i < numberOfNodesHorizontal; i++) {
      final double x = (i * blockSize).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 1; i < numberOfNodesVertical; i++) {
      final double y = (i * blockSize).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapForegroundPainter extends CustomPainter {
  final Offset hqPosition;
  final int blockSize;

  const MapForegroundPainter(this.hqPosition, this.blockSize);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;
    paint.strokeWidth = 1;

    final Path path = Path();
    path.moveTo(hqPosition.dx * blockSize, (hqPosition.dy * blockSize) - (blockSize / 2));
    path.lineTo((hqPosition.dx * blockSize) + (blockSize / 2), hqPosition.dy * blockSize);
    path.lineTo(hqPosition.dx * blockSize, (hqPosition.dy * blockSize) + (blockSize / 2));
    path.lineTo((hqPosition.dx * blockSize) - (blockSize / 2), hqPosition.dy * blockSize);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MainState extends BaseState {
  final _transformationController = TransformationController();
  final int _blockSize = 20;
  final int _numberOfNodesHorizontal = 100;
  final int _numberOfNodesVertical = 100;

  final Offset hqPosition = const Offset(50, 40);

  MainState() {
    const double zoom = 2;
    final double xTranslate = (hqPosition.dx * _blockSize * zoom) - 960;
    final double yTranslate = (hqPosition.dy * _blockSize * zoom) - 490;

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

  TransformationController get transformationController => _transformationController;
}
