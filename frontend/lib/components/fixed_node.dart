import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/models/position.dart';

class FixedNode extends Node with Tappable {
  final int i;
  final int j;

  FixedNode({
    required this.i,
    required this.j,
    required super.path,
  }) : super(position: Position.fromGrid(i, j));

  @override
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;
}
