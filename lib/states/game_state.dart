import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/lanes.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/game_map.dart';
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
  final Nodes nodes = Nodes();
  final Lanes lanes = Lanes();

  num resource1 = 300;
  num resource2 = 200;
  num resource3 = 100;

  GameState() {
    renderer = Renderer(map);

    nodes.addHQ(0, 0);
    final Node mine = nodes.addMine(-10, -5);
    final Node i1 = nodes.addIntersection(-10, -4);

    lanes.add(mine, i1);

    /*nodes.addAll([
      
      Intersection(
        position: const Offset(-10, -3),
      ),
      Intersection(
        position: const Offset(-10, -2),
      ),
      Intersection(
        position: const Offset(-10, -1),
      ),
      Intersection(
        position: const Offset(-10, 0),
      ),
      Intersection(
        position: const Offset(-9, 0),
      ),
      Intersection(
        position: const Offset(-8, 0),
      ),
      Intersection(
        position: const Offset(-7, 0),
      ),
      Intersection(
        position: const Offset(-6, 0),
      ),
      Intersection(
        position: const Offset(-5, 0),
      ),
      Intersection(
        position: const Offset(-4, 0),
      ),
      Intersection(
        position: const Offset(-3, 0),
      ),
      Intersection(
        position: const Offset(-2, 0),
      ),
      Intersection(
        position: const Offset(-1, 0),
      ),
    ]);*/

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

    nodes.update(dt);

    Delayed.post(notify);
  }
}
