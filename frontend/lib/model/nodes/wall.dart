import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/node_type.dart';

class Wall extends Node {
  Wall({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.wall,
          maxHp: Constants.WALL_MAX_HP,
          energyConsumed: Constants.WALL_ENERGY,
        );

  static String cost() => 'TODO';
}
