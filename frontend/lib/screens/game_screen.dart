import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/overlay/choose_resource_overlay.dart';
import 'package:tensionplanet/overlay/construct_overlay.dart';
import 'package:tensionplanet/overlay/info_overlay.dart';
import 'package:tensionplanet/overlay/main_overlay.dart';
import 'package:tensionplanet/overlay/settings_overlay.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/bottom_menu.dart';
import 'package:tensionplanet/widgets/side_menu.dart';

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
                    ConstructOverlay.NAME: ConstructOverlay.builder,
                    ChooseResourceOverlay.NAME: ChooseResourceOverlay.builder,
                    MainOverlay.NAME: MainOverlay.builder,
                    SettingsOverlay.NAME: SettingsOverlay.builder,
                    InfoOverlay.NAME: InfoOverlay.builder,
                  },
                ),
                StateProvider<GameState>(
                  state: state,
                  builder: (context, state) => SideMenu(game, state),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: StateProvider<GameState>(
                    state: state,
                    builder: (context, state) =>
                        game.isLoaded ? BottomMenu(game, state) : const Empty(),
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
