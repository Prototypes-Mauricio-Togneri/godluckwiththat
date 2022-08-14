import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/model/resource.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance() => GameScreen(GameState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      body: Stack(
        children: [
          Map(state),
          GameLoop(state),
        ],
      ),
    );
  }
}

class Map extends StatelessWidget {
  final GameState state;

  const Map(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.gridBackground,
      child: StateProvider<GameState>(
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
          resource.value.toInt().toString(),
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
  late final Paint gridPaint;

  MapBackgroundPainter(this.state) {
    gridPaint = Paint();
    gridPaint.color = Palette.gridLine;
    gridPaint.style = PaintingStyle.stroke;
    gridPaint.strokeWidth = 0.1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < state.numberOfNodesHorizontal; i++) {
      final double x = (i * state.blockSize).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 1; i < state.numberOfNodesVertical; i++) {
      final double y = (i * state.blockSize).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
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
    final Renderer renderer = Renderer(
      blockSize: state.blockSize,
      canvas: canvas,
    );

    state.headquarters.render(renderer);

    if (state.hasHighlightedNode) {
      renderer.diamondFilled(
        position: state.highlightedNode,
        color: Palette.highlightNode,
        size: state.blockSize / 10,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameLoop extends StatefulWidget {
  final GameState state;

  const GameLoop(this.state);

  @override
  State<GameLoop> createState() => _GameLoopState();
}

class _GameLoopState extends State<GameLoop> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final DateTime _initialTime = DateTime.now();
  double previous = 0;
  double get currentTime => DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;

  @override
  void initState() {
    super.initState();
    previous = currentTime;
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double current = currentTime;
        final double dt = current - previous;
        widget.state.update(dt);
        previous = current;

        return const Empty();
      },
    );
  }
}
