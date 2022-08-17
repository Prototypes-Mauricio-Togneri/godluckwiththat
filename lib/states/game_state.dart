import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/engine/lanes.dart';
import 'package:tensionnode/engine/loader.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/patches.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/model/menu_info.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/pointer_highlight.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class GameState extends BaseState {
  final TransformationController transformationController = TransformationController();
  final PointerHighlight _pointerHighlight = PointerHighlight();

  late final GameMap map;
  late final Renderer renderer;
  late final Headquarters headquarters;
  late final Patches patches;
  late final Nodes nodes;
  late final Lanes lanes;

  bool loaded = false;
  MenuInfo? menuInfo;

  num energyProduced = 100;
  num energyConsumed = 50;

  bool get hasMenu => menuInfo != null;

  @override
  Future onLoad() async {
    final JsonMatch match = await Loader.match(Assets.MAPS_MAP1);
    map = match.getMap();
    patches = match.getPatches();
    nodes = match.getNodes();
    headquarters = nodes.headquarters;
    lanes = match.getLanes(nodes);
    renderer = Renderer(map);
    map.setCenter(transformationController);
    loaded = true;
    notify();
  }

  void onKeyPressed(RawKeyEvent event) {
    final double zoom = transformationController.value.getRow(0)[0];

    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) || (event.physicalKey == PhysicalKeyboardKey.keyW)) {
      transformationController.value.translate(0, zoom);
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) || (event.physicalKey == PhysicalKeyboardKey.keyS)) {
      transformationController.value.translate(0, -zoom);
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft) || (event.physicalKey == PhysicalKeyboardKey.keyA)) {
      transformationController.value.translate(zoom);
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight) || (event.physicalKey == PhysicalKeyboardKey.keyD)) {
      transformationController.value.translate(-zoom);
    }
  }

  void onPointerHover(PointerHoverEvent event) {
    final Offset position = map.realToGame(event.localPosition);
    _pointerHighlight.setPosition(position);
    notify();
  }

  void onLeftClick(TapUpDetails details) {
    if (menuInfo == null) {
      final Offset position = map.realToGame(details.localPosition);
      print('TAP: (${position.dx}, ${position.dy})');

      final Node? nodeClicked = nodes.at(position);

      if (nodeClicked != null) {
        menuInfo = MenuInfo.node(
          node: nodeClicked,
          realPosition: details.globalPosition,
          gamePosition: position,
        );
      } else {
        menuInfo = MenuInfo.empty(
          realPosition: details.globalPosition,
          gamePosition: position,
        );
      }

      notify();
    } else {
      menuInfo = null;
      notify();
    }
  }

  void onRightClick(TapUpDetails details) {
    print('RIGHT CLICK');
  }

  void onMiddleClick(TapUpDetails details) {
    print('MIDDLE CLICK');
  }

  void onMainMenu() {
    menuInfo = MenuInfo.main();
    notify();
  }

  void onRepair(Node node) {
    menuInfo = null;
    notify();
  }

  void onDestroyNode(Node node) {
    menuInfo = null;
    notify();
  }

  void onBuild(MenuInfo oldMenu) {
    menuInfo = MenuInfo.build(
      realPosition: oldMenu.realPosition!,
      gamePosition: oldMenu.gamePosition!,
    );
    notify();
  }

  void onCreateNode({
    required NodeType type,
    required Offset position,
  }) {
    menuInfo = null;
    notify();
  }

  void onContinue() {
    menuInfo = null;
    notify();
  }

  void onLoadGame() {
    menuInfo = null;
    notify();
  }

  void onSaveGame() {
    menuInfo = null;
    notify();
  }

  void onSettings() {
    menuInfo = null;
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
    patches.render(renderer);
    lanes.render(renderer);
    nodes.render(renderer);
    _pointerHighlight.render(renderer);
  }
}
