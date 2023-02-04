import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/position.dart';

class FixedNode extends Node with Tappable {
  final num i;
  final num j;
  final num heat;

  FixedNode({
    required this.i,
    required this.j,
    required this.heat,
    required super.type,
    required super.armor,
    required super.shield,
  }) : super(position: Position.fromGrid(i, j));

  @override
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;
}
