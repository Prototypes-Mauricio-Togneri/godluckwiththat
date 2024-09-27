import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';

class BottomMenu extends StatelessWidget {
  final GameState state;

  const BottomMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomMenuButton(
            icon: Icons.home,
            onPressed: state.onMenuBuildings,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.people,
            onPressed: state.onMenuPopulation,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.science,
            onPressed: state.onMenuResearch,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.church,
            onPressed: state.onMenuReligion,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.shield,
            onPressed: state.onMenuMilitary,
          ),
        ],
      ),
    );
  }
}

class BottomMenuButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const BottomMenuButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.darkGrey,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 30,
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
