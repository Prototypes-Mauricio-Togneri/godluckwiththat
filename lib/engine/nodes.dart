import 'package:flutter/rendering.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/intersection.dart';
import 'package:tensionnode/model/nodes/mine.dart';
import 'package:tensionnode/model/nodes/node.dart';

class Nodes {
  final List<Node> _nodes = [];

  Headquarters addHQ(int x, int y) => _add(
        Headquarters(
          position: Offset(x.toDouble(), y.toDouble()),
        ),
      );

  Mine addMine(int x, int y) => _add(
        Mine(
          position: Offset(x.toDouble(), y.toDouble()),
        ),
      );

  Intersection addIntersection(int x, int y) => _add(
        Intersection(
          position: Offset(x.toDouble(), y.toDouble()),
        ),
      );

  T _add<T extends Node>(T element) {
    _nodes.add(element);

    return element;
  }

  void update(double dt) {
    for (final Node node in _nodes) {
      node.update(dt);
    }
  }

  void render(Renderer renderer) {
    for (final Node node in _nodes) {
      node.render(renderer);
    }
  }
}
