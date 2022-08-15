import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Mine extends Node {
  Mine({
    required super.position,
  }) : super(type: NodeType.mine);

  @override
  void render(Renderer renderer) {
    renderer.diamondHollow(
      position: position,
      color: Palette.mine1,
      size: renderer.map.blockSize,
    );

    renderer.diamondFilled(
      position: position,
      color: Palette.mine1,
      size: renderer.map.blockSize / 2,
    );
  }
}
