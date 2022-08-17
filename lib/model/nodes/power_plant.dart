import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class PowerPlant extends Node {
  PowerPlant({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.power_plant,
          maxHp: Constants.POWER_PLANT_MAX_HP,
        );

  @override
  void render(Renderer renderer) {
    drawNodeDiamond(
      renderer: renderer,
      color: Palette.powerPlant,
      size: renderer.map.blockSize / 2,
    );

    drawHP(renderer);
  }
}
