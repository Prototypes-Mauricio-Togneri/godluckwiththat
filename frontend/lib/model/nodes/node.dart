import 'package:flutter/widgets.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/connection.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Node {
  final String id;
  final NodeType type;
  final Offset position;
  final int energyConsumed;
  num hp;
  num maxHp;
  Connection? top;
  Connection? bottom;
  Connection? left;
  Connection? right;

  Node({
    required this.type,
    required this.position,
    required this.hp,
    required this.maxHp,
    required this.energyConsumed,
  }) : id = '${position.dx},${position.dy}';

  bool get needsRepair => hp < maxHp;

  bool isAt(Offset testPosition) => position == testPosition;

  void fillConnections({
    required Connection? topNode,
    required Connection? bottomNode,
    required Connection? leftNode,
    required Connection? rightNode,
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
      connection: top,
    );

    _renderConnectionTo(
      renderer: renderer,
      connection: bottom,
    );

    _renderConnectionTo(
      renderer: renderer,
      connection: left,
    );

    _renderConnectionTo(
      renderer: renderer,
      connection: right,
    );
  }

  void _renderConnectionTo({
    required Renderer renderer,
    required Connection? connection,
  }) {
    if (connection != null) {
      renderer.connection(
        direction: connection.directionFrom(position),
        from: position,
        to: connection.position,
        lineColor: Palette.connectionLine,
        arrowColor: Palette.connectionArrow,
      );
    }
  }
}
