import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/overlay/main_overlay.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/hud/overlay_menus.dart';

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
                GameWidget(
                  game: game,
                  overlayBuilderMap: const {
                    MainOverlay.NAME: MainOverlay.builder,
                  },
                ),
                StateProvider<GameState>(
                  state: state,
                  builder: (context, state) => OverlayMenus(
                    game: game,
                    state: state,
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
