import 'package:flutter/widgets.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/node_type.dart';

class Node {
  final String id;
  final NodeType type;
  final Offset position;
  final int energyConsumed;
  num hp;
  num maxHp;
  Node? top;
  Node? bottom;
  Node? left;
  Node? right;

  Node({
    required this.type,
    required this.position,
    required this.hp,
    required this.maxHp,
    required this.energyConsumed,
  }) : id = '${position.dx},${position.dy}';

  Direction directionTo(Node node) {
    final num x = position.dx - node.position.dx;
    final num y = position.dy - node.position.dy;

    if ((x == 0) && (y > 0)) {
      return Direction.up;
    } else if ((x == 0) && (y < 0)) {
      return Direction.down;
    } else if ((x > 0) && (y == 0)) {
      return Direction.left;
    } else if ((x < 0) && (y == 0)) {
      return Direction.right;
    } else {
      throw Error();
    }
  }

  bool get needsRepair => hp < maxHp;

  bool isAt(Offset testPosition) => position == testPosition;

  void fillConnections({
    required Node? topNode,
    required Node? bottomNode,
    required Node? leftNode,
    required Node? rightNode,
  }) {
    top = topNode;
    bottom = bottomNode;
    left = leftNode;
    right = rightNode;
  }

  void update(double dt) {}

  void render(Renderer renderer) {}

  void repair() {
    hp = maxHp;
  }

  void drawHP(Renderer renderer) {
    renderer.hp(
      position: position,
      value: hp,
      max: maxHp,
    );
  }

  void renderConnections(Renderer renderer) {
    _renderConnectionTo(
      renderer: renderer,
      to: top,
    );

    _renderConnectionTo(
      renderer: renderer,
      to: bottom,
    );

    _renderConnectionTo(
      renderer: renderer,
      to: left,
    );

    _renderConnectionTo(
      renderer: renderer,
      to: right,
    );
  }

  void _renderConnectionTo({
    required Renderer renderer,
    required Node? to,
  }) {
    if (to != null) {
      renderer.connection(
        direction: directionTo(to),
        from: position,
        to: to.position,
        lineColor: Palette.connectionLine,
        arrowColor: Palette.connectionArrow,
      );
    }
  }
}
