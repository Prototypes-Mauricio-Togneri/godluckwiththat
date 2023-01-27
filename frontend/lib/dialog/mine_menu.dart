import 'package:flutter/material.dart';
import 'package:tensionnode/components/mine.dart';
import 'package:tensionnode/dialog/base_contextual_menu.dart';
import 'package:tensionnode/game/game.dart';
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
    final Mine mine = game.state.selectedNode;

    return BaseContextualMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(text: '${mine.i}, ${mine.j}'),
            MenuButton(
              text: 'Close',
              icon: Icons.close,
              color: Palette.lightGrey,
              onPressed: _onClose,
            ),
          ],
        ),
      ),
    );
  }

  void _onClose() {
    _closeMenu();
  }

  void _closeMenu() {
    game.closeMenu(name: MineMenu.NAME);
  }
}
