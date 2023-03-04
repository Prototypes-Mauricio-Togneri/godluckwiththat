import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class BottomMenu extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const BottomMenu(this.game, this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Palette.grey,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (game.isInSpecialMode) CancelMenu(game),
          FixedButtons(game),
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
          onClick: game.enableConstructMode,
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

class CancelMenu extends StatelessWidget {
  final GameComponent game;

  const CancelMenu(this.game);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MenuButton(
        text: 'Cancel',
        icon: Icons.close,
        color: Palette.error,
        topPadding: 0,
        onPressed: game.onCancelOperation,
      ),
    );
  }
}
