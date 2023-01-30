import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/dialog/contextual/base_contextual_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class MineMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'mine_menu';

  const MineMenu(this.game);

  factory MineMenu.builder(BuildContext _, GameComponent game) =>
      MineMenu(game);

  @override
  Widget build(BuildContext context) {
    final Mine mine = game.state.selectedNode();

    return BaseContextualMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: '${mine.spec.resource.name} mine',
              align: TextAlign.center,
            ),
            const VBox(10),
            Label(
              text: '${mine.i}, ${mine.j}',
              align: TextAlign.center,
            ),
            const VBox(10),
            MenuButton(
              text: 'Destroy',
              icon: Icons.delete,
              color: Palette.error,
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
    final Node node = game.state.selectedNode();
    node.kill();
    _closeMenu();
  }

  void _closeMenu() => game.closeMenu(name: MineMenu.NAME);
}
