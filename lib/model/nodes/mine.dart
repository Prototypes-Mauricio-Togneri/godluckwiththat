import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Node {
  final ResourceType resourceType;
  num accumulatedTime = 0;
  int output = 0;

  static const int PRODUCTION_TIME = 5; // in seconds

  Mine({
    required this.resourceType,
    required super.position,
    required super.hp,
  }) : super(type: NodeType.mine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= PRODUCTION_TIME) {
      accumulatedTime = 0;
      output = 1;
    }
  }

  @override
  void render(Renderer renderer) => drawNodeDiamond(
        renderer: renderer,
        color: Palette.mine,
      );
}
