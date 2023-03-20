import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/construction.dart';
import 'package:tensionplanet/dialog/confirmation_dialog.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/menus/item_row.dart';

class ConstructionMenu extends StatelessWidget {
  final GameComponent game;
  final Construction node;

  const ConstructionMenu(this.game, this.node);

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
        ResourcesSection(node),
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

    final Inventory resourcesBack =
        Inventory.fromResourceMap(node.nodeType.cost);
    resourcesBack.remove(node.inventory);

    node.destroy(
      sendDronesBack: true,
      resourcesBack: resourcesBack.half,
    );
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class ResourcesSection extends StatelessWidget {
  final Construction node;

  const ResourcesSection(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          color: Palette.lightGrey,
          child: const Label(
            text: 'Resources needed',
            align: TextAlign.center,
          ),
        ),
        const VBox(10),
        for (final MapEntry<ResourceType, int> entry
            in node.nodeType.cost.entries)
          ItemRow(
            title: entry.key.toString(),
            sprite: entry.key.sprite,
            amount:
                '${entry.value - node.inventory.get(entry.key)}/${entry.value}',
            border: (entry.value - node.inventory.get(entry.key) == entry.value)
                ? Palette.success
                : Palette.error,
          ),
      ],
    );
  }
}
