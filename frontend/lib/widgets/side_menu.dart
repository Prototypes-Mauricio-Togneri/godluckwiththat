import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/woodcutter.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class SideMenu extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const SideMenu(this.game, this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Palette.grey,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          FixedButtons(game),
          if (game.constructMode)
            ConstructMenu(game)
          else if (game.isSelected(Woodcutter))
            WoodcutterMenu(
              game,
              game.selectedNode(),
            )
          else if (game.isInSpecialMode)
            CancelMenu(game),
        ],
      ),
    );
  }
}

class FixedButtons extends StatelessWidget {
  final GameComponent game;

  const FixedButtons(this.game);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomMenuButton(
          icon: Icons.menu,
          color: Palette.lightGrey,
          onClick: game.openMainMenu,
        ),
        const HBox(10),
        BottomMenuButton(
          icon: Icons.construction,
          color: Palette.lightGrey,
          onClick: game.toggleConstructMode,
        ),
        const HBox(10),
        BottomMenuButton(
          icon: Icons.delete,
          color: Palette.lightGrey,
          onClick: game.enableDestroyingMode,
        ),
        const HBox(10),
        BottomMenuButton(
          icon: Icons.remove_red_eye,
          color: Palette.lightGrey,
          onClick: game.onShowDetails,
        ),
      ],
    );
  }
}

class ConstructMenu extends StatelessWidget {
  final GameComponent game;

  const ConstructMenu(this.game);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            text: 'Woodcutter',
            icon: Icons.center_focus_strong,
            color: Palette.primary,
            size: 9,
            onPressed: () => _onBuild(NodeType.woodcutter),
          ),
          MenuButton(
            text: 'Quarry',
            icon: Icons.center_focus_strong,
            color: Palette.primary,
            size: 9,
            onPressed: () => _onBuild(NodeType.quarry),
          ),
        ],
      ),
    );
  }

  void _onBuild(NodeType type) {
    game.enableBuildingMode(type);
  }
}

class WoodcutterMenu extends StatelessWidget {
  final GameComponent game;
  final Woodcutter woodcutter;

  const WoodcutterMenu(this.game, this.woodcutter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: woodcutter.type.name.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          Label(
            text: '${woodcutter.location.i}, ${woodcutter.location.j}',
            align: TextAlign.center,
          ),
          const VBox(10),
          MenuButton(
            text: 'Center',
            icon: Icons.filter_tilt_shift,
            color: Palette.primary,
            onPressed: () => _onCenter(woodcutter),
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
      ),
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

class CancelMenu extends StatelessWidget {
  final GameComponent game;

  const CancelMenu(this.game);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MenuButton(
        text: 'Cancel',
        icon: Icons.close,
        color: Palette.error,
        onPressed: game.onCancelOperation,
      ),
    );
  }
}

class BottomMenuButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onClick;

  const BottomMenuButton({
    required this.icon,
    required this.color,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onClick,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
            ),
          ),
        ),
      ),
    );
  }
}
