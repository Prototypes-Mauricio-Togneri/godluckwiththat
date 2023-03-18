import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/warehouse.dart';
import 'package:tensionplanet/dialog/confirmation_dialog.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/menus/resources_section.dart';
import 'package:tensionplanet/widgets/menus/warning_message.dart';

class WarehouseMenu extends StatelessWidget {
  final GameComponent game;
  final Warehouse node;

  const WarehouseMenu(this.game, this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(10),
        Label(
          text: node.nodeType.toString(),
          align: TextAlign.center,
        ),
        ResourcesSection(
          title: 'Inventory',
          resources: node.inventory.list,
          horizontal: false,
        ),
        if (!node.hasConnections)
          const WarningMessage('Building not connected'),
        const Spacer(),
        if (node.enabled)
          MenuButton(
            text: 'Stop',
            icon: Icons.stop,
            color: Palette.error,
            onPressed: () => _onToggleEnabled(false),
          )
        else
          MenuButton(
            text: 'Resume',
            icon: Icons.play_arrow,
            color: Palette.success,
            onPressed: () => _onToggleEnabled(true),
          ),
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

  void _onToggleEnabled(bool value) {
    node.enabled = value;
    node.updateMenu();
  }

  void _onCenter() => game.centerMap(node.position);

  void _onDestroy(BuildContext context) {
    ConfirmationDialog.destroyBuilding(
      context: context,
      onAccept: _destroy,
    );
  }

  void _destroy() {
    final Node node = game.selectedNode();
    node.destroy(
      sendDronesBack: true,
      resourcesBack: node.nodeType.cost,
    );
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}
