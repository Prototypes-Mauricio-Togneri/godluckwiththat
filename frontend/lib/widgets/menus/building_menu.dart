import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/dialog/confirmation_dialog.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';
import 'package:tensionnode/widgets/menus/drone_section.dart';
import 'package:tensionnode/widgets/menus/item_row.dart';

class BuildingMenu extends StatelessWidget {
  final GameComponent game;
  final Building node;

  const BuildingMenu(this.game, this.node);

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
        if (node.input.list.isNotEmpty) InputSection(node.input),
        OutputSection(node),
        const VBox(10),
        DroneSection(game, node),
        const VBox(10),
        MenuButton(
          text: 'Set connection',
          icon: Icons.turn_sharp_right_rounded,
          color: Palette.success,
          onPressed: _onSetConnection,
        ),
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
          onPressed: () => _onDestroy(context),
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

  void _onSetConnection() => game.enableSetConnectionMode();

  void _onTransferDrone() => game.enableTransferDroneMode();

  void _onCenter() => game.centerMap(node.position);

  void _onDestroy(BuildContext context) {
    ConfirmationDialog.destroyBuilding(
      context: context,
      onAccept: _destroy,
    );
  }

  void _destroy() {
    final Node node = game.selectedNode();
    node.destroy(true);
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class InputSection extends StatelessWidget {
  final Inventory inventory;

  const InputSection(this.inventory);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Label(
          text: 'Input'.toUpperCase(),
          align: TextAlign.center,
        ),
        const VBox(10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final Resource resource in inventory.list)
              ItemRow(
                title: resource.type.toString(),
                sprite: resource.type.sprite,
                amount: '${resource.amount}',
              ),
          ],
        ),
      ],
    );
  }
}

class OutputSection extends StatelessWidget {
  final Building node;

  const OutputSection(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Label(
          text: 'Output'.toUpperCase(),
          align: TextAlign.center,
        ),
        const VBox(10),
        ItemRow(
          title: node.resourceProduced.toString(),
          sprite: node.resourceProduced.sprite,
          amount: '${node.output}',
        ),
      ],
    );
  }
}
