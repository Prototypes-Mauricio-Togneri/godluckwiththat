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

  bool get isReady => turns == 0;
}
