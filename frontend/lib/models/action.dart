import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Action {
  final ActionType actionType;
  final int villagers;
  final BuildingType? buildingType;
  int turns;

  Action({
    required this.actionType,
    required this.villagers,
    required this.turns,
    this.buildingType,
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

  factory Action.build(BuildingType buildingType) => Action(
        actionType: ActionType.build,
        villagers: 1,
        turns: 1,
        buildingType: buildingType,
      );
}
