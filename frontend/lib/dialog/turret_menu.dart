import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/turret.dart';
import 'package:tensionnode/dialog/base_contextual_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class TurretMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'turret_menu';

  const TurretMenu(this.game);

  factory TurretMenu.builder(BuildContext _, GameComponent game) =>
      TurretMenu(game);

  @override
  Widget build(BuildContext context) {
    final Turret turret = game.state.selectedNode();

    return BaseContextualMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: '${turret.type.name} turret',
              align: TextAlign.center,
            ),
            const VBox(10),
            Label(
              text: '${turret.i}, ${turret.j}',
              align: TextAlign.center,
            ),
            const VBox(10),
            MenuButton(
              text: 'Destroy',
              icon: Icons.delete,
              color: Palette.red,
              onPressed: _onDestroy,
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

  void _onDestroy() {
    game.removeNode(game.state.selectedNode());
    _closeMenu();
  }

  void _closeMenu() => game.closeMenu(name: TurretMenu.NAME);
}
