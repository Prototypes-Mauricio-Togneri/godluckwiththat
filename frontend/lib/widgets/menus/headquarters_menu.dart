import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/game/headquarters.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/menus/resources_section.dart';

class HeadquartersMenu extends StatelessWidget {
  final GameComponent game;
  final Headquarters node;

  const HeadquartersMenu(this.game, this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: node.type.toString(),
          align: TextAlign.center,
        ),
        const VBox(10),
        Label(
          text: '${node.location.i}, ${node.location.j}',
          align: TextAlign.center,
        ),
        const VBox(10),
        ResourcesSection(
          title: 'Inventory',
          resources: node.inventory.list,
          horizontal: false,
        ),
        const Spacer(),
        MenuButton(
          text: 'Center',
          icon: Icons.filter_tilt_shift,
          color: Palette.primary,
          onPressed: _onCenter,
        ),
        MenuButton(
          text: 'Close',
          icon: Icons.close,
          color: Palette.lightGrey,
          onPressed: _closeMenu,
        ),
      ],
    );
  }

  void _onCenter() => game.centerMap(node.position);

  void _closeMenu() => game.unselectNode();
}
