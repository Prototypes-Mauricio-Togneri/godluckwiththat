import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class MenuButtonHud extends StatelessWidget {
  final GameState state;

  const MenuButtonHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuButton(
                color: Palette.grey,
                onTap: state.onOpenMainMenu,
                icon: Icons.menu,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuButton(
                color: Palette.error,
                onTap: state.onPassTurn,
                icon: Icons.forward,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Label(
            text: 'TURN ${state.turn}',
            size: 18,
            color: Palette.white,
          ),
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final IconData icon;

  const MenuButton({
    required this.color,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Palette.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
