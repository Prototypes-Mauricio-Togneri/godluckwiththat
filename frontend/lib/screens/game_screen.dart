import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/services/palette.dart';

class GameScreen extends StatelessWidget {
  final MyGame game;

  const GameScreen(this.game);

  factory GameScreen.instance() => GameScreen(MyGame(GameState()));

  @override
  Widget build(BuildContext context) {
    return CustomStatusBar(
      style: SystemUiOverlayStyle.light,
      statusBarColor: Palette.grey,
      child: SafeArea(
        child: Scaffold(
          body: GameWidget(
            game: game,
            overlayBuilderMap: const {
              MainMenu.NAME: MainMenu.builder,
              SettingsMenu.NAME: SettingsMenu.builder,
            },
          ),
        ),
      ),
    );
  }
}
