import 'package:gatewayguardians/models/actions/action.dart';
import 'package:gatewayguardians/types/action_type.dart';

class ActionExplore extends Action {
  ActionExplore()
      : super(
          actionType: ActionType.explore,
          villagers: 1,
          turns: 1,
        );
}
