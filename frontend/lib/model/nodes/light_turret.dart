import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class LightTurret extends Node {
  num damage = 0;
  num shield = 0;
  num range = 0;
  num fireRate = 0;

  LightTurret({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.light_turret,
          maxHp: Constants.LIGHT_TURRET_MAX_HP,
          energyConsumed: Constants.LIGHT_TURRET_ENERGY,
        );

  @override
  void render(Renderer renderer) {
    renderConnections(renderer);

    renderer.drawLightTurret(
      position: position,
      color: Palette.lightTurret,
    );

    drawHP(renderer);

    super.render(renderer);
  }

  static String cost() => 'TODO';
}
