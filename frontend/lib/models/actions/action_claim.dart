import 'package:gatewayguardians/models/actions/action.dart';
import 'package:gatewayguardians/types/action_type.dart';

class ActionClaim extends Action {
  ActionClaim()
      : super(
          actionType: ActionType.claim,
          villagers: 0,
          turns: 1,
        );
}
