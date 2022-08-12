import 'package:dafluta/dafluta.dart';
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
      child: CustomPaint(
        painter: MapBackgroundPainter(),
        foregroundPainter: MapForegroundPainter(),
        child: Container(),
      ),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Palette.grey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.5;

    const int blockSize = 20;
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
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = 5;
    final Offset offset = Offset(size.width * 0.5, size.height * 0.5);

    final Rect rect = Rect.fromCenter(center: offset, width: 50, height: 50);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MainState extends BaseState {}
