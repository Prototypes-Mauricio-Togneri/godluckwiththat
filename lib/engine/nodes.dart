import 'package:flutter/rendering.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/intersection.dart';
import 'package:tensionnode/model/nodes/mine.dart';
import 'package:tensionnode/model/nodes/node.dart';

class Nodes {
  final List<Node> _nodes = [];

  Headquarters get headquarters => at(Offset.zero)! as Headquarters;

  Headquarters addHQ(Offset position) => add(
        Headquarters(
          position: position,
        ),
      );

  Mine addMine(Offset position) => add(
        Mine(
          position: position,
        ),
      );

  Intersection addIntersection(Offset position) => add(
        Intersection(
          position: position,
        ),
      );

  T add<T extends Node>(T element) {
    _nodes.add(element);

    return element;
  }

  Node? at(Offset position) {
    for (final Node node in _nodes) {
      if (node.isAt(position)) {
        return node;
      }
    }

    return null;
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
