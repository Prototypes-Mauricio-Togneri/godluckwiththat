import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/node_type.dart';

class HeavyTurret extends Node {
  num damage = 0;
  num shield = 0;
  num range = 0;
  num fireRate = 0;

  HeavyTurret({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.heavy_turret,
          maxHp: Constants.HEAVY_TURRET_MAX_HP,
          energyConsumed: Constants.HEAVY_TURRET_ENERGY,
        );

  static String cost() => 'TODO';
}
