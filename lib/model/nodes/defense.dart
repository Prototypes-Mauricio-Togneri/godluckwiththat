import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Defense extends Node {
  Defense({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.defense,
          maxHp: Constants.DEFENSE_MAX_HP,
          energyConsumed: Constants.DEFENSE_ENERGY,
        );

  @override
  void render(Renderer renderer) {
    drawNodeDiamond(
      renderer: renderer,
      color: Palette.defense,
      size: renderer.map.blockSize / 2,
    );

    drawHP(renderer);
  }
}
