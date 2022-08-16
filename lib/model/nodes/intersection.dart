import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Intersection extends Node {
  Intersection({
    required super.position,
    required super.hp,
  }) : super(type: NodeType.intersection);

  @override
  void render(Renderer renderer) {
    renderer.diamondFilled(
      position: position,
      color: Palette.intersection,
      size: renderer.map.blockSize / 5,
    );
  }
}
