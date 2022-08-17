import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Defense extends Node {
  Defense({
    required super.position,
    required super.hp,
  }) : super(type: NodeType.defense);

  @override
  void render(Renderer renderer) => drawNodeDiamond(
        renderer: renderer,
        color: Palette.defense,
      );
}
