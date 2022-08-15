import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
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
          MapPainter(state),
          GameLoop(state),
        ],
      ),
    );
  }
}

class MapPainter extends StatelessWidget {
  final GameState state;

  const MapPainter(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.gridBackground,
      child: StateProvider<GameState>(
        state: state,
        builder: (context, state) => state.loaded
            ? Stack(
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
                          size: state.map.size,
                          painter: MapBackgroundPainter(state),
                          foregroundPainter: MapForegroundPainter(state),
                        ),
                      ),
                    ),
                  ),
                  Hud(state),
                ],
              )
            : const Empty(),
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
            const HBox(10),
            ResourceIndicator(
              name: 'Copper',
              value: state.headquarters.resource1,
            ),
            const HBox(30),
            ResourceIndicator(
              name: 'Iron',
              value: state.headquarters.resource2,
            ),
            const HBox(30),
            ResourceIndicator(
              name: 'Titanium',
              value: state.headquarters.resource3,
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final String name;
  final num value;

  const ResourceIndicator({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Palette.white,
            fontSize: 15,
          ),
        ),
        const HBox(10),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Palette.hudResourceIndicator,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: Palette.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  final GameState state;

  const MapBackgroundPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < state.map.dimensions.width; i++) {
      final double x = (i * state.map.blockSize).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), Palette.gridPaint);
    }

    for (int i = 1; i < state.map.dimensions.height; i++) {
      final double y = (i * state.map.blockSize).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), Palette.gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapForegroundPainter extends CustomPainter {
  final GameState state;

  const MapForegroundPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    state.renderer.setCanvas(canvas);
    state.lanes.render(state.renderer);
    state.nodes.render(state.renderer);
    state.pointerHighlight.render(state.renderer);
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

        if (widget.state.loaded) {
          widget.state.update(dt);
        }

        previous = current;

        return const Empty();
      },
    );
  }
}
