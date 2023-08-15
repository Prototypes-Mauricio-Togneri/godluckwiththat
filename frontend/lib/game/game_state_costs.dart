import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';

mixin GameStateCosts on BaseGameState {
  ResourceMap get villagerCost => {
        ResourceType.food: 50,
      };
}
