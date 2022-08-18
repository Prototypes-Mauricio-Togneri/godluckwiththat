import 'dart:html';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/connections.dart';
import 'package:tensionnode/engine/loader.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/patches.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/extensions/raw_key_event_extension.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/model/menu_info.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/pointer_highlight.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  final TransformationController transformationController = TransformationController();
  final PointerHighlight _pointerHighlight = PointerHighlight();

  late final GameMap map;
  late final Renderer renderer;
  late final Headquarters headquarters;
  late final Patches patches;
  late final Nodes nodes;
  late final Connections connections;

  bool loaded = false;
  bool running = true;
  MenuInfo? menuInfo;

  num get energyProduced => nodes.energyProduced;

  num get energyConsumed => nodes.energyConsumed;

  bool get hasMenu => menuInfo != null;

  @override
  Future onLoad() async {
    if (kIsWeb) {
      window.addEventListener('blur', onUnfocus);
    }

    final JsonMatch match = await Loader.match(Assets.MAPS_MAP1);
    map = match.getMap();
    patches = match.getPatches();
    nodes = match.getNodes();
    headquarters = nodes.headquarters;
    headquarters.resource1 = match.resources.resource1;
    headquarters.resource2 = match.resources.resource2;
    headquarters.resource3 = match.resources.resource3;
    connections = match.getConnections(nodes);
    renderer = Renderer(map);
    map.setCenter(transformationController);
    loaded = true;
    notify();
  }

  void onUnfocus(Event e) {
    onMainMenu();
  }

  void onViewerInteraction(ScaleStartDetails details) => closeMenu();

  void onKeyPressed(RawKeyEvent event) {
    final double zoom = map.maxZoom - transformationController.value.getRow(0)[0] + 1;

    if (event.isUp()) {
      transformationController.value.translate(0, zoom);
    } else if (event.isDown()) {
      transformationController.value.translate(0, -zoom);
    } else if (event.isLeft()) {
      transformationController.value.translate(zoom);
    } else if (event.isRight()) {
      transformationController.value.translate(-zoom);
    } else if (event.isSpace()) {
      renderer.toggleHP();
    } else if (event.isEscape()) {
      if (menuInfo == null) {
        onMainMenu();
      } else {
        onContinue();
      }
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
      final Node? nodeClicked = nodes.at(position);

      if (nodeClicked != null) {
        menuInfo = MenuInfo.node(
          node: nodeClicked,
          realPosition: details.globalPosition,
          gamePosition: position,
        );
      } else {
        menuInfo = MenuInfo.empty(
          patch: patches.at(position),
          realPosition: details.globalPosition,
          gamePosition: position,
        );
      }

      notify();
    } else {
      closeMenu();
    }
  }

  void onRightClick(TapUpDetails details) {
    closeMenu();
  }

  void onMiddleClick(TapUpDetails details) {
    final Offset position = map.realToGame(details.localPosition);
    final Node? nodeClicked = nodes.at(position);

    if (nodeClicked != null) {
      nodeClicked.repair();
    }
  }

  void onRepairAll() => nodes.repairAll();

  void onMainMenu() {
    running = false;
    menuInfo = MenuInfo.main();
    notify();
  }

  void onRepair(Node node) {
    node.repair();
    closeMenu();
  }

  void onDestroyNodeConfirmation(MenuInfo oldMenuInfo) {
    menuInfo = MenuInfo.destroy(
      node: oldMenuInfo.node!,
      realPosition: oldMenuInfo.realPosition!,
      gamePosition: oldMenuInfo.gamePosition!,
    );
    notify();
  }

  void onDestroyNode(Node node) {
    nodes.destroy(node);
    closeMenu();
  }

  void createNode({
    required NodeType type,
    required Offset position,
    ResourceType? resourceType,
  }) {
    closeMenu();

    nodes.create(
      type: type,
      position: position,
      resourceType: resourceType,
    );
  }

  void onContinue() {
    running = true;
    closeMenu();
  }

  void onLoadGame() {
    // TODO(momo): show toast
    onContinue();
  }

  void onSaveGame() {
    // TODO(momo): show toast
    onContinue();
  }

  void onSettings() {
    // TODO(momo): show toast
    onContinue();
  }

  void closeMenu() {
    menuInfo = null;
    notify();
  }

  void update(double dt) {
    if (running) {
      headquarters.resource1 += dt * 10;
      headquarters.resource2 += dt * 5;
      headquarters.resource3 += dt * 2;

      nodes.update(dt);

      Delayed.post(notify);
    }
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
    connections.render(renderer);
    nodes.render(renderer);
    _pointerHighlight.render(renderer);
  }
}
