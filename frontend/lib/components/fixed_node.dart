import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/components/node.dart';

class FixedNode extends Node with Tappable {
  FixedNode({
    required super.i,
    required super.j,
    required super.path,
  });

  @override
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;
}
