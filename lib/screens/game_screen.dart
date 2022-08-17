import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/widgets/hud.dart';
import 'package:tensionnode/widgets/menu.dart';

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
        builder: (context, state) => state.loaded ? MapContent(state) : const Empty(),
      ),
    );
  }
}

class MapContent extends StatelessWidget {
  final GameState state;

  const MapContent(this.state);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: state.onKeyPressed,
          child: InteractiveViewer(
            transformationController: state.transformationController,
            minScale: 1,
            maxScale: state.map.maxZoom,
            constrained: false,
            onInteractionStart: state.onViewerInteraction,
            child: Listener(
              onPointerHover: state.onPointerHover,
              child: GestureDetector(
                onTapUp: state.onLeftClick,
                onSecondaryTapUp: state.onRightClick,
                onTertiaryTapUp: state.onMiddleClick,
                child: CustomPaint(
                  size: state.map.size,
                  painter: MapBackgroundPainter(state),
                  foregroundPainter: MapForegroundPainter(state),
                ),
              ),
            ),
          ),
        ),
        Hud(state),
        Menu(state),
      ],
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  final GameState state;

  const MapBackgroundPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) => state.renderBackground(canvas, size);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapForegroundPainter extends CustomPainter {
  final GameState state;

  const MapForegroundPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) => state.renderForeground(canvas);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
