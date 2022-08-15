import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/lanes.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/game_map.dart';
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
    nodes.addMine(-10, -5);
    nodes.addIntersection(-10, -4);
    nodes.addIntersection(-10, -3);
    nodes.addIntersection(-10, -2);
    nodes.addIntersection(-10, -1);
    nodes.addIntersection(-10, 0);
    nodes.addIntersection(-9, 0);
    nodes.addIntersection(-8, 0);
    nodes.addIntersection(-7, 0);
    nodes.addIntersection(-6, 0);
    nodes.addIntersection(-5, 0);
    nodes.addIntersection(-4, 0);
    nodes.addIntersection(-3, 0);
    nodes.addIntersection(-2, 0);
    nodes.addIntersection(-1, 0);

    lanes.add(nodes.at(-10, -5), nodes.at(-10, -4));
    lanes.add(nodes.at(-10, -4), nodes.at(-10, -3));
    lanes.add(nodes.at(-10, -4), nodes.at(-10, -3));
    lanes.add(nodes.at(-10, -3), nodes.at(-10, -2));
    lanes.add(nodes.at(-10, -2), nodes.at(-10, -1));
    lanes.add(nodes.at(-10, -1), nodes.at(-10, 0));
    lanes.add(nodes.at(-10, 0), nodes.at(-9, 0));
    lanes.add(nodes.at(-9, 0), nodes.at(-8, 0));
    lanes.add(nodes.at(-8, 0), nodes.at(-7, 0));
    lanes.add(nodes.at(-7, 0), nodes.at(-6, 0));
    lanes.add(nodes.at(-6, 0), nodes.at(-5, 0));
    lanes.add(nodes.at(-5, 0), nodes.at(-4, 0));
    lanes.add(nodes.at(-4, 0), nodes.at(-3, 0));
    lanes.add(nodes.at(-3, 0), nodes.at(-2, 0));
    lanes.add(nodes.at(-2, 0), nodes.at(-1, 0));
    lanes.add(nodes.at(-1, 0), nodes.at(0, 0));

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
