import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/hud/overlay_menus.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/utils/palette.dart';

class GameScreen extends StatelessWidget {
  final GameState state;
  final GameComponent game;

  const GameScreen(this.state, this.game);

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState state = GameState(jsonMatch);
    GameState.instance = state;

    final GameComponent game = GameComponent();
    GameComponent.instance = game;

    return GameScreen(state, game);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // TODO(momo): open main menu
        return false;
      },
      child: CustomStatusBar(
        style: SystemUiOverlayStyle.light,
        statusBarColor: Palette.grey,
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GameWidget(game: game),
                StateProvider<GameState>(
                  state: state,
                  builder: (context, state) =>
                      state.loaded ? OverlayMenus(state) : const Empty(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
