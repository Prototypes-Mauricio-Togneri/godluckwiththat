import 'package:tensionnode/model/node.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Mine extends Node {
  Mine({
    required super.position,
    required super.blockSize,
  }) : super(type: NodeType.mine);

  @override
  void render(Renderer renderer) {
    renderer.diamondHollow(
      position: position,
      color: Palette.mine1,
      size: blockSize,
    );

    renderer.diamondFilled(
      position: position,
      color: Palette.mine1,
      size: blockSize / 2,
    );
  }
}
