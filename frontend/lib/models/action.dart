import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Action {
  final ActionType actionType;
  final int villagers;
  final BuildingType? buildingType;
  final ResourceMap? cost;
  int turns;

  Action({
    required this.actionType,
    required this.villagers,
    required this.turns,
    this.buildingType,
    this.cost,
  });

  bool passTurn() {
    turns--;

    return turns == 0;
  }

  factory Action.explore() => Action(
        actionType: ActionType.explore,
        villagers: 1,
        turns: 1,
      );

  factory Action.claim() => Action(
        actionType: ActionType.claim,
        villagers: 1,
        turns: 1,
      );

  factory Action.train(int amount) => Action(
        actionType: ActionType.train,
        villagers: amount,
        turns: 1,
      );

  factory Action.build({
    required BuildingType buildingType,
    required ResourceMap cost,
  }) =>
      Action(
        actionType: ActionType.build,
        villagers: 1,
        turns: 1,
        buildingType: buildingType,
        cost: cost,
      );

  factory Action.destroy() => Action(
        actionType: ActionType.destroy,
        villagers: 1,
        turns: 1,
      );

  factory Action.levelUp(ResourceMap cost) => Action(
        actionType: ActionType.levelUp,
        villagers: 0,
        turns: 1,
        cost: cost,
      );
}
