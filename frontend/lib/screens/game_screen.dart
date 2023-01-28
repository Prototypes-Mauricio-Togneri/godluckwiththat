import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/dialog/build_menu.dart';
import 'package:tensionnode/dialog/info_menu.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/mine_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/game/game_component.dart';
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
          body: Stack(
            children: [
              GameWidget(
                game: game,
                overlayBuilderMap: const {
                  MainMenu.NAME: MainMenu.builder,
                  SettingsMenu.NAME: SettingsMenu.builder,
                  InfoMenu.NAME: InfoMenu.builder,
                  MineMenu.NAME: MineMenu.builder,
                  BuildMenu.NAME: BuildMenu.builder,
                },
              ),
              BottomMenu(game),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomMenu extends StatelessWidget {
  final GameComponent game;

  const BottomMenu(this.game);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Palette.grey,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomMenuButton(
              icon: Icons.menu,
              color: Palette.lightGrey,
              onClick: game.openMainMenu,
            ),
            const HBox(10),
            BottomMenuButton(
              icon: Icons.construction,
              color: Palette.lightGrey,
              onClick: game.openBuildMenu,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomMenuButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onClick;

  const BottomMenuButton({
    required this.icon,
    required this.color,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onClick,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
            ),
          ),
        ),
      ),
    );
  }
}
