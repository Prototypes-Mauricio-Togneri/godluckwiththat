import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';

class MenuButtonHud extends StatelessWidget {
  final GameState state;

  const MenuButtonHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            onTap: state.onOpenMainMenu,
            icon: Icons.menu,
          ),
          MenuButton(
            onTap: state.onOpenMilitaryMenu,
            icon: Icons.shield,
          ),
          MenuButton(
            onTap: state.onOpenMap,
            icon: Icons.public,
          ),
          MenuButton(
            onTap: state.onOpenReportsMenu,
            icon: Icons.history_edu_rounded,
          ),
          MenuButton(
            onTap: state.onOpenExpeditionsMenu,
            icon: Icons.route,
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const MenuButton({
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.grey,
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
