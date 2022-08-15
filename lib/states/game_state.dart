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
import 'package:tensionnode/model/pointer_highlight.dart';
import 'package:tensionnode/services/assets.dart';

class GameState extends BaseState {
  final TransformationController transformationController = TransformationController();
  final PointerHighlight pointerHighlight = PointerHighlight();

  late final GameMap map;
  late final Renderer renderer;
  late final Headquarters headquarters;
  late final Nodes nodes;
  late final Lanes lanes;

  bool loaded = false;

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
    pointerHighlight.setPosition(map.realToGame(event.localPosition));
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset localPosition = map.realToGame(details.localPosition);
    print('TAP: (${localPosition.dx}, ${localPosition.dy})');
    //path.contains(Offset(x, y));
  }

  void update(double dt) {
    headquarters.resource1 += dt * 10;
    headquarters.resource2 += dt * 5;
    headquarters.resource3 += dt * 2;

    nodes.update(dt);

    Delayed.post(notify);
  }
}
