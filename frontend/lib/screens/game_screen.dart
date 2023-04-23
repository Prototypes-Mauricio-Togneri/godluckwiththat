import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/game/game_component2.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/hud_container.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/utils/palette.dart';

class GameScreen extends StatelessWidget {
  final GameState state;
  final GameComponent2 game;

  const GameScreen(this.state, this.game);

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState state = GameState(jsonMatch);
    GameState.instance = state;

    final GameComponent2 game = GameComponent2();
    GameComponent2.instance = game;

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
                      state.loaded ? HudContainer(state) : const Empty(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
