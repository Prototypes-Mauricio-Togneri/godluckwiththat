import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_contextual_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class BuildMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'build_menu';

  const BuildMenu(this.game);

  factory BuildMenu.builder(BuildContext _, GameComponent game) =>
      BuildMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseContextualMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Label(
              text: 'BUILD',
              align: TextAlign.center,
            ),
            const VBox(5),
            MenuButton(
              text: 'Mine',
              icon: Icons.square_outlined,
              color: Palette.primary,
              onPressed: () => _onBuild(NodeType.mine),
            ),
            MenuButton(
              text: 'Light turret',
              icon: Icons.radio_button_checked,
              color: Palette.primary,
              onPressed: () => _onBuild(NodeType.turret),
            ),
            MenuButton(
              text: 'Close',
              icon: Icons.close,
              color: Palette.lightGrey,
              onPressed: _closeMenu,
            ),
          ],
        ),
      ),
    );
  }

  void _onBuild(NodeType type) {
    game.enableBuildMode(type);
    _closeMenu();
  }

  void _closeMenu() => game.closeMenu(name: BuildMenu.NAME);
}
