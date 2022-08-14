import 'package:tensionnode/model/node.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  Headquarters({
    required super.position,
    required super.blockSize,
  }) : super(type: NodeType.headquarters);

  @override
  void render(Renderer renderer) {
    renderer.diamondHollow(
      position: position,
      color: Palette.hq,
      size: blockSize,
    );
  }
}
