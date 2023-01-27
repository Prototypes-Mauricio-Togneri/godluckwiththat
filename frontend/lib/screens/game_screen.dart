import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/mine_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/game/game.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/services/palette.dart';

class GameScreen extends StatelessWidget {
  final GameComponent game;

  const GameScreen(this.game);

  factory GameScreen.instance() => GameScreen(GameComponent(GameState()));

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
              MineMenu.NAME: MineMenu.builder,
            },
          ),
        ),
      ),
    );
  }
}
