import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/model/headquarters.dart';
import 'package:tensionnode/model/lane.dart';
import 'package:tensionnode/model/mine.dart';
import 'package:tensionnode/model/node.dart';
import 'package:tensionnode/model/pointer_highlight.dart';
import 'package:tensionnode/model/renderer.dart';

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
    renderer = Renderer(map: map);

    final Headquarters headquarters = Headquarters(
      position: const Offset(0, 0),
    );

    final Mine mine1 = Mine(
      position: const Offset(-10, -5),
    );

    lanes.add(
      const Lane(
        from: Offset(-10, -5),
        to: Offset(-10, 0),
      ),
    );
    lanes.add(
      const Lane(
        from: Offset(-10, 0),
        to: Offset(0, 0),
      ),
    );

    nodes.add(headquarters);
    nodes.add(mine1);

    map.setCenter(transformationController);
  }

  void onPointerHover(PointerHoverEvent event) {
    pointerHighlight.setPosition(
      event.localPosition.nodePosition(map: map),
    );
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset localPosition = details.localPosition.nodePosition(map: map);
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
