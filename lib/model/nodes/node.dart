import 'package:flutter/widgets.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/node_type.dart';

class Node {
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
  });

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

  void update(double dt) {}

  void render(Renderer renderer) {}

  void repair() {
    hp = maxHp;
  }

  void drawNodeDiamond({
    required Renderer renderer,
    required Color color,
    required num size,
  }) {
    renderer.diamondHollow(
      position: position,
      color: color,
      size: size,
    );

    renderer.diamondFilled(
      position: position,
      color: color,
      size: size / 2,
    );
  }

  void drawNodeSquare({
    required Renderer renderer,
    required Color color,
    required num size,
  }) {
    renderer.squareHollow(
      position: position,
      color: color,
      size: size,
    );

    renderer.squareFilled(
      position: position,
      color: color,
      size: size / 2,
    );
  }

  void drawNodeCircle({
    required Renderer renderer,
    required Color color,
    required num size,
  }) {
    renderer.circleHollow(
      position: position,
      color: color,
      size: size,
    );

    renderer.circleFilled(
      position: position,
      color: color,
      size: size / 2,
    );
  }

  void drawHP(Renderer renderer) {
    if (renderer.showHP) {
      renderer.hp(
        position: position,
        value: hp,
        max: maxHp,
      );
    }
  }
}
