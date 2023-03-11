import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/game/construction.dart';
import 'package:tensionplanet/dialog/confirmation_dialog.dart';
import 'package:tensionplanet/game/game_component.dart';
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
        ResourcesSection(node),
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

class ResourcesSection extends StatelessWidget {
  final Construction node;

  const ResourcesSection(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Label(
          text: 'Resources needed'.toUpperCase(),
          align: TextAlign.center,
        ),
        const VBox(10),
        for (final MapEntry<ResourceType, int> entry in node.type.cost.entries)
          ItemRow(
            title: entry.key.toString(),
            sprite: entry.key.sprite,
            amount:
                '${entry.value - node.remainingResources.get(entry.key)}/${entry.value}',
          ),
      ],
    );
  }
}
