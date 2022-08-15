import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/model/lane.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/mine.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/pointer_highlight.dart';

class GameState extends BaseState {
  final TransformationController transformationController = TransformationController();
  final GameMap map = const GameMap(
    numberOfBlocksHorizontal: 100,
    numberOfBlocksVertical: 100,
    blockSize: 10,
  );

  late final Renderer renderer;
  final PointerHighlight pointerHighlight = PointerHighlight();
  final List<Node> nodes = [];
  final List<Lane> lanes = [];

  num resource1 = 300;
  num resource2 = 200;
  num resource3 = 100;

  GameState() {
    renderer = Renderer(map);

    nodes.addAll([
      Headquarters(
        position: const Offset(0, 0),
      ),
      Mine(
        position: const Offset(-10, -5),
      )
    ]);

    lanes.addAll([
      const Lane(
        from: Offset(-10, -5),
        to: Offset(-10, 0),
      ),
      const Lane(
        from: Offset(-10, 0),
        to: Offset(0, 0),
      ),
    ]);

    map.setCenter(transformationController);
  }

  void onPointerHover(PointerHoverEvent event) {
    pointerHighlight.setPosition(map.realToGame(event.localPosition));
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset localPosition = map.realToGame(details.localPosition);
    print('TAP: (${localPosition.dx}, ${localPosition.dy})');
    //path.contains(Offset(x, y));
  }

  void update(double dt) {
    resource1 += dt * 10;
    resource2 += dt * 5;
    resource3 += dt * 2;

    for (final Node node in nodes) {
      node.update(dt);
    }

    Delayed.post(notify);
  }
}
