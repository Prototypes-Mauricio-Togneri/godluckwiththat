import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/transformers/bakery.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class BakeryMenu extends StatelessWidget {
  final GameComponent game;
  final Bakery bakery;

  const BakeryMenu(this.game, this.bakery);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: bakery.type.name.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          Label(
            text: '${bakery.location.i}, ${bakery.location.j}',
            align: TextAlign.center,
          ),
          const VBox(10),
          MenuButton(
            text: 'Center',
            icon: Icons.filter_tilt_shift,
            color: Palette.primary,
            onPressed: () => _onCenter(bakery),
          ),
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
    );
  }

  void _onCenter(Node node) => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}
