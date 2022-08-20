import 'dart:ui';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/model/menu_info.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/types/menu_type.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class Menu extends StatelessWidget {
  final GameState state;

  const Menu(this.state);

  @override
  Widget build(BuildContext context) {
    switch (state.menuInfo!.type) {
      case MenuType.node:
        return NodeMenu(
          state: state,
          menuInfo: state.menuInfo!,
        );
      case MenuType.empty:
        return EmptyMenu(
          state: state,
          menuInfo: state.menuInfo!,
        );
      case MenuType.destroy:
        return DestroyMenu(
          state: state,
          menuInfo: state.menuInfo!,
        );
    }
  }
}

class NodeMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const NodeMenu({
    required this.state,
    required this.menuInfo,
  });

  @override
  Widget build(BuildContext context) {
    final Node node = menuInfo.node!;

    return ContextualMenu(
      position: menuInfo.realPosition!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: node.type.name.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          Label(
            text: '(${menuInfo.gamePosition!.dx}, ${menuInfo.gamePosition!.dy})',
            align: TextAlign.center,
            size: 12,
          ),
          const VBox(10),
          Label(
            text: 'HP: ${node.hp} / ${node.maxHp}',
            align: TextAlign.center,
            size: 12,
          ),
          if (node.energyConsumed > 0)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Label(
                text: 'Energy: ${node.energyConsumed}',
                align: TextAlign.center,
                size: 12,
              ),
            ),
          if (node.needsRepair)
            MenuButton(
              text: 'Repair',
              icon: Icons.build,
              color: Palette.green,
              onPressed: () => state.onRepair(node),
            ),
          if (!(node is Headquarters))
            MenuButton(
              text: 'Destroy',
              icon: Icons.delete,
              color: Palette.red,
              onPressed: () => state.onDestroyNodeConfirmation(menuInfo),
            ),
        ],
      ),
    );
  }
}

class EmptyMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const EmptyMenu({
    required this.state,
    required this.menuInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ContextualMenu(
      position: menuInfo.realPosition!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: '${menuInfo.gamePosition!.dx}, ${menuInfo.gamePosition!.dy}',
            align: TextAlign.center,
          ),
          if (menuInfo.hasPatch)
            MenuButton(
              text: 'Mine',
              icon: Icons.factory,
              color: Palette.blue,
              onPressed: () => state.createNode(
                type: NodeType.mine,
                position: menuInfo.gamePosition!,
                resourceType: menuInfo.patch!.type,
              ),
            ),
          if (!menuInfo.hasPatch)
            Column(
              children: [
                MenuButton(
                  text: 'Power plant',
                  icon: Icons.bolt,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.power_plant,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Wall',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.wall,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Light turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.light_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Heavy turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.heavy_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Long range turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.long_range_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Ion turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.ion_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Gauss turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.gauss_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Plasma turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.plasma_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
                MenuButton(
                  text: 'Pulse turret',
                  icon: Icons.cell_tower,
                  color: Palette.blue,
                  onPressed: () => state.createNode(
                    type: NodeType.pulse_turret,
                    position: menuInfo.gamePosition!,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class DestroyMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const DestroyMenu({
    required this.state,
    required this.menuInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ContextualMenu(
      position: menuInfo.realPosition!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Label(
            text: 'Destroy node?',
            align: TextAlign.center,
          ),
          MenuButton(
            text: 'Destroy',
            icon: Icons.delete,
            color: Palette.red,
            onPressed: () => state.onDestroyNode(menuInfo.node!),
          ),
          MenuButton(
            text: 'Cancel',
            icon: Icons.cancel,
            color: Palette.grey,
            onPressed: state.closeMenu,
          ),
        ],
      ),
    );
  }
}

class ContextualMenu extends StatelessWidget {
  final Offset position;
  final Widget child;

  const ContextualMenu({
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Palette.hudBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IntrinsicWidth(child: child),
      ),
    );
  }
}

class CenteredMenu extends StatelessWidget {
  final Widget child;

  const CenteredMenu({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Palette.hudBackground,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IntrinsicWidth(child: child),
          ),
        ),
      ),
    );
  }
}
