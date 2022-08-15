import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class PowerPlant extends Node {
  PowerPlant({
    required super.position,
  }) : super(type: NodeType.power_plant);

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
