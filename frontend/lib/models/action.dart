import 'package:gatewayguardians/types/action_type.dart';

class Action {
  final ActionType actionType;
  final int villagers;
  int turns;

  Action({
    required this.actionType,
    required this.villagers,
    required this.turns,
  });

  bool get isExplore => actionType == ActionType.explore;

  bool get isClaim => actionType == ActionType.claim;

  bool get isTrain => actionType == ActionType.train;

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
}
