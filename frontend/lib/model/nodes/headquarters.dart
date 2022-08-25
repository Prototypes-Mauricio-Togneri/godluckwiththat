import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  num resource1 = 0;
  num resource2 = 0;
  num resource3 = 0;

  Headquarters({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.headquarters,
          maxHp: Constants.HEADQUARTERS_MAX_HP,
          energyConsumed: 0,
        );

  @override
  void render(Renderer renderer) {
    renderConnections(renderer);

    renderer.drawHeadquarters(
      position: position,
      color: Palette.hq,
    );

    drawHP(renderer);
  }
}
