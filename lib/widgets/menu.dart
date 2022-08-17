import 'dart:ui';

import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/model/menu_info.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/types/menu_type.dart';
import 'package:tensionnode/types/node_type.dart';

class Menu extends StatelessWidget {
  final GameState state;

  const Menu(this.state);

  @override
  Widget build(BuildContext context) {
    if (state.hasMenu) {
      switch (state.menuInfo!.type) {
        case MenuType.main:
          return MainMenu(state: state);
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
        case MenuType.build:
          return BuildMenu(
            state: state,
            menuInfo: state.menuInfo!,
          );
        case MenuType.destroy:
          return const Empty();
      }
    } else {
      return const Empty();
    }
  }
}

class MainMenu extends StatelessWidget {
  final GameState state;

  const MainMenu({required this.state});

  @override
  Widget build(BuildContext context) {
    return CenteredMenu(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            text: 'Continue',
            icon: Icons.play_arrow,
            color: Palette.blue,
            onPressed: state.onContinue,
          ),
          const VBox(10),
          MenuButton(
            text: 'Load game',
            icon: Icons.upload,
            color: Palette.blue,
            onPressed: state.onLoadGame,
          ),
          const VBox(10),
          MenuButton(
            text: 'Save game',
            icon: Icons.save,
            color: Palette.blue,
            onPressed: state.onSaveGame,
          ),
          const VBox(10),
          MenuButton(
            text: 'Settings',
            icon: Icons.settings,
            color: Palette.blue,
            onPressed: state.onSettings,
          ),
        ],
      ),
    );
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
    return ContextualMenu(
      position: menuInfo.realPosition!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            menuInfo.node!.type.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Palette.white,
            ),
          ),
          if (menuInfo.node!.needsRepair)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: MenuButton(
                text: 'Repair',
                icon: Icons.build,
                color: Palette.green,
                onPressed: () => state.onRepair(menuInfo.node!),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: MenuButton(
              text: 'Destroy',
              icon: Icons.delete,
              color: Palette.red,
              onPressed: () => state.onDestroyNode(menuInfo.node!),
            ),
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
          Text(
            '${menuInfo.gamePosition!.dx}, ${menuInfo.gamePosition!.dy}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Palette.white,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Build',
            icon: Icons.construction,
            color: Palette.blue,
            onPressed: () => state.onBuild(menuInfo),
          ),
        ],
      ),
    );
  }
}

class BuildMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const BuildMenu({
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
          MenuButton(
            text: 'Mine',
            icon: Icons.factory,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.mine,
              position: menuInfo.gamePosition!,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Power plant',
            icon: Icons.bolt,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.power_plant,
              position: menuInfo.gamePosition!,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Defense',
            icon: Icons.cell_tower_outlined,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.defense,
              position: menuInfo.gamePosition!,
            ),
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

class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const MenuButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: const Size(0, 45),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const HBox(5),
          Text(text.toUpperCase()),
        ],
      ),
    );
  }
}
