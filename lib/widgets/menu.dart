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

class NodeMenu extends StatelessWidget {
  final GameState state;
  final MenuInfo menuInfo;

  const NodeMenu({
    required this.state,
    required this.menuInfo,
  });

  @override
  Widget build(BuildContext context) {
    return MenuContainer(
      position: menuInfo.realPosition,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            menuInfo.node!.type.name.toUpperCase(),
            style: const TextStyle(
              color: Palette.white,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Destroy',
            icon: Icons.delete,
            color: Palette.red,
            onPressed: () => state.onDestroyNode(menuInfo.node!),
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
    return MenuContainer(
      position: menuInfo.realPosition,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
    return MenuContainer(
      position: menuInfo.realPosition,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            text: 'Mine',
            icon: Icons.factory,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.mine,
              position: menuInfo.gamePosition,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Power plant',
            icon: Icons.bolt,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.power_plant,
              position: menuInfo.gamePosition,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Tower',
            icon: Icons.cell_tower_outlined,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.tower,
              position: menuInfo.gamePosition,
            ),
          ),
          const VBox(10),
          MenuButton(
            text: 'Wall',
            icon: Icons.width_normal_outlined,
            color: Palette.blue,
            onPressed: () => state.onCreateNode(
              type: NodeType.wall,
              position: menuInfo.gamePosition,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuContainer extends StatelessWidget {
  final Offset position;
  final Widget child;

  const MenuContainer({
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
        child: child,
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
        minimumSize: const Size(150, 40),
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
          Text(text),
        ],
      ),
    );
  }
}
