import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Node {
  final ResourceType resourceType;
  num accumulatedTime = 0;

  static const double PRODUCTION_TIME = 5; // in seconds

  static const int RESOURCE1_COST = 100;
  static const int ENERGY_COST = 10;

  Mine({
    required this.resourceType,
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.mine,
          maxHp: Constants.MINE_MAX_HP,
          energyConsumed: Constants.MINE_ENERGY,
        );

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= PRODUCTION_TIME) {
      accumulatedTime = 0;
      accumulatedResources.add(resourceType);
    }

    super.update(dt);
  }

  @override
  void render(Renderer renderer) {
    renderConnections(renderer);

    renderer.drawMine(
      position: position,
      color: resourceType.color,
    );

    drawHP(renderer);

    super.render(renderer);
  }

  static String cost() => 'Resource 1: $RESOURCE1_COST\nEnergy: $ENERGY_COST';

  @override
  ResourceType? getResourceType() => resourceType;
}
