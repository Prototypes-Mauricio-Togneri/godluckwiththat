import 'package:gatewayguardians/types/action_type.dart';

class Action {
  final ActionType actionType;
  final int villagers;
  final int turns;

  const Action({
    required this.actionType,
    required this.villagers,
    required this.turns,
  });
}
