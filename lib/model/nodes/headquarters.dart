import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  Headquarters({
    required super.position,
  }) : super(type: NodeType.headquarters);

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
