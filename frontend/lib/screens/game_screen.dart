import 'package:dafluta/dafluta.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/dialog/build_menu.dart';
import 'package:tensionnode/dialog/info_menu.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/mine_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/dialog/turret_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';

class GameScreen extends StatelessWidget {
  final GameState state;
  final GameComponent game;

  const GameScreen(this.state, this.game);

  factory GameScreen.instance() {
    final GameState state = GameState();

    return GameScreen(state, GameComponent(state));
  }

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
                  TurretMenu.NAME: TurretMenu.builder,
                  BuildMenu.NAME: BuildMenu.builder,
                },
              ),
              BottomMenu(game),
              StateProvider<GameState>(
                state: state,
                builder: (context, state) =>
                    state.showCancel ? CancelButton(game) : const Empty(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final GameComponent game;

  const CancelButton(this.game);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 90),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.red,
            minimumSize: const Size(0, 45),
          ),
          onPressed: _onClose,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.close,
                size: 20,
              ),
              const HBox(10),
              Label(text: 'Cancel'.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }

  void _onClose() => game.disableBuildMode();
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
