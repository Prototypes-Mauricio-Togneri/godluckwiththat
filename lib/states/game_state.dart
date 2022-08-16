import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/lanes.dart';
import 'package:tensionnode/engine/loader.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/pointer_highlight.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

class GameState extends BaseState {
  final TransformationController transformationController = TransformationController();
  final PointerHighlight _pointerHighlight = PointerHighlight();

  late final GameMap map;
  late final Renderer renderer;
  late final Headquarters headquarters;
  late final Nodes nodes;
  late final Lanes lanes;

  bool loaded = false;
  Node? _nodeClicked;

  bool get hasNodeClicked => _nodeClicked != null;

  Node get nodeClicked => _nodeClicked!;

  @override
  Future onLoad() async {
    final JsonMatch match = await Loader.match(Assets.MAPS_MAP1);
    map = match.getMap();
    nodes = match.getNodes();
    headquarters = nodes.headquarters;
    lanes = match.getLanes(nodes);
    renderer = Renderer(map);
    map.setCenter(transformationController);
    loaded = true;
    notify();
  }

  void onPointerHover(PointerHoverEvent event) {
    final Offset position = map.realToGame(event.localPosition);
    _pointerHighlight.setPosition(position);
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset position = map.realToGame(details.localPosition);
    print('TAP: (${position.dx}, ${position.dy})');
    //path.contains(Offset(x, y));

    _nodeClicked = nodes.at(position);
    notify();
  }

  void onDestroyNode(Node node) {
    _nodeClicked = null;
    notify();
  }

  void update(double dt) {
    headquarters.resource1 += dt * 10;
    headquarters.resource2 += dt * 5;
    headquarters.resource3 += dt * 2;

    nodes.update(dt);

    Delayed.post(notify);
  }

  void renderBackground(Canvas canvas, Size size) {
    for (int i = 1; i < map.dimensions.width; i++) {
      final double x = (i * map.blockSize).toDouble();
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), Palette.gridPaint);
    }

    for (int i = 1; i < map.dimensions.height; i++) {
      final double y = (i * map.blockSize).toDouble();
      canvas.drawLine(Offset(0, y), Offset(size.width, y), Palette.gridPaint);
    }
  }

  void renderForeground(Canvas canvas) {
    renderer.setCanvas(canvas);
    lanes.render(renderer);
    nodes.render(renderer);
    _pointerHighlight.render(renderer);
  }
}
