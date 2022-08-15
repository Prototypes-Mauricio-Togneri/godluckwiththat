import 'package:flutter/widgets.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/types/node_type.dart';

class Node {
  final NodeType type;
  final Offset position;
  Node? top;
  Node? bottom;
  Node? left;
  Node? right;

  Node({
    required this.type,
    required this.position,
  });

  bool isAt(int x, int y) => position.dx == x && position.dy == y;

  void update(double dt) {}

  void render(Renderer renderer) {}
}
