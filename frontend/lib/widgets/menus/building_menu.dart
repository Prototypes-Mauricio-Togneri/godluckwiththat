import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/utils/assets.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';
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
        DroneSection(node),
        const VBox(10),
        MenuButton(
          text: 'Add connection',
          icon: Icons.add,
          color: Palette.success,
          onPressed: _onAddConnection,
        ),
        MenuButton(
          text: 'Remove connection',
          icon: Icons.remove,
          color: Palette.error,
          onPressed: _onRemoveConnection,
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

  void _onAddConnection() => game.enableAddConnectionMode();

  void _onRemoveConnection() => game.enableRemoveConnectionMode();

  void _onTransferDrone() => game.enableTransferDroneMode();

  void _onCenter() => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
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
          sprite: node.resourceProduced.sprite,
          amount: '${node.output}',
        ),
      ],
    );
  }
}

class DroneSection extends StatelessWidget {
  final Building node;

  const DroneSection(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (node.availableBasicDrones > 0)
          ItemRow(
            sprite: Assets.IMAGES_DRONES_BASIC_DRONE,
            amount: '${node.availableBasicDrones}',
          ),
        if (node.availableIntermediateDrones > 0)
          ItemRow(
            sprite: Assets.IMAGES_DRONES_INTERMEDIATE_DRONE,
            amount: '${node.availableIntermediateDrones}',
          ),
        if (node.availableAdvanceDrones > 0)
          ItemRow(
            sprite: Assets.IMAGES_DRONES_ADVANCE_DRONE,
            amount: '${node.availableAdvanceDrones}',
          ),
      ],
    );
  }
}
