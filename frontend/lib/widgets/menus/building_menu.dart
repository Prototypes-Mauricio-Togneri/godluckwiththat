import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/dialog/confirmation_dialog.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';
import 'package:tensionnode/widgets/menus/resources_section.dart';

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
        ResourcesSection(
          title: 'Input',
          resources: node.inputInventory,
        ),
        ResourcesSection(
          title: 'Output',
          resources: node.outputInventory,
        ),
        ResourcesSection(
          title: 'Inventory',
          resources: node.restInventory,
        ),
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
