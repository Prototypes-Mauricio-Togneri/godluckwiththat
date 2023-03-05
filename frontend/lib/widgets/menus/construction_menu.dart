import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';
import 'package:tensionnode/widgets/menus/item_row.dart';

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

  void _onCenter() => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
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
        for (final MapEntry<ResourceType, int> entry in node.type.cost.entries)
          ItemRow(
            sprite: entry.key.sprite,
            amount:
                '${entry.value - node.remainingResources.get(entry.key)}/${entry.value}',
          ),
      ],
    );
  }
}
