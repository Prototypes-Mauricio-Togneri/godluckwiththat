import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';

const int blockSize = 20;

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
    return const Scaffold(
      backgroundColor: Palette.black,
      body: Map(),
    );
  }
}

class Map extends StatelessWidget {
  const Map();

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 10,
      constrained: false,
      child: GestureDetector(
        onTapUp: _onTapUp,
        child: CustomPaint(
          size: const Size(blockSize * 120, blockSize * 80),
          painter: MapBackgroundPainter(),
          foregroundPainter: MapForegroundPainter(),
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails details) {
    print('TAP: ${details.localPosition}');
    //path.contains(Offset(x, y));
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    paint.color = Palette.gridBackground;
    paint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    paint.color = Palette.gridLine;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.3;

    final int numHorizontal = size.width ~/ blockSize;
    final int numVertical = size.height ~/ blockSize;

    for (int i = 1; i < numHorizontal; i++) {
      final double x = (i * blockSize).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 1; i < numVertical; i++) {
      final double y = (i * blockSize).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapForegroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeJoin = StrokeJoin.miter;
    paint.strokeWidth = 1;

    final Path path = Path();
    path.moveTo(1000, 390);
    path.lineTo(1010, 400);
    path.lineTo(1000, 410);
    path.lineTo(990, 400);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MainState extends BaseState {}
