import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Wall extends Node {
  Wall({
    required super.position,
  }) : super(type: NodeType.wall);

  @override
  void render(Renderer renderer) {
    renderer.diamondHollow(
      position: position,
      color: Palette.hq,
      size: renderer.map.blockSize,
    );

    renderer.diamondFilled(
      position: position,
      color: Palette.hq,
      size: renderer.map.blockSize / 2,
    );
  }
}
