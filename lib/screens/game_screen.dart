import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/model/menu_info.dart';
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
                  if (state.hasMenu)
                    if (state.menuInfo!.hasNode)
                      NodeMenu(
                        state: state,
                        menuInfo: state.menuInfo!,
                      )
                    else
                      EmptyMenu(
                        state: state,
                        menuInfo: state.menuInfo!,
                      ),
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

class NodeMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const NodeMenu({
    required this.state,
    required this.menuInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: menuInfo.realPosition.dy,
      left: menuInfo.realPosition.dx,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Palette.hudBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              menuInfo.node!.type.name,
              style: const TextStyle(
                color: Palette.white,
              ),
            ),
            const VBox(10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.red),
              onPressed: () => state.onDestroyNode(menuInfo.node!),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  HBox(5),
                  Text('Destroy'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const EmptyMenu({
    required this.state,
    required this.menuInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: menuInfo.realPosition.dy,
      left: menuInfo.realPosition.dx,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Palette.hudBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Palette.blue),
              onPressed: () => state.onCreateNode(menuInfo.gamePosition),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.build,
                    size: 20,
                  ),
                  HBox(5),
                  Text('Build'),
                ],
              ),
            ),
          ],
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
