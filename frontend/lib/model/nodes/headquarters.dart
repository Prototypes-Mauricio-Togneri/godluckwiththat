import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/json/json_resources.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

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
  void addResource(ResourceType type) {
    switch (type) {
      case ResourceType.red:
        resource1++;
        break;
      case ResourceType.green:
        resource2++;
        break;
      case ResourceType.blue:
        resource3++;
        break;
    }
  }

  JsonResources get jsonResources => JsonResources(
        resource1: resource1.toInt(),
        resource2: resource2.toInt(),
        resource3: resource3.toInt(),
      );
}
