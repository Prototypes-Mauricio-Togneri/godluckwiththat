import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class GameOverMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'game_over_menu';

  const GameOverMenu(this.game);

  factory GameOverMenu.builder(BuildContext _, GameComponent game) =>
      GameOverMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: 'Game over'.toUpperCase(),
              align: TextAlign.center,
            ),
            const VBox(5),
            MenuButton(
              text: 'Ok'.toUpperCase(),
              icon: Icons.cancel,
              color: Palette.primary,
              onPressed: _closeMenu,
            ),
          ],
        ),
      ),
    );
  }

  void _closeMenu() => Navigation.pop();
}
