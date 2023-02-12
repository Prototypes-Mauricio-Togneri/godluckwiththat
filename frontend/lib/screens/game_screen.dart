import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/dialog/game_over_menu.dart';
import 'package:tensionnode/dialog/info_menu.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/bottom_menu.dart';

class GameScreen extends StatelessWidget {
  final GameState state;
  final GameComponent game;

  const GameScreen(this.state, this.game);

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState state = GameState(jsonMatch);

    return GameScreen(state, GameComponent(state));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        game.openMainMenu();
        return false;
      },
      child: CustomStatusBar(
        style: SystemUiOverlayStyle.light,
        statusBarColor: Palette.grey,
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GameWidget(
                  game: game,
                  overlayBuilderMap: const {
                    MainMenu.NAME: MainMenu.builder,
                    SettingsMenu.NAME: SettingsMenu.builder,
                    InfoMenu.NAME: InfoMenu.builder,
                    GameOverMenu.NAME: GameOverMenu.builder,
                  },
                ),
                StateProvider<GameState>(
                  state: state,
                  builder: (context, state) => state.loaded
                      ? BottomMenu(game, state)
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Palette.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
