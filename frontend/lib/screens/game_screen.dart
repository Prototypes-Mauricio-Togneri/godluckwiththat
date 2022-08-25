import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/states/hud_state.dart';
import 'package:tensionnode/states/map_layout_state.dart';
import 'package:tensionnode/states/map_loaded_state.dart';
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
          ScreenLayout(state),
          GameLoop(state),
        ],
      ),
    );
  }
}

class ScreenLayout extends StatelessWidget {
  final GameState state;

  const ScreenLayout(this.state);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalHud(state),
            Expanded(
              child: Column(
                children: [
                  HorizontalHudContainer(state.hudState),
                  MapContainer(state),
                ],
              ),
            ),
          ],
        ),
        MenuContainer(state),
      ],
    );
  }
}

class HorizontalHudContainer extends StatelessWidget {
  final HudState state;

  const HorizontalHudContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<HudState>(
      state: state,
      builder: (context, state) => HorizontalHud(state),
    );
  }
}

class MenuContainer extends StatelessWidget {
  final GameState state;

  const MenuContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<GameState>(
      state: state,
      builder: (context, state) => (state.hasMenu) ? Menu(state) : const Empty(),
    );
  }
}

class MapContainer extends StatelessWidget {
  final GameState state;

  const MapContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<MapLoadedState>(
      state: state.mapLoadedState,
      builder: (context, mapLoadedState) => mapLoadedState.loaded ? MapLayout(state) : const Empty(),
    );
  }
}

class MapLayout extends StatelessWidget {
  final GameState state;

  const MapLayout(this.state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Palette.gridBackground,
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: state.onKeyPressed,
          child: LayoutBuilder(builder: (context, constraints) {
            state.map.mapLayoutSize = Size(constraints.maxWidth, constraints.maxHeight);

            return StateProvider<MapLayoutState>(
              state: state.mapLayoutState,
              builder: (context, mapLayoutState) => InteractiveViewer(
                transformationController: state.map.transformationController,
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
            );
          }),
        ),
      ),
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

        if (widget.state.mapLoadedState.loaded) {
          widget.state.update(dt);
        }

        previous = current;

        return const Empty();
      },
    );
  }
}
