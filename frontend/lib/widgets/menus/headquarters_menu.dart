import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';
import 'package:tensionnode/widgets/menus/drone_section.dart';
import 'package:tensionnode/widgets/menus/item_row.dart';

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
          text: node.type.toString().toUpperCase(),
          align: TextAlign.center,
        ),
        const VBox(10),
        Label(
          text: '${node.location.i}, ${node.location.j}',
          align: TextAlign.center,
        ),
        const VBox(10),
        InventorySummary(game, node),
        const VBox(30),
        if (node.availableDrones > 1)
          MenuButton(
            text: 'Send drone',
            icon: Icons.send,
            color: Palette.primary,
            onPressed: _onTransferDrone,
          ),
        const Spacer(),
        MenuButton(
          text: 'Center',
          icon: Icons.filter_tilt_shift,
          color: Palette.primary,
          onPressed: _onCenter,
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
    );
  }

  void _onTransferDrone() => game.enableTransferDroneMode();

  void _onCenter() => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy(true);
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class InventorySummary extends StatelessWidget {
  final GameComponent game;
  final Headquarters node;

  const InventorySummary(this.game, this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final Resource resource in node.inventory.list)
          ItemRow(
            sprite: resource.type.sprite,
            amount: '${resource.amount}',
          ),
        DroneSection(game, node),
      ],
    );
  }
}
