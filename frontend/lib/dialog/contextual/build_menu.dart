import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/contextual/base_contextual_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';
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
              text: 'Red Mine',
              icon: Icons.square_outlined,
              color: Palette.resource_red,
              onPressed: () => _onBuild(MineSpec.mine_red),
            ),
            MenuButton(
              text: 'Green Mine',
              icon: Icons.square_outlined,
              color: Palette.resource_green,
              onPressed: () => _onBuild(MineSpec.mine_green),
            ),
            MenuButton(
              text: 'Blue Mine',
              icon: Icons.square_outlined,
              color: Palette.resource_blue,
              onPressed: () => _onBuild(MineSpec.mine_blue),
            ),
            MenuButton(
              text: 'Light turret',
              icon: Icons.radio_button_unchecked,
              color: Palette.turret_light,
              onPressed: () => _onBuild(TurretSpec.turret_light),
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

  void _onBuild(NodeSpec spec) {
    game.enableBuildMode(spec);
    _closeMenu();
  }

  void _closeMenu() => game.closeMenu(name: BuildMenu.NAME);
}
