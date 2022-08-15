import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/model/headquarters.dart';
import 'package:tensionnode/model/lane.dart';
import 'package:tensionnode/model/mine.dart';
import 'package:tensionnode/model/node.dart';
import 'package:tensionnode/model/pointer_highlight.dart';
import 'package:tensionnode/model/renderer.dart';

class GameState extends BaseState {
  final TransformationController transformationController = TransformationController();
  final int blockSize = 10;
  final Size mapDimensions = const Size(100, 100);

  late final Renderer renderer;
  final PointerHighlight pointerHighlight = PointerHighlight();
  late final Headquarters headquarters;
  late final Mine mine1;
  final List<Node> nodes = [];
  final List<Lane> lanes = [];

  num resource1 = 300;
  num resource2 = 200;
  num resource3 = 100;

  GameState() {
    renderer = Renderer(
      mapSize: mapSize,
      blockSize: blockSize,
    );

    headquarters = Headquarters(
      position: const Offset(0, 0),
    );

    mine1 = Mine(
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

    const double zoom = 5;
    final Size size = WidgetsBinding.instance.window.physicalSize;
    final double xTranslate = ((mapDimensions.width / 2) * blockSize * zoom) - (size.width / 2);
    final double yTranslate = ((mapDimensions.height / 2) * blockSize * zoom) - (size.height / 2);

    transformationController.value.setEntry(0, 0, zoom);
    transformationController.value.setEntry(1, 1, zoom);
    transformationController.value.setEntry(2, 2, zoom);
    transformationController.value.setEntry(0, 3, -xTranslate);
    transformationController.value.setEntry(1, 3, -yTranslate);
  }

  Size get mapSize => Size(
        (blockSize * mapDimensions.width).toDouble(),
        (blockSize * mapDimensions.height).toDouble(),
      );

  void onPointerHover(PointerHoverEvent event) {
    pointerHighlight.setPosition(
      event.localPosition.nodePosition(
        dimensions: mapDimensions,
        blockSize: blockSize,
      ),
    );
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset localPosition = details.localPosition.nodePosition(
      dimensions: mapDimensions,
      blockSize: blockSize,
    );
    print('TAP: (${localPosition.dx}, ${localPosition.dy})');
    //path.contains(Offset(x, y));
  }

  void update(double dt) {
    resource1 += dt * 10;
    resource2 += dt * 5;
    resource3 += dt * 2;

    headquarters.update(dt);

    Delayed.post(notify);
  }
}
