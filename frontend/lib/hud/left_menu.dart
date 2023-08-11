import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/menu_button_hud.dart';
import 'package:gatewayguardians/hud/resources_hud.dart';
import 'package:gatewayguardians/types/menu_type.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.grey,
      width: 300,
      height: double.infinity,
      child: Column(
        children: [
          ResourcesHud(state),
          MenuButton(
            text: 'TOWN CENTER',
            color: Palette.success,
            icon: Icons.location_city,
            onPressed: () => state.openMenu(MenuType.headquarters),
          ),
          MenuButton(
            text: 'WATER',
            color: Palette.success,
            icon: Icons.water_drop,
            onPressed: () => state.openMenu(MenuType.water),
          ),
          MenuButton(
            text: 'FOOD',
            color: Palette.success,
            icon: Icons.restaurant,
            onPressed: () => state.openMenu(MenuType.food),
          ),
          MenuButton(
            text: 'WOOD',
            color: Palette.success,
            icon: Icons.forest,
            onPressed: () => state.openMenu(MenuType.wood),
          ),
          MenuButton(
            text: 'STONE',
            color: Palette.success,
            icon: Icons.landscape,
            onPressed: () => state.openMenu(MenuType.stone),
          ),
          const Spacer(),
          MenuButtonHud(state),
        ],
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
    return Container(
      width: double.infinity,
      height: 50,
      color: color,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 1,
              left: 15,
              right: 15,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    icon,
                    color: Palette.white,
                    size: 24,
                  ),
                ),
                Label(
                  text: text.toUpperCase(),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
