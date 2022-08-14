import 'package:dafluta/dafluta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/model/headquarters.dart';
import 'package:tensionnode/model/mine.dart';
import 'package:tensionnode/model/node.dart';
import 'package:tensionnode/model/resource.dart';

class GameState extends BaseState {
  final _transformationController = TransformationController();
  final int _blockSize = 10;
  final int _numberOfNodesHorizontal = 100;
  final int _numberOfNodesVertical = 100;

  late final Headquarters headquarters;
  late final Mine mine1;
  final List<Node> nodes = [];
  Offset? _highlightedNode;

  final Resource resource1 = Resource(name: 'Copper', value: 300);
  final Resource resource2 = Resource(name: 'Iron', value: 200);
  final Resource resource3 = Resource(name: 'Titanium', value: 100);

  GameState() {
    headquarters = Headquarters(
      position: const Offset(50, 40),
      blockSize: _blockSize,
    );

    mine1 = Mine(
      position: const Offset(40, 35),
      blockSize: _blockSize,
    );

    nodes.add(headquarters);
    nodes.add(mine1);

    const double zoom = 5;
    final Size size = WidgetsBinding.instance.window.physicalSize;
    final double xTranslate = (headquarters.position.dx * _blockSize * zoom) - (size.width / 2);
    final double yTranslate = (headquarters.position.dy * _blockSize * zoom) - (size.height / 2);

    _transformationController.value.setEntry(0, 0, zoom);
    _transformationController.value.setEntry(1, 1, zoom);
    _transformationController.value.setEntry(2, 2, zoom);
    _transformationController.value.setEntry(0, 3, -xTranslate);
    _transformationController.value.setEntry(1, 3, -yTranslate);
  }

  Size get mapSize => Size(
        (_blockSize * _numberOfNodesHorizontal).toDouble(),
        (_blockSize * _numberOfNodesVertical).toDouble(),
      );

  int get blockSize => _blockSize;

  int get numberOfNodesHorizontal => _numberOfNodesHorizontal;

  int get numberOfNodesVertical => _numberOfNodesVertical;

  bool get hasHighlightedNode => _highlightedNode != null;

  Offset get highlightedNode => _highlightedNode ?? Offset.zero;

  TransformationController get transformationController => _transformationController;

  void onPointerHover(PointerHoverEvent event) {
    _highlightedNode = event.localPosition.nodePosition(blockSize);
    notify();
  }

  void onTapUp(TapUpDetails details) {
    final Offset localPosition = details.localPosition.nodePosition(blockSize);
    print('TAP: (${localPosition.dx}, ${localPosition.dy})');
    //path.contains(Offset(x, y));
  }

  void update(double dt) {
    resource1.value += dt * 10;
    resource2.value += dt * 5;
    resource3.value += dt * 2;

    headquarters.update(dt);

    Delayed.post(notify);
  }
}
