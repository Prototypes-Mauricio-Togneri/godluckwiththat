import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

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
        InventorySummary(node),
        const VBox(10),
        MenuButton(
          text: 'Center',
          icon: Icons.filter_tilt_shift,
          color: Palette.primary,
          onPressed: () => _onCenter(node),
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

  void _onCenter(Node node) => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class InventorySummary extends StatelessWidget {
  final Headquarters node;

  const InventorySummary(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final Resource resource in node.inventory.list)
          ItemRow(
            sprite: resource.type.sprite,
            amount: resource.amount,
          ),
        ItemRow(
          sprite: Assets.IMAGES_CONSTRUCTION_DRONE,
          amount: node.constructionDrones,
        ),
        ItemRow(
          sprite: Assets.IMAGES_CONSTRUCTION_DRONE,
          amount: node.logisticDrones,
        ),
      ],
    );
  }
}

class ItemRow extends StatelessWidget {
  final String sprite;
  final int amount;

  const ItemRow({
    required this.sprite,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'images/$sprite',
            ),
          ),
          const HBox(10),
          Label(
            text: '$amount',
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
