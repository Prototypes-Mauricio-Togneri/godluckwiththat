import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/game/game_state_actions.dart';
import 'package:godluckwiththat/game/game_state_costs.dart';

class GameState extends BaseGameState with GameStateActions, GameStateCosts {
  GameState(super.jsonMatch);
}
