import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/dialog/confirmation_dialog.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/menus/resources_section.dart';
import 'package:tensionplanet/widgets/resource_icon.dart';

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
          title: 'Drones',
          resources: [
            Resource(ResourceType.drone, node.inventory.get(ResourceType.drone))
          ],
        ),
        const Spacer(),
        RecipeSection(node),
        const VBox(20),
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

class RecipeSection extends StatelessWidget {
  final Building building;

  const RecipeSection(this.building);

  @override
  Widget build(BuildContext context) {
    final List<ResourceType> inputs = building.input.keys.toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < inputs.length; i++)
          Row(
            children: [
              if (i != 0)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Label(
                    text: '+',
                    size: 20,
                  ),
                ),
              ResourceIcon(
                title: inputs[i].toString(),
                sprite: inputs[i].sprite,
                amount: '${building.input[inputs[i]]!}',
                size: 25,
              ),
            ],
          ),
        if (inputs.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Label(
              text: '=',
              size: 20,
            ),
          ),
        for (final ResourceType type in building.output.keys)
          ResourceIcon(
            title: type.toString(),
            sprite: type.sprite,
            amount: '${building.output[type]!}',
            size: 25,
          ),
      ],
    );
  }
}
