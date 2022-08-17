import 'package:flutter/widgets.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/types/node_type.dart';

class Node {
  final NodeType type;
  final Offset position;
  num hp;
  Node? top;
  Node? bottom;
  Node? left;
  Node? right;

  Node({
    required this.type,
    required this.position,
    required this.hp,
  });

  bool get needsRepair => hp < 100; // TODO(momo): fix

  bool isAt(Offset testPosition) => position == testPosition;

  void update(double dt) {}

  void render(Renderer renderer) {}

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
}
