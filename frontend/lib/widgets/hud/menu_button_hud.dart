import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/utils/palette.dart';

class MenuButtonHud extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const MenuButtonHud({
    required this.game,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            onTap: game.onOpenMainMenu,
            icon: Icons.menu,
          ),
          MenuButton(
            onTap: game.onOpenConstructionMenu,
            icon: Icons.construction,
          ),
          MenuButton(
            onTap: game.onOpenResearchMenu,
            icon: Icons.science,
          ),
          MenuButton(
            onTap: game.onOpenMilitaryMenu,
            icon: Icons.shield,
          ),
          MenuButton(
            onTap: game.onOpenMap,
            icon: Icons.public,
          ),
          MenuButton(
            onTap: game.onOpenReportsMenu,
            icon: Icons.history_edu_rounded,
          ),
          MenuButton(
            onTap: game.onOpenVillagesOverviewMenu,
            icon: Icons.list_alt,
          ),
          MenuButton(
            onTap: game.onOpenExpeditionsMenu,
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
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Palette.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
