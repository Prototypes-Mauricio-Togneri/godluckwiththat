import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/dialog/confirmation_dialog.dart';
import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/menus/resources_section.dart';
import 'package:tensionplanet/widgets/menus/warning_message.dart';
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
        const VBox(10),
        Label(
          text: node.nodeType.toString(),
          align: TextAlign.center,
        ),
        ResourcesSection(
          title: 'Input',
          resources: node.inputInventory,
          horizontal: true,
        ),
        ResourcesSection(
          title: 'Output',
          resources: node.outputInventory,
          horizontal: true,
        ),
        if (node.state.isWorking) ProducingIndicator(node),
        if (!node.hasConnections) WarningMessage.notConnected(),
        if (node.state.isIdle) WarningMessage.idle(),
        if (node.outputFilled) WarningMessage.outputFilled(),
        if (!node.enabled) WarningMessage.stopped(),
        const Spacer(),
        RecipeSection(node.nodeType),
        const VBox(20),
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
          text: 'Copy',
          icon: Icons.copy,
          color: Palette.primary,
          onPressed: _onCopy,
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

  void _onCopy() => game.enableBuildingMode(nodeType: node.nodeType);

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
      resourcesBack: node.nodeType.cost.asInventory.half,
    );
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class RecipeSection extends StatelessWidget {
  final NodeType nodeType;

  const RecipeSection(this.nodeType);

  @override
  Widget build(BuildContext context) {
    final List<Resource> inputs = nodeType.input.resources();

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
                title: inputs[i].resourceType.toString(),
                sprite: inputs[i].resourceType.sprite,
                amount: '${inputs[i].amount}',
                size: 40,
              ),
            ],
          ),
        if (inputs.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Label(
              text: '+',
              size: 20,
            ),
          ),
        ResourceIcon(
          title: 'Seconds',
          sprite: Assets.IMAGES_RESOURCES_TIME,
          amount: '${nodeType.productionTime}',
          size: 40,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Label(
            text: '=',
            size: 20,
          ),
        ),
        for (final Resource resource in nodeType.output.resources())
          ResourceIcon(
            title: resource.resourceType.toString(),
            sprite: resource.resourceType.sprite,
            amount: '${resource.amount}',
            size: 40,
          ),
      ],
    );
  }
}

class ProducingIndicator extends StatelessWidget {
  final Building building;

  const ProducingIndicator(this.building);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Container(
            width: 280,
            height: 20,
            color: Palette.white,
          ),
          Container(
            width: 280 * building.producingProcess,
            height: 20,
            color: Palette.lightGrey,
          ),
        ],
      ),
    );
  }
}
