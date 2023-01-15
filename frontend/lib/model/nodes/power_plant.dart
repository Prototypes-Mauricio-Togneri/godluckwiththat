import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/node_type.dart';

class PowerPlant extends Node {
  static const int RESOURCE1_COST = 200;

  PowerPlant({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.power_plant,
          maxHp: Constants.POWER_PLANT_MAX_HP,
          energyConsumed: 0,
        );

  static String cost() => 'Resource 1: $RESOURCE1_COST';
}
